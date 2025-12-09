public without sharing class ProxyDelegateUtility {
	public static integer ProxyDelegateCounter = 0;
	public static integer MaxProxyDelegateCount = 3;
	public static list<Id> proxyContactIds;
	public static string lastDelegatedByName = null; //only temp. held in memory and cleared at the end of every chain of execution
	private static PubReviewTeam__c lastDelegateInChain = null; //only temp. held in memory and cleared at the end of every chain of execution	
	private static List<PubReviewTeam__c> allbeforeDelegate = new List<PubReviewTeam__c>();//only temp. held in memory and cleared at the end of every chain of execution
	
	public static void SyncUpdateWithProxies(PubReviewTeam__c updatedPrimary) {
		if (ProxyDelegateUtility.ProxyDelegateCounter == 0) {
			ProxyDelegateUtility.ProxyDelegateCounter++;
		}
		List<PubReviewTeam__c> proxyChain = GetProxiesForAndProxiedBy(updatedPrimary);
		if (proxyChain != null && proxyChain.size() > 0) {
			for(PubReviewTeam__c reviewerToSync : proxyChain) {
				reviewerToSync.HasVoted__c = updatedPrimary.HasVoted__c;
				reviewerToSync.Reviewer_Status__c = updatedPrimary.Reviewer_Status__c;
				reviewerToSync.Comments__c = updatedPrimary.Comments__c;
				reviewerToSync.TriagedTo__c = updatedPrimary.TriagedTo__c;
				reviewerToSync.Triage_Justification__c = updatedPrimary.Triage_Justification__c;
				update reviewerToSync;
			}
			
		}
	}
	
	//Returns reviewers who are proxying for or proxied by the specified reviewer. Used for synchronizing updates and email.
	public static List<PubReviewTeam__c> GetProxiesForAndProxiedBy(PubReviewTeam__c reviewerToCheck) {
		return GetProxiesForAndProxiedBy(reviewerToCheck, false, false);
	}
	
	public static string getNameFromReviewer(PubReviewTeam__c reviewer) {
		if (reviewer.SubType__c == 'Proxy') {
			return reviewer.DisplayName__c;
		}
		return reviewer.Reviewer__r.Name;
	}
	
	//Params onlyProxiedBy and onlyProxiedFor are used for bi-directional recursion.
	private static List<PubReviewTeam__c> GetProxiesForAndProxiedBy(PubReviewTeam__c reviewerToCheck, boolean onlyProxiedBy, boolean onlyProxiedFor) {
		List<PubReviewTeam__c> proxyChain = new List<PubReviewTeam__c>();
		if (reviewerToCheck.ProxyMember__c != null && !onlyProxiedFor) { //has proxy (proxiedBy)
			List<PubReviewTeam__c> firstLevelProxiedBy = [Select id, HasVoted__c, Reviewer_Status__c, Comments__c, SubType__c, ProxyMember__c, Reviewer__c from PubReviewTeam__c where id = :reviewerToCheck.ProxyMember__c];
			if (firstLevelProxiedBy.size() > 0) {
				proxyChain.add(firstLevelProxiedBy[0]);
				List<PubReviewTeam__c> proxiedByChain = GetProxiesForAndProxiedBy(firstLevelProxiedBy[0], true, false); //recurse using same function only going one direction. Only ProxiedBy
				if (proxiedByChain != null && proxiedByChain.size() > 0) {
					proxyChain.addAll(proxiedByChain);
				}
			}
		}
		if (reviewerToCheck.SubType__c == 'Proxy' && !onlyProxiedBy) { //is proxy (proxyFor)
			List<PubReviewTeam__c> firstLevelProxyFor = [Select  id, HasVoted__c, Reviewer_Status__c, Comments__c, SubType__c, ProxyMember__c, Reviewer__c from PubReviewTeam__c where ProxyMember__c = :reviewerToCheck.Id];
			if (firstLevelProxyFor.size() > 0) {
				proxyChain.add(firstLevelProxyFor[0]);
				List<PubReviewTeam__c> proxyForChain = GetProxiesForAndProxiedBy(firstLevelProxyFor[0], false, true); //recurse using same function only going one direction. Only ProxyFor
				if (proxyForChain != null && proxyForChain.size() > 0) {
					proxyChain.addAll(proxyForChain);
				}
			}
		}
		
		return proxyChain;
	}
	
	//Returns Proxied or Delegated member or Null if no action performed
	public static PubReviewTeam__c ProxyOrDelegatePrimary(PubReviewTeam__c newPrimary) {
		if ( ProxyDelegateCounter >= MaxProxyDelegateCount) {
			ProxyDelegateCounter = 0;
			return null;
		}		
		if (proxyContactIds == null) {
			proxyContactIds = new List<id>();
		}
		boolean isFirstInChain = ProxyDelegateCounter == 0;		
		PubReviewTeam__c newProxyOrDelegate = null;
		
		//First - Check for Delegate
		ContactDelegate__c delegate = ContactDelegateModel.pubfindPubReviewDelegate(newPrimary.Reviewer__c, DateTime.now().date());
		if (newPrimary.Type__c == 'Primary' && delegate != null) { //Delegate found
			ProxyDelegateCounter++;
			//TODO: De-duplicate
			PubReviewTeam__c delegateMember = new PubReviewTeam__c();
			delegateMember.Type__c = newPrimary.Type__c;
			delegateMember.FPR_Cycle__c = newPrimary.FPR_Cycle__c;
			delegateMember.IsLogicallyDeleted__c = false;
			delegateMember.Publication__c = newPrimary.Publication__c;
			delegateMember.Reviewer__c = delegate.Delegate__c;
			delegateMember.DisplayName__c = delegate.Delegate__r.name;
			delegateMember.Delivered__c = newPrimary.Delivered__c;
			delegateMember.SubType__c = 'Delegate';
			if (newPrimary.SubType__c == 'Proxy') {
				lastDelegatedByName = newPrimary.DisplayName__c;
			} else {
				lastDelegatedByName = delegate.Contact__r.Name;
			}
			
			insert delegateMember;
			newPrimary.DelegatedTo__c = delegateMember.id;
			newPrimary.Type__c = 'Notify';
			if (ProxyDelegateCounter > 1 || !AppearTriggerActivationModel.isPubReviewTeamTriggerActive) {
				update newPrimary;
			}
			
			if (allBeforeDelegate.size() > 0) {		
				List<PubReviewTeam__c> beforeDelegateToUpdate = new List<PubReviewTeam__c>();	
				for(PubReviewTeam__c beforeDelegate : allBeforeDelegate) {
					beforeDelegate.Type__c = 'Notify';
					if (beforeDelegate.SubType__c == 'Proxy' || !AppearTriggerActivationModel.isPubReviewTeamTriggerActive) {
						beforeDelegateToUpdate.add(beforeDelegate);
					}
				}
				if (beforeDelegateToUpdate.size() > 0) {
					update beforeDelegateToUpdate;
				}
				allBeforeDelegate.clear();
			}
			
			newProxyOrDelegate = delegateMember;			
		} else { //If No Delegate, Proxy			
			allBeforeDelegate.add(newPrimary);
			Contact contactWithProxy = AppearContactModel.findProxyForContactId(newPrimary.Reviewer__c);
			if (contactWithProxy != null) {	//has proxy	
				ProxyDelegateCounter++;
				//TODO: De-duplicate
				PubReviewTeam__c proxyMember = new PubReviewTeam__c();
				proxyMember.Type__c = newPrimary.Type__c;
				proxyMember.FPR_Cycle__c = newPrimary.FPR_Cycle__c;
				proxyMember.Publication__c = newPrimary.Publication__c;	
				proxyMember.TriagedTo__c = newPrimary.TriagedTo__c;
				
				proxyMember.Reviewer__c = contactWithProxy.Proxy__c;
				if (newPrimary.DisplayName__c != null) {
					proxyMember.DisplayName__c = newPrimary.DisplayName__c;
				} else {
					proxyMember.DisplayName__c = contactWithProxy.Name;
				}
				proxyMember.Delivered__c = newPrimary.Delivered__c;
				proxyMember.SubType__c = 'Proxy';
						
				insert proxyMember;	
				
				newPrimary.ProxyMember__c = proxyMember.Id;
				if (ProxyDelegateCounter > 1 || !AppearTriggerActivationModel.isPubReviewTeamTriggerActive) {
					update newPrimary;
				}
				proxyContactIds.add(contactWithProxy.Proxy__c);
				newProxyOrDelegate = proxyMember;
			}
		}
		
		if (newPrimary.SubType__c == 'Delegate') {
			//proxyContactIds = new List<id>(); //only email proxies above the delegate in the chain as the rest will be set to notify
			lastDelegateInChain = newPrimary;
		}
		
		if (newProxyOrDelegate != null) { //Check new ProxyOrDelegate for their own ProxyOrDelegate up to MaxProxyDelegateCount times
			PubReviewTeam__c nextProxyOrDelegate = ProxyOrDelegatePrimary(newProxyOrDelegate);
			if (nextProxyOrDelegate != null) {
				newProxyOrDelegate = nextProxyOrDelegate;
			}
		}
		
		if (isFirstInChain) {
			allBeforeDelegate.clear();
			if (newPrimary.Delivered__c != null && (newPrimary.Type__c == 'Primary' || lastDelegateInChain != null) ) { //send email only if pub is routed. Also only invoke this for the first inserted reviewer in the chain.
				emailReviewer(newPrimary);
				
				lastDelegateInChain = null; //clear lastDelegate after entire chain is processed. Only first in chain will enter this method. As 0 if standard, as 1 if first with a chain attached			
				proxyContactIds = new List<id>();			
			}
		}
			
		
		return newProxyOrDelegate;
	}
	
	public static void emailReviewer(PubReviewTeam__c primaryReviewer) {
		Publication__c reviewPub = PubReviewTeamTriggerLogic.getPubForEmail(primaryReviewer.Publication__c);			
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(primaryReviewer.Reviewer__c);			
		List<Id> CcAddressIds = new List<Id>();
		CcAddressIds.add(reviewPub.Fpr_Submitter__c);
		CcAddressIds.add(reviewPub.Assigned_FPRC__c);
		
		if (proxyContactIds != null && proxyContactIds.size() > 0) { //Add all proxy contacts in chain to the TO list. 
			ToAddressIds.addAll(proxyContactIds);
		}
		
		if (lastDelegateInChain != null) { //Delegate in the chain. Send delegated To email if pub is routed.
			Email_03_RoutedToDelegate email = new Email_03_RoutedToDelegate(ToAddressIds, CcAddressIds, lastDelegatedByName, lastDelegateInChain, reviewPub);
			email.sendEmail();
			
			AppLogModel.LogInfo('ProxyDelegateUtility::ProxyOrDelegatePrimary',  'send email to delegate reviewer ', reviewPub.Id);
		} else if (primaryReviewer.SubType__c == 'Triagee') { //Reviewer is primary triagee. Send TriagedTo email if pub is routed
			Email_04_RoutedToTriagee email = new Email_04_RoutedToTriagee(ToAddressIds, CcAddressIds, primaryReviewer, reviewPub);
			email.sendEmail();
		} else { //Reviewer is always primary. Send Standard Email if pub is routed 
			Email_02_RoutedForPrimary email = new Email_02_RoutedForPrimary(ToAddressIds, CcAddressIds, primaryReviewer, reviewPub);	
			email.sendEmail();
		}
	}
}