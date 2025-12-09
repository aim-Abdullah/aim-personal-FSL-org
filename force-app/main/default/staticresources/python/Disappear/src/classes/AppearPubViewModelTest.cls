@IsTest
public class AppearPubViewModelTest {

    @IsTest
    public static void UnitTest() {
        Publication__c pub = UnitTestData.PublicationNew('AppearPubViewModelTest');
        
        List<IdNameDTO>  pubIdNameDtoList = AppearPubViewModel.findPubsByName('AppearPubViewModelTes');
        System.assertEquals(1, pubIdNameDtoList.size());
        
        AppearPubViewModel.RouteForReview(pub.Id);
        AppearPubViewModel.SubmitToTarget(pub.Id);
        AppearPubViewModel.RejectPub(pub.Id);
        
    }


    @IsTest
    public static void UnitTest1a() {
        Publication__c pub = UnitTestData.PublicationNew('AppearPubViewModelTest');
        
        List<IdNameDTO>  pubIdNameDtoList = AppearPubViewModel.findPubsByName('AppearPubViewModelTes');
        System.assertEquals(1, pubIdNameDtoList.size());
        
        AppearPubViewModel.MaterialChangeForCongressJournal(pub.Id);
        
    }
    
    @IsTest
    public static void UnitTest2() {
        Publication__c pub = UnitTestData.PublicationNew('AppearPubViewModelTest');
        List<IdNameDTO>  pubIdNameDtoList = AppearPubViewModel.findPubsByName('AppearPubViewModelTes');
        System.assertEquals(1, pubIdNameDtoList.size());
        
        
        AppearPubViewModel.DeleteThisPublication(pub.Id);
        AppearPubViewModel.DeleteThisPublication(pub.Id); //should fail
        
        AppearPubViewModel.SubmitSuggestion(pub.Id);  //invalid pub
        AppearPubViewModel.SubmitForFPR(pub.Id); //invalid pub
        AppearPubViewModel.AcceptPub(pub.Id); //invalid pub
        
        
    }
     @IsTest
    public static void UnitTest3(){
        Profile profile= [select id, name from Profile where name ='APPEAR External Writer'];
        User externalWriter = new User(alias = 'external',email='externaluser@testorg.com',emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='externaluser@testorg.com');
        insert externalWriter;
        AppearRoleModelData.createData();
        AccountModelData.createData();  
        Contact contact = new Contact(UserId__c=externalWriter.Id,
        LastName= 'user', FirstName='test',
        AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,
        Email='mike@amgen.com');
        insert contact;
        
        System.runAs(externalWriter){
             Publication__c pub = UnitTestData.PublicationNew('TestExternalWriterCreatedPublication');
            
        }
        
    }
    
    @IsTest
   	public static void unitTest4(){
        Profile profile= [select id, name from Profile where name ='APPEAR External Writer'];
        User externalWriter = new User(alias = 'external',email='externaluser@testorg.com',emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='externaluser@testorg.com');
        insert externalWriter;
        AppearRoleModelData.createData();
        AccountModelData.createData();  
        Contact contact = new Contact(UserId__c=externalWriter.Id,
        LastName= 'user', FirstName='test',
        AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,
        Email='mike@amgen.com');
        insert contact;
        System.runAs(externalWriter){
            Publication__c pub = UnitTestData.PublicationNew('TestExternalWriterCreatedPublication');
            Appear_Role__c appearRole=[Select Id from Appear_Role__c where Name='Writing Coordinator'];
            System.Test.startTest();
            PubMe__c pubMe= New PubMe__c(Publication__c=pub.Id,WritingRoleMember__c=externalWriter.Id,AppearRole__c=appearRole.Id,Submission_Cycle__c=pub.Current_SubmissionCycle_Id_Formula__c);
            System.debug('---->>>'+pub);
            CloneResultDTO result = RelatedPubModel.ClonePub(pub.Id);
       		System.Test.stopTest();
        }    
         
    }
    
