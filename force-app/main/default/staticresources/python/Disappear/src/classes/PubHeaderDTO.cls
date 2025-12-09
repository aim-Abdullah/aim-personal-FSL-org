public class PubHeaderDTO {

	private AppearPubModel AppearPub = null;
	
	public PubHeaderDTO(AppearPubModel AppearPub) {
		this.AppearPub = AppearPub;
	}
	
	public string PubId {
		get {
			return AppearPub.PubName;
		}
	}
	
	public string PubTitle {
		get {
			return AppearPub.PubTitle;
		}
	}
	
	public string CurrentSubmissionCycle {
		get {
			return string.valueOf(AppearPub.PubRecord.Current_Submission_Cycle_Num__c);
		}
	}

	public string CurrentFprCycle {
		get {
			return AppearPub.PubRecord.Current_FPR_Cycle_Num__c;
		}
	}

	public string PubType {
		get {
			return AppearPub.PubType;
		}
	}

	public string CurrentStatus {
		get {
			return AppearPub.PubRecord.Current_Status_FormulaField__c; 
		}
	}
	
	public string Authors {
		get {
			return AppearPub.Authors;
		}
	}
	
	public string CurrentTarget {
		get {
			return AppearPub.CurrentTarget;
		}
	}
	
	public string AssignedFPRC {
		get{
			return AppearPub.PubRecord.Assigned_FPRC__r.name;
		}
	}
	
	public string FPRSubmitter {
		get{
			return AppearPub.PubRecord.FPR_Submitter__r.name;
		}
	}
	
	public boolean HasUSAuthors {
		get {
			return AppearPub.PubRecord.HasUSAuthors__c;
		}
	}
	
	public string HasUSAuthorsMsg {
		get {  
			if ( AppearPub.PubRecord.HasUSAuthors__c) {
				return 'Yes';
			} else {
				return 'No';
			}
		}
	}
	
	public date TargetSubmissionDate {
		get {
			return AppearPub.PubRecord.Target_Submission_Date__c;
		}
	}
	
}