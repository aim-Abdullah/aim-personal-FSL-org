public class StudyModelData {

	public static void refreshRefData() {

		StudyNoteModelData.deleteData();
		deleteData();
		
		StudyModelData.createData(); 
		StudyNoteModelData.createData();
	}	
	
	public static void deleteData() {
		List<sObject> delRecords = [ select id from Study__c ];
		delete delRecords;
	}

    public static void createData() {
        
        integer dataCount = [select count() from Study__c];
        if ( dataCount <> 0) return;
        
        RecordType ProjectStudyRecType = RecordTypeModel.LookupRecordType('Study__c','Project');
        RecordType StudyStudyRecType = RecordTypeModel.LookupRecordType('Study__c','Study');
        
        List<Study__c> studyList = new List<Study__c>();
        
        
        studyList.add( new study__c(name= 'DummyProject1',Title__c='Dummy Project 1', 
        	RecordTypeId = ProjectStudyRecType.id, 
        	Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,
        	Acronym__c=null,Investigator__c=null,Latest_Study_status__c=null,
        	Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,
        	Study_Type__c='Interventional - Non Drug'));        
        	                
        	                
      	//study data

        studyList.add( new study__c(name= '20110107',Title__c='Avanti Patient Use Study', 
        	RecordTypeId = StudyStudyRecType.id, 
        	Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,
        	Acronym__c=null,Investigator__c=null,Latest_Study_status__c=null,
        	Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,
        	Study_Type__c='Interventional - Non Drug'));        
        	        
        studyList.add( new study__c(name= '20110185',Title__c='Enbrel PsO Inflamm Joints Pilot Study', 
        	RecordTypeId = StudyStudyRecType.id, 
        	Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,
        	Acronym__c=null,Investigator__c=null,Latest_Study_status__c=null,
        	Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,
        	Study_Type__c='Interventional - Standard'));              
        	  
        studyList.add( new study__c(name= '20110186',Title__c='Enbrel RA Remission Study', RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c=null,Latest_Study_status__c=null,Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Interventional - Standard'));                
        studyList.add( new study__c(name= '20110239',Title__c='Enbrel Pain Study - formulation buffer and needle impact', RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c=null,Latest_Study_status__c=null,Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Interventional - Non Drug'));                
        studyList.add( new study__c(name= '20119001',Title__c=NULL, 
        	RecordTypeId = StudyStudyRecType.id, 
        	Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,
        	Acronym__c='Rheumatoid Arthritis',Investigator__c='Bili Androniki',Latest_Study_status__c='Cancelled',
        	Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,
        	Study_Type__c=NULL));                
        	
        studyList.add( new study__c(name= '20119004',Title__c=NULL, 
        	RecordTypeId = StudyStudyRecType.id, 
        	Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,
        	Acronym__c='Rheumatoid Arthritis 2',Investigator__c='Al-Aly Ziyad',Latest_Study_status__c='Proposal Review',
        	Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,
        	Study_Type__c=NULL));        
        	        
      	
        studyList.add( new study__c(name= '20119007',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c='Psoriasis',Investigator__c='Mehta Nehal',Latest_Study_status__c='Cancelled',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c=NULL));                
        studyList.add( new study__c(name= '20119023',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Pope Janet',Latest_Study_status__c='Study Start Up',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Interventional - Standard'));                
        studyList.add( new study__c(name= '20119034',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c='Elderly RA - Retro',Investigator__c='Bensen William',Latest_Study_status__c='In Progress',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Retrospective - Chart Review'));                
        studyList.add( new study__c(name= '20119041',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Keystone Edward',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Prospective'));                
        studyList.add( new study__c(name= '20119061',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Bissonnette Robert',Latest_Study_status__c='In Progress',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Prospective'));                
        studyList.add( new study__c(name= '20119084',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Keystone Edward',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c=NULL));                
        studyList.add( new study__c(name= '20119085',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Bissonnette Robert',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Retrospective - Analysis of Existing Data'));                
        studyList.add( new study__c(name= '20119086',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Inman Robert',Latest_Study_status__c='Study Start Up',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Prospective'));                
        studyList.add( new study__c(name= '20119110',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Aronson Peter',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c=NULL));                
        studyList.add( new study__c(name= '20119187',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c='Enbrel ISS Koo 2',Investigator__c='Koo John',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Interventional - Standard'));                
        studyList.add( new study__c(name= '20119205',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c='Enbrel Knowles-Lisse',Investigator__c='Knowles Susan',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Prospective'));                
        studyList.add( new study__c(name= '20119210',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c='PASQ',Investigator__c='Landells Ian',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Prospective'));                
        studyList.add( new study__c(name= '20119212',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c=null,Investigator__c='Chow Andrew',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Retrospective - Chart Review'));                
        studyList.add( new study__c(name= '20119218',Title__c=NULL, RecordTypeId = StudyStudyRecType.id, Project_Sponsor__c=DepartmentModel.DepartmentNameMap.get('Medical Research (Phase III-b, IV)').Id,Acronym__c='Enbrel Toussi Walsh TNF I',Investigator__c='Toussi Shelly',Latest_Study_status__c='Proposal Review',Study_TA__c=TherapeuticAreaModel.TaMap.get('Inflammation').Id,Study_Type__c='Observational Prospective',Pass__c=true));                
        
        
        insert studyList;
    
    }

}