    //Appear Enhancement R1 & Backlog R4: 2017 : Test Class for FPR Questionnaire 
    @isTest
    public static void fprquestionTest(){
        Publication__c pub = UnitTestData.PublicationNew('AppearPubModelTest123');
        
        FPR_Only_Questions__c fprQTestRec1 = new FPR_Only_Questions__c(Answer_Field_Name__c = 'Is_ISS_Pub__c',Question_Content__c = 'Test Sample for isISS',Name= 'isISSTest');
        insert fprQTestRec1;
        
        FPR_Only_Answers__c fprATest = new FPR_Only_Answers__c(Name='Test Ans Rec1',Is_ISS_Pub__c = 'Yes',Have_Amgen_Author__c = 'No');
        insert fprATest;
        
        AppearPubViewModel appPubViewMod = new AppearPubViewModel();
        AppearPubModel appPubMod = new AppearPubModel(pub.id);
        
        System.Test.startTest();
        	appPubViewMod.getQuestionContent(null, null);
        	appPubViewMod.getReqOptions('Is_ISS_Pub__c');
        
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Have Amgen Author';
        	FPR_Only_Questions__c fprQTestRec2 = new FPR_Only_Questions__c(Error_Message__c='TestError2', Name= 'Error Message Amgen Author');
        	insert fprQTestRec2;
        	appPubViewMod.FPRQuestionresponse();
        	appPubViewMod.answerValue = 'No';
        	appPubViewMod.FPRQuestionresponse();
        	//coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.isISS__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        	
        	/*
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Does include human study or reasearch';
        	FPR_Only_Questions__c fprQTestRec3 = new FPR_Only_Questions__c(Error_Message__c='TestError3', Name= 'Error Message human study or reasearch');
        	insert fprQTestRec3;
        	appPubViewMod.FPRQuestionresponse();
        	appPubViewMod.answerValue = 'No';
        	appPubViewMod.FPRQuestionresponse();
            //coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.is_MTA__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        	*/
        
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Have Amgen Author DSR';
        	FPR_Only_Questions__c fprQTestRec3 = new FPR_Only_Questions__c(Error_Message__c='TestError3', Name= 'Error Message Amgen Author DSR');
            insert fprQTestRec3;
			System.assertEquals(fprQTestRec3.Error_Message__c, 'TestError3');
        	appPubViewMod.FPRQuestionresponse();
        	appPubViewMod.answerValue = 'No';
        	appPubViewMod.FPRQuestionresponse();
        	//coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.IsComments_Only__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        	
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Is Partner led SOP'; 
        	appPubViewMod.FPRQuestionresponse();
        	//coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.SOP_Exception__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        	
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Is this a CSP';
        	FPR_Only_Questions__c fprQTestRec4 = new FPR_Only_Questions__c(Error_Message__c='TestError4', Name= 'Error Message Is this a CSP');
            insert fprQTestRec4;
			System.assertEquals(fprQTestRec4.Error_Message__c, 'TestError4');
        	appPubViewMod.FPRQuestionresponse();
        	appPubViewMod.answerValue = 'No';
        	appPubViewMod.FPRQuestionresponse();
        	//coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.SP_Full__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        
        	/*
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Have human study or research No SOP';
        	FPR_Only_Questions__c fprQTestRec4 = new FPR_Only_Questions__c(Error_Message__c='TestError4', Name= 'Error Message study or research No SOP');
            insert fprQTestRec4;
        	appPubViewMod.FPRQuestionresponse();
        	
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.parentQuestion = 'Have data or product materials';
        	appPubViewMod.FPRQuestionresponse();
        	//coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.SP_Full__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        	appPubMod.closeQuestionModal();
        	
        	appPubViewMod.answerValue = 'No';
        	appPubViewMod.parentQuestion = 'Is self written and no discussion';
        	FPR_Only_Questions__c fprQTestRec5 = new FPR_Only_Questions__c(Error_Message__c='TestError5', Name= 'Error message written no discussion');
        	insert fprQTestRec5;
        	appPubViewMod.FPRQuestionresponse();
        	appPubViewMod.answerValue = 'Yes';
        	appPubViewMod.FPRQuestionresponse();
        	//coverage for AppearPubModel save FPR Only publication functionality
        	appPubMod.NewFprOnlyPublication.Not_Product_Policy__c = true;
        	appPubMod.SaveNewFprOnlyPublication();
        	*/
        
        	AppearPubModel.ansRecIdVal = fprATest.id;
        	System.assertEquals(fprATest.id, AppearPubModel.ansRecIdVal);
        	appPubMod.NewFprOnlyPublication.GPP_Type__c = 'FPR Only';
        	appPubMod.NewFprOnlyPublication.Publication_Title__c = 'Test Pub FPR Only';
        	appPubMod.NewFprOnlyPublication.Publication_Type__c = 'Other';
        	appPubMod.NewFprOnlyPublication.Data_Source__c = 'Development';
        	appPubMod.NewFprOnlyPublication.SubGroup_pick__c = 'Global Dev - US';
        	appPubMod.NewFprOnlyPublication.FPR_Due_Date__c = System.today();
        	appPubMod.SaveNewFprOnlyPublication();
        	appPubMod.updateAnsPubRelate(appPubMod.NewFprOnlyPublication.Id);
        
        System.Test.stopTest();
    }
}