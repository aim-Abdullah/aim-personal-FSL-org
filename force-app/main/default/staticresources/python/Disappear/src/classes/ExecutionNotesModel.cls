public with sharing class ExecutionNotesModel {

	private id PubId;
	private string ActiveTile;
	private string ActiveSubMenu;
	
	private string origExecutionNotes;
	private dateTime origExecutionNotesLastMod;
	private AppearPubModel activePub;
	
	public string Notes { get; set; }
	public string SingleNote { get; set; }
	public string NotesReadOnly { get; set; }
	
	public ExecutionNotesModel(Id PubId, string tile, string subMenu, AppearPubModel activePub) {
		this.activePub = activePub;
		this.ActiveTile = tile;
		this.ActiveSubMenu = subMenu;
		this.PubId = PubId;
		
		origExecutionNotes = activePub.pubRecord.Execution_Notes__c;
		origExecutionNotesLastMod = activePub.pubRecord.Execution_Notes_Last_Mod__c;
	
		if ( origExecutionNotes == null) {
			Notes = '';
		} else {
			Notes = origExecutionNotes;
		}
		
		SingleNote = '';
		
		if ( ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin) {
			NotesReadOnly = 'false';
		} else { 
			NotesReadOnly = 'true';
		}
		
		//test readonly first
		//NotesReadOnly = 'true';
		
	}

	public PageReference SaveComment() {
		
		AppLogModel.LogInfo('ExecutionNotesModel::SaveComment','invoked SaveComment', pubId);
		if ( NotesReadOnly == 'false' && Notes <> origExecutionNotes) {
			publication__c updPub = [
				select Execution_Notes__c, Execution_Notes_Last_Mod__c
				from publication__c
				where id = :pubId
				for update
			];
			
			if (updPub.Execution_Notes_Last_Mod__c == origExecutionNotesLastMod ) {
				DateTime updTime = DateTime.now();
				
				updPub.Execution_Notes__c = Notes;
				updPub.Execution_Notes_Last_Mod__c = updTime;
				update updPub;
				
				activePub.pubRecord.Execution_Notes__c = Notes;
				activePub.pubRecord.Execution_Notes_Last_Mod__c = updTime;
				
				AppLogModel.LogInfo('ExecutionNotesModel::SaveComment','SA/BA updated Execution Note successfully', pubId);
				
				/*
				AppLogModel.flushLogs();
				return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
				*/
				
			} else {
				
				// warning message that we cannot save
				AppLogModel.LogError('ExecutionNotesModel::SaveComment','SA/BA cannot updated Execution Note', pubId);
				AppLogModel.flushLogs();
				return null;
			}
			
		}
		
		
		if (SingleNote <> null && SingleNote.length() > 0 ) {
		
			if ( activePub.pubRecord.Execution_Notes__c == null ) {
				activePub.pubRecord.Execution_Notes__c = '';
			}
		
			Notes = activePub.pubRecord.Execution_Notes__c + '\r\n\r\n' + UserInfo.getName() +'  ' +
				string.valueOf( DateTime.Now() ) + ' - ' + 
				SingleNote;
		
			publication__c updPub = [
				select Execution_Notes__c, Execution_Notes_Last_Mod__c
				from publication__c
				where id = :pubId
				for update
			];
			
			
			
			DateTime updTime = DateTime.now();
				
			updPub.Execution_Notes__c = Notes;
			updPub.Execution_Notes_Last_Mod__c = updTime;
			update updPub;
			
			activePub.pubRecord.Execution_Notes__c = Notes;
			activePub.pubRecord.Execution_Notes_Last_Mod__c = updTime;
			AppLogModel.LogInfo('ExecutionNotesModel::SaveComment','updated Comment successfully - '+ SingleNote, pubId);
			
			
			SingleNote = '';
		} else {
			AppLogModel.LogInfo('ExecutionNotesModel::SaveComment','no Comment to update', pubId);
		}
		
		AppLogModel.flushLogs();
		
		return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
		
	}
	

	
}