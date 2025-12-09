public class AppearTriggerActivationModel {

	//AppearTriggerActivationModel.deactivateTriggersForDataMigration();
	//AppearTriggerActivationModel.activateTriggersAfterDataMigration();

	public static void deactivateTriggersForDataMigration() {
		isPublicationTriggerActive = false;
		isPubStatusTriggerActive = false;
		isCalcBusinessHourStatusTriggerActive = false;
		isCalcBusinessHourTriggerActive = false;
		isPubReviewTeamTriggerActive = false;
		isProdIndiObjectivesTriggerActive = false;
		isContactAddressesTriggerActive = false;
		isProvisionDocumentVersionTriggerActive = false;
		isPubAuthorTriggerActive = false;
		isContentVersionTriggerActive = false; //Appear Enhancement R4
	}
	
	public static void activateTriggersAfterDataMigration() {
		isPublicationTriggerActive = true;
		isPubStatusTriggerActive = true;	
		isCalcBusinessHourStatusTriggerActive = true;
		isCalcBusinessHourTriggerActive = true;	
		isPubReviewTeamTriggerActive = true;
		isProdIndiObjectivesTriggerActive  = true;
		isContactAddressesTriggerActive = true;
		isProvisionDocumentVersionTriggerActive = true;
		isPubAuthorTriggerActive = true;
		isContentVersionTriggerActive = true; //Appear Enhancement R4
	}
	
	//Appear Enhancement R4: setting the content version trigger state.
	public static boolean isContentVersionTriggerActive{
		get{
			return getTriggerState('ContentVersionTrigger');
		}
		set{
			setTriggerState('ContentVersionTrigger', value);
		}
	}

	public static boolean isPubReviewTeamTriggerActive{
		get {
			return getTriggerState('PubReviewTeamTrigger');
		}
		set {
			setTriggerState('PubReviewTeamTrigger', value);
		}
	}

	public static boolean isPublicationTriggerActive{
		get {
			return getTriggerState('PublicationTrigger');
		}
		set {
			setTriggerState('PublicationTrigger', value);
		}
	}
	
	public static boolean isPubStatusTriggerActive{
		get {
			return getTriggerState('PubStatusTrigger');
		}
		set {
			setTriggerState('PubStatusTrigger', value);
		}
	}
	
	public static boolean isCalcBusinessHourStatusTriggerActive{
		get {
			return getTriggerState('CalcBusinessHourStatus');
		}
		set {
			setTriggerState('CalcBusinessHourStatus', value);
		}
	}
	
	public static boolean isCalcBusinessHourTriggerActive{
		get {
			return getTriggerState('CalcBusinessHourTrigger');
		}
		set {
			setTriggerState('CalcBusinessHourTrigger', value);
		}
	}
	
	public static boolean isPubAuthorTriggerActive{
		get {
			return getTriggerState('PubAuthorTrigger');
		}
		set {
			setTriggerState('PubAuthorTrigger', value);
		}
	}
	
	public static boolean isPubStudyTriggerActive{
		get {
			return getTriggerState('PubStudyTrigger');
		}
		set {
			setTriggerState('PubStudyTrigger', value);
		}
	}
	
	public static boolean isProdIndiObjectivesTriggerActive {
		get {
			return getTriggerState('ProdIndiObjectivesTrigger');
		}
		set {
			setTriggerState('ProdIndiObjectivesTrigger', value);
		}
	}
		
	public static boolean isContactAddressesTriggerActive {
		get {
			return getTriggerState('ContactAddressesTrigger');
		}
		set {
			setTriggerState('ContactAddressesTrigger', value);
		}
	}
	
	public static boolean isProvisionDocumentVersionTriggerActive {
		get {
			return getTriggerState('ProvisionDocTrigger');
		}
		set {
			setTriggerState('ProvisionDocTrigger', value);
		}
	}
	
	private static boolean getTriggerState(string TriggerName) {
		TriggerName = 'TriggerState' + TriggerName;
		if ( TriggerActivationMap.containsKey(TriggerName)) {
			return TriggerActivationMap.get(TriggerName);
		} else {
			//by default - triggers are on - unless migration or an admin turn them off
			return true;
		}		
	}
	
	private static void setTriggerState(string TriggerName, boolean TriggerState) {
		TriggerName = 'TriggerState' + TriggerName;
		if ( TriggerState ){
			KeyValueSettingsModel.SetKey(TriggerName, 'active');
		} else {
			KeyValueSettingsModel.SetKey(TriggerName, 'inactive');
		}
		pTriggerActivationMap = null;
	}


	private static Map<string, boolean> pTriggerActivationMap = null;
	public static Map<string, boolean> TriggerActivationMap {
		get {
			if ( pTriggerActivationMap == null) {
				pTriggerActivationMap = new Map<string, boolean>();
				List<KeyValueSettings__c> kvList = KeyValueSettingsModel.GetKeyByPattern('TriggerState%');
				for(KeyValueSettings__c kv : kvList) {
					boolean triggerState = false;
					if ( kv.value__c == 'active') {
						triggerState = true;
					}
					pTriggerActivationMap.put(kv.key__c, triggerState);
				}
			}
			return pTriggerActivationMap; 
		}
	}
	
	//This variable is very important and is used during the FPR Cycle Changes on the PubAuthor__c
	public static boolean shouldSkipPubAuthorTrigger = false;
	public static boolean shouldSkipUsAuthorUpdate = false;
}