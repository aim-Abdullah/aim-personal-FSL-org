public without sharing class PubMeModelNoSharing {

	public static void PersistPubMeList( List<sObject> pubMeList) {
		
		//All Or Nothing - should be set to true - and generate error if any row failed to persist
		database.update(pubMeList, true);
	}
	
	// pubMeList includes all Writing roles from the ALL submission cycleS - need to filter to only current cycle
	// it must be sorted in order of created date for this function to work....
	// we will order it by name - which is an autonumber in the SOQL retrieval
	
	/*
	public static List<PubME__C> copyMEforResent(List<PubMe__c> PubMeList, id PubId, SubmissionCycle__c CurrentSubmissionCycle, FPR_Cycle__c fromFprCycle, FPR_Cycle__c toFprCycle) {
		AppLogModel.LogInfo('PubMeModelNoSharing::copyMEforResent', 'invoking copyMEforResent');
		return copyME(PubMeList, PubId, CurrentSubmissionCycle, fromFprCycle, CurrentSubmissionCycle, toFprCycle);
	}
	*/
	
	public static List<PubME__C> copyMEforNewSubmissionCycle(List<PubMe__c> PubMeList, id PubId, SubmissionCycle__c CurrentSubmissionCycle, 
		SubmissionCycle__c nextSubCycle, FPR_Cycle__c nextFprCycle, Id resentPubStatusId) {
			
		AppLogModel.LogInfo('PubMeModelNoSharing::copyMEforNewSubmissionCycle', 'invoking copyMEforNewSubmissionCycle', PubId);
		return copyME(PubMeList, PubId, CurrentSubmissionCycle, null, nextSubCycle,  nextFprCycle, resentPubStatusId);
	}	
	
	//same SC - New FC / MC
	public static 	List<PubME__C> copyMEforMaterialChange (List<PubMe__c> PubMeList, id PubId, SubmissionCycle__c fromSubmissionCycle, FPR_Cycle__c fromFprCycle,
		SubmissionCycle__c toSubCycle, FPR_Cycle__c toFprCycle, Id resentPubStatusId) {
			
		AppLogModel.LogInfo('PubMeModelNoSharing::copyMEforNewSubmissionCycle', 'invoking copyMEforNewSubmissionCycle', PubId);
		return copyME(PubMeList, PubId, fromSubmissionCycle, fromFprCycle, toSubCycle,  toFprCycle, resentPubStatusId);
	}
	
	public static 	List<PubME__C> copyMEforNonMaterialChange (List<PubMe__c> PubMeList, id PubId, id recentPubStatusId) {
		AppLogModel.LogInfo('PubMeModelNoSharing::copyMEforNonMaterialChange', 
			'invoking copyMEforNonMaterialChange with PubMeList.size() = '+PubMeList.size(), PubId);
		
		//Find Max ME
		integer MaxtMeCycleNum = 0;
		for(PubMe__c pubme : PubMeList){
			if (pubme.MeCycleNum__c > MaxtMeCycleNum) {
				MaxtMeCycleNum = Integer.valueOf(pubme.MeCycleNum__c);
			}
		}
		
		AppLogModel.LogDebug('PubMeModelNoSharing::copyMEforNonMaterialChange', 
			'MaxMeCycleNum = '+MaxtMeCycleNum, PubId);
		
		//make a copy of all PubME
		PubME__c pubMeFirstWC = null; 
		List<PubME__c> pubMeOtherList = new List<PubME__c>();
		boolean foundFirstWC = false; 
		integer NextMeCycleNum = MaxtMeCycleNum + 1;
		
		for(PubME__C pubme : PubMeList) {
			if ( pubme.MeCycleNum__c == MaxtMeCycleNum) {
				boolean isWritingCoordinatorRole = AppearRoleModel.isWritingCoordinatorRole(pubMe.AppearRole__c);
				if (!foundFirstWC && isWritingCoordinatorRole) {
					AppLogModel.LogInfo('PubMeModelNoSharing::copyMEforNonMaterialChange', 'Found PubME - first WC - '+pubme, PubId);			
					
					foundFirstWC = true;
					
					pubMeFirstWC = new PubME__c();
					pubMeFirstWC.AppearRole__c = pubMe.AppearRole__c;
					pubMeFirstWC.WritingRoleMember__c = pubMe.WritingRoleMember__c;
					pubMeFirstWC.Publication__c = PubId;
					pubMeFirstWC.Submission_Cycle__c = pubMe.Submission_Cycle__c;
					pubMeFirstWC.FPR_Cycle__c = pubMe.FPR_Cycle__c; 
					pubMeFirstWC.MeCycleNum__c = NextMeCycleNum;
					pubMeFirstWC.ActualME__c = 0.0;
					pubMeFirstWC.CalculatedME__c = 0.0;
					pubMeFirstWC.LegacyPrior_ActualME__c = 0.0;
					pubMeFirstWC.OverrideME__c = 0.0;
					pubMeFirstWC.ReasonForMEChange__c = '';
					pubMeFirstWC.Department__c = (pubME.Department__c != null && pubME.Department__r.isLogicallyDeleted__c == true) ? null : pubME.Department__c;
        			pubMeFirstWC.Organization__c = (pubME.Organization__c != null && pubME.Organization__r.isLogicallyDeleted__c == true) ? null : pubME.Organization__c;
					pubMeFirstWC.Emp_Type__c = pubME.Emp_Type__c;
					pubMeFirstWC.PubStatus__c = recentPubStatusId;
					insert pubMeFirstWC;  
					
					AppLogModel.LogInfo('PubMeModel::copyMEforNonMaterialChange', 'inserted - First WC - ' + pubMeFirstWC, PubId );
				} else {
					
					//now just duplicate the rest of ME record
					PubME__c pubOtherMe = new PubME__c();
					pubOtherMe.AppearRole__c = pubMe.AppearRole__c;
					pubOtherMe.WritingRoleMember__c = pubMe.WritingRoleMember__c;
					pubOtherMe.Publication__c = PubId;
					pubOtherMe.Submission_Cycle__c = pubMe.Submission_Cycle__c;
					pubOtherMe.FPR_Cycle__c = pubMe.FPR_Cycle__c;
					pubOtherMe.MeCycleNum__c = NextMeCycleNum;
					pubOtherMe.ActualME__c = 0.0;
					pubOtherMe.CalculatedME__c = 0.0;
					pubOtherMe.LegacyPrior_ActualME__c = 0.0;
					pubOtherMe.OverrideME__c = 0.0;
					pubOtherMe.ReasonForMEChange__c = '';	
					pubOtherMe.Department__c = (pubME.Department__c != null && pubME.Department__r.isLogicallyDeleted__c == true) ? null : pubME.Department__c;
        			pubOtherMe.Organization__c = (pubME.Organization__c != null && pubME.Organization__r.isLogicallyDeleted__c == true) ? null : pubME.Organization__c;
					pubOtherMe.Emp_Type__c = pubME.Emp_Type__c;
					pubOtherMe.PubStatus__c = recentPubStatusId;
					
					pubMeOtherList.add(pubOtherMe);		
				}				
			} else {
				AppLogModel.LogInfo('PubMeModel::copyMEforNonMaterialChange', 'skipped - pubME.MeCycleNum__c <> ' + MaxtMeCycleNum, pubId);
			}
		}
		
		insert pubMeOtherList;
		AppLogModel.LogInfo('PubMeModel::copyMEforNonMaterialChange', 'inserted - pubMeOtherList. size= ' + pubMeOtherList.size(), PubId );
		if (pubMeFirstWC <> null ) {
			pubMeOtherList.add(pubMeFirstWC);
		}
		AppLogModel.flushLogs();
		return pubMeOtherList;
	}
	

	//overload created just for deployment - to be deleted
	public static 	List<PubME__C> copyME (List<PubMe__c> PubMeList, id PubId, SubmissionCycle__c fromSubmissionCycle, FPR_Cycle__c fromFprCycle,
		SubmissionCycle__c toSubCycle, FPR_Cycle__c toFprCycle) {
		return null;
	}

	public static 	List<PubME__C> copyME (List<PubMe__c> PubMeList, id PubId, SubmissionCycle__c fromSubmissionCycle, FPR_Cycle__c fromFprCycle,
		SubmissionCycle__c toSubCycle, FPR_Cycle__c toFprCycle, Id PubStatusId) {
	
		String paramMsg = '';
		AppLogModel.LogInfo('PubMeModelNoSharing::copyME', 'invoking copyME ' + paramMsg, PubId);
		
		//only copy the first WC and mark new record as isResend
		PubME__c pubMeFirstWC = null;
		List<PubME__c> pubMeOtherList = new List<PubME__c>();
		
		boolean copyAllFprCycle = false;
		Id previousFprCycleId = null;
		Fpr_Cycle__c prevFC;
		
		if ( fromFprCycle == null) {
			copyAllFprCycle = true;
			AppLogModel.LogInfo('PubMeModelNoSharing::copyME', ' copyAllFprCycle = '+copyAllFprCycle, PubId );
		} else {
			AppLogModel.LogInfo('PubMeModelNoSharing::copyME', ' prev FC.num = ' + fromFprCycle.FPR_Cycle_Num__c, PubId);
		}
		
		
		Decimal lastMeCycleNum = 0.0;
		for(PubMe__c pubme : PubMeList){
			if (pubme.MeCycleNum__c > lastMeCycleNum) {
				lastMeCycleNum = pubme.MeCycleNum__c;		
			}
		}
		integer NextMeCycleNum = Integer.valueOf(lastMeCycleNum) + 1;
		
		boolean foundFirstWC = false;  
		for(PubME__C pubme : PubMeList) {
			if ( pubMe.Submission_Cycle__c == fromSubmissionCycle.Id && (copyAllFprCycle || pubME.MeCycleNum__c == lastMeCycleNum) ) {
				//post release 2.0 change - use ME to differentiate for legacy records -  pubMe.FPR_Cycle__c == fromFprCycle.Id
				
				boolean isWritingCoordinatorRole = AppearRoleModel.isWritingCoordinatorRole(pubMe.AppearRole__c);
				if (!foundFirstWC && isWritingCoordinatorRole) {
					AppLogModel.LogInfo('PubMeModelNoSharing::copyME', 'Found PubME - first WC -  '+pubme, PubId);			
					
					foundFirstWC = true;
					
					pubMeFirstWC = new PubME__c();
					pubMeFirstWC.AppearRole__c = pubMe.AppearRole__c;
					pubMeFirstWC.WritingRoleMember__c = pubMe.WritingRoleMember__c;
					pubMeFirstWC.Publication__c = PubId;
					pubMeFirstWC.Submission_Cycle__c = toSubCycle.id;
					pubMeFirstWC.FPR_Cycle__c = toFprCycle.Id;
					pubMeFirstWC.MeCycleNum__c = NextMeCycleNum;
					pubMeFirstWC.ActualME__c = 0.0;
					pubMeFirstWC.CalculatedME__c = 0.0;
					pubMeFirstWC.LegacyPrior_ActualME__c = 0.0;
					pubMeFirstWC.OverrideME__c = 0.0;
					pubMeFirstWC.ReasonForMEChange__c = '';
					pubMeFirstWC.Department__c = (pubME.Department__c != null && pubME.Department__r.isLogicallyDeleted__c == true) ? null : pubME.Department__c;
        			pubMeFirstWC.Organization__c = (pubME.Organization__c != null && pubME.Organization__r.isLogicallyDeleted__c == true) ? null : pubME.Organization__c;
					pubMeFirstWC.Emp_Type__c = pubME.Emp_Type__c;
					pubMeFirstWC.PubStatus__c = PubStatusId;

					insert pubMeFirstWC;  
					
					AppLogModel.LogInfo('PubMeModel::copyME', 'inserted - First WC - ' + pubMeFirstWC, PubId );
				} else {
					
					//now just duplicate the rest of ME record
					PubME__c pubOtherMe = new PubME__c();
					pubOtherMe.AppearRole__c = pubMe.AppearRole__c;
					pubOtherMe.WritingRoleMember__c = pubMe.WritingRoleMember__c;
					pubOtherMe.Publication__c = PubId;
					pubOtherMe.Submission_Cycle__c = toSubCycle.Id;
					pubOtherMe.FPR_Cycle__c = toFprCycle.Id;
					pubOtherMe.MeCycleNum__c = NextMeCycleNum;
					pubOtherMe.ActualME__c = 0.0;
					pubOtherMe.CalculatedME__c = 0.0;
					pubOtherMe.LegacyPrior_ActualME__c = 0.0;
					pubOtherMe.OverrideME__c = 0.0;
					pubOtherMe.ReasonForMEChange__c = '';	
					pubOtherMe.Department__c = (pubME.Department__c != null && pubME.Department__r.isLogicallyDeleted__c == true) ? null : pubME.Department__c;
        			pubOtherMe.Organization__c = (pubME.Organization__c != null && pubME.Organization__r.isLogicallyDeleted__c == true) ? null : pubME.Organization__c;
					pubOtherMe.Emp_Type__c = pubME.Emp_Type__c;
					pubOtherMe.PubStatus__c = PubStatusId;
					
					pubMeOtherList.add(pubOtherMe);		
				}
			} else {
				
				string msg = '';
				if (pubMe.Submission_Cycle__c != fromSubmissionCycle.Id  ) {
					msg +=' skipped due to non current SC. ';
				}
				
				//if (pubMe.FPR_Cycle__c == fromFprCycle.Id  ) {
					//msg +=' skipped due to non different FprCycleId '+pubMe.FPR_Cycle__c + ' '+ fromFprCycle.Id ;
				if (pubME.MeCycleNum__c == lastMeCycleNum) {
					msg +=' skipped due to non different pubME.MeCycleNum__c '+pubME.MeCycleNum__c + ' '+ lastMeCycleNum;
				}
				
				AppLogModel.LogInfo('PubMeModelNoSharing::copyME', 
					'skip PubME - '+pubme.WritingRoleMember__r.name + 
					' SC = '+ pubme.Submission_Cycle__r.Submission_Cycle_Num__c +
					' FC = '+ pubme.FPR_Cycle__r.FPR_Cycle_Num__c, PubId);	
			}
		}	
		
		//de-dupe - priority given to WC
		//de-dupe by wc + Role
		
		Set<String> pubMeIdSet = new Set<string>();
		if ( pubMeFirstWc <> null) {
			string firstKey = pubMeFirstWC.WritingRoleMember__c + ' ' + pubMeFirstWC.Department__C + ' ' + pubMeFirstWC.Organization__C + ' ' + pubMeFirstWC.AppearRole__c;
			pubMeIdSet.add(firstKey);
		}
		
		List<PubME__C> pubMeNoDupe = new List<PubMe__c>();
		for(PubME__C pubMe : pubMeOtherList) {
			string key = pubMe.WritingRoleMember__c + ' ' + pubMe.Department__C + ' ' + pubMe.Organization__C + ' ' + pubMe.AppearRole__c;
			if ( pubMeIdSet.contains(key)) {
				//dupe - ignore
			} else {
				pubMeNoDupe.add(pubme);
				pubMeIdSet.add(key);
			}
		}
		
		//now insert the rest - that will give the first WC the lowest autonumber in the name field
		insert pubMeNoDupe;

		if (pubMeFirstWC <> null ) {
			pubMeNoDupe.add(pubMeFirstWC);
		}
				
		AppLogModel.flushLogs();
		return pubMeNoDupe;
	}
}