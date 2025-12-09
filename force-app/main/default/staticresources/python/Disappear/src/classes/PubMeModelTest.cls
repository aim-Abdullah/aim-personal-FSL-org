@IsTest
public class PubMeModelTest {

    @IsTest
    public static void UnitTest() {
        //create a Publication
        AppearPubModel activePub = createData();
        
        
        System.test.startTest();
        //add Product Indication
        
        List<String> ProdIndList = new List<String>();
        ProdIndList.add(ProductIndicationModel.ProductIndicationNameMap.get('AMG 108 - Not Applicable').id);
        
        activePub.PubProdIndication.SelectedProductIndications = ProdIndList;
        activePub.PubProdIndication.savePubProdInd();
        //system should copy the Product Indication team over to publication 
    
        PubME__c pubME = activePub.pubMe.NewPubWritingRoleMembers;
        pubMe.WritingRoleMember__c = AppearContactModel.SimilarContacts('Maxwell, Michelle', 10)[0].id;
        pubMe.AppearRole__c = AppearRoleModel.AppearRoleMapByName.get('Writing Coordinator').id;
        pubMe.Emp_Type__c = AppearContactModel.findContactEmployeeType(AppearContactModel.SimilarContacts('Maxwell, Michelle', 10)[0].id);
        activePub.pubMe.saveNewWritingRoleMember();
        
        List<PubME__c> pubMeList = activePub.PubMe.PubMeList;
        System.assertEquals(1, pubMeList.size());
                
        activePub.pubMe.calculateActualMeGUI();
        
        pubMeList[0].isSelected__c = true;
        activePub.pubMe.deleteSelected();
        
        pubMeList = activePub.PubMe.PubMeList;
        System.assertEquals(0, pubMeList.size());
        
        PubME__c pubME2 = activePub.pubMe.NewPubWritingRoleMembers;
        pubME2.WritingRoleMember__c = AppearContactModel.SimilarContacts('mike@amgen', 10)[0].id;
        pubME2.AppearRole__c = AppearRoleModel.AppearRoleMapByName.get('Writer').id;
        pubME2.Emp_Type__c = AppearContactModel.findContactEmployeeType(AppearContactModel.SimilarContacts('mike@amgen', 10)[0].id);
        pubME2.id = null;
        activePub.pubMe.saveNewWritingRoleMember();
    
        pubMeList = activePub.PubMe.PubMeList;
        System.assertEquals(1, pubMeList.size());
        
        pubMeList[0].OverrideME__c = 1.0;
        pubMeList[0].FPR_Cycle__c = activePub.FprCycle.getFprCycleByNum(1).id;
        activePub.pubMe.save();
        
        pubMeList = activePub.PubMe.PubMeList;
        System.assertEquals(1, pubMeList.size());
        
        List<Department__c> departments = DepartmentModel.getCompleteDepartmentList();
        System.assertEquals(14, departments.size());
        
        for(Department__c tmpDept : departments){
            if(tmpDept !=null && tmpDept.Name == 'Abgenix [Expired]' && tmpDept.isLogicallyDeleted__c) {
                pubMeList[0].Department__c = tmpDept.Id;
                break;
            }   
        }
        activePub.pubMe.save();
        
        activePub.pubMe.copyMEforResent(1,2);
        SubmissionCycle__c nextSubmissionCycle = activePub.submissionCycle.getSubmissionCycleByNum(2);
        FPR_Cycle__c nextFprCycle = activePub.FprCycle.getFprCycleByNum(2);
        activePub.pubMe.copyMEforNewSubmissionCycle(nextSubmissionCycle,nextFprCycle);
        
        ////////////////Start:Changes Made By Sudha //////////////
        PubMeModel objPubMeModel = new PubMeModel();
        String strObj =objPubMeModel.RecalculateHelpText;
        Boolean objBLN = objPubMeModel.ShowOverrideColumn;
        objBLN = objPubMeModel.debugFlag;
        objBLN = objPubMeModel.ShowGUIvsDB;
        
        PubStatusModel pubstats = activePub.PubStatus;
        PubStatus__c newSCPubStatus;
        System.debug('Madhurima Hello 1');
        for (PubStatus__c st: pubstats.PubStatusList){
            if (st.Status__c == StatusModel.SubmittedCompleted.Id ){
                st.ActualDate__c = Date.today();
                break;
            }
        }
        pubstats.save();
        pubstats.clearCache();
        
        for (PubStatus__c st: pubstats.PubStatusList){
            if (st.Status__c == StatusModel.SubmittedCompleted.Id && st.ActualDate__c <> null){
                newSCPubStatus = st;
                break;
            }
        }
        
        try{
            objPubMeModel.AwardMeForSubmittedCompleted(activePub, newSCPubStatus);
        }catch(exception ex){
        }
        try{
            objPubMeModel.AwardMeForMaterialChangeCongressJournal(activePub);
        }catch(exception ex){
        }
        try{
            objPubMeModel.recalculateAndPersist();
        }catch(exception ex){
        }       
        //objPubMeModel.AwardMeForSubmittedCompleted(activePub, );
        
        try{
            objPubMeModel.findPubStatusId(pubME);
        }catch(exception ex){
        }
         
        /*Madhurima Added Code*/
        
       
        /////////////////END-of Changes Made By Sudha---///////////////////////////////
        System.test.stopTest();
    
        //Submit the publication    
        //System should copy all Publication Team members with writing roles to the PubME models
        
        //check Submission Cycle
        //check FPR cycle
        //check team member
        //check Department
        //check organization
        //check scope of work
        //check Calculated ME
        
        //Change Scope of Work
        //Check Calculated ME
        
        //Check total Calculated ME
        
        //Add Manual Changes for Actual ME
        
        //check Actual ME
        //check reason for changes
        
        //check total ME included Actual
        
        //perist and check again......
    }
    
    @IsTest
    public static void UnitTest1() {
        AppearPubModel activePub = createData();
        System.Test.startTest();
        activePub.pubMe.copyMEforResent(1,2);
        List<PubME__c> pubMeList = activePub.PubMe.PubMeList;
        
        SubmissionCycle__c nextSubmissionCycle = activePub.submissionCycle.getSubmissionCycleByNum(2);
        FPR_Cycle__c nextFprCycle = activePub.FprCycle.getFprCycleByNum(2);
        activePub.pubMe.copyMEforNewSubmissionCycle(nextSubmissionCycle,nextFprCycle);
        PubMeModel objPubMeModel = new PubMeModel();
        String strObj =objPubMeModel.RecalculateHelpText;
        Boolean objBLN = objPubMeModel.ShowOverrideColumn;
        objBLN = objPubMeModel.debugFlag;
        objBLN = objPubMeModel.ShowGUIvsDB;
        Publication__c pub = UnitTestData.newPublication('PubReviewTeamModelTest');
        
        PubStatus__c ps1 = new PubStatus__c();    
        
        ps1.Publication_id__c = pub.Id;
        ps1.Status__c = StatusModel.DepartmentStatusList[0].id;
        
        
        
        insert ps1;
        /**/
        
        try{
            objPubMeModel.AwardMeForSubmittedCompleted(activePub, ps1);
        }catch(exception ex){
        }        
        
        activePub.pubMe.copyMEforNewSubmissionCycle(nextSubmissionCycle,nextFprCycle, ps1.Id);
        activePub.pubMe.copyMEforMaterialChange(1,1,ps1.Id);
        objPubMeModel.getPubMeSubmitCycles(pub.Id, nextSubmissionCycle.Id);
        activePub.pubMe.copyMEforNonMaterialChange(ps1.id); 
        objPubMeModel.CurrentFprCycle = null;
        objPubMeModel.saveNewWritingRoleMember();
        //Appear Enhancement R2
        
        PubME__c pubME = activePub.pubMe.NewPubWritingRoleMembers;
        pubMe.WritingRoleMember__c = AppearContactModel.SimilarContacts('Maxwell, Michelle', 10)[0].id;
        pubMe.AppearRole__c = AppearRoleModel.AppearRoleMapByName.get('Writing Coordinator').id;
        pubMe.Emp_Type__c = AppearContactModel.findContactEmployeeType(AppearContactModel.SimilarContacts('Maxwell, Michelle', 10)[0].id);
        activePub.pubMe.saveNewWritingRoleMember();
        List<PubME__c> pubMeList1 = activePub.PubMe.PubMeList;
        system.debug('*****'+pubMeList);
        //system.debug('****'+pubMeList[0].Publication__r.Id);Writer
        system.debug('*******'+ps1.id);
        
        PubMeModelNoSharing.copyMEforNonMaterialChange(pubMeList1,pub.Id,ps1.id);
        //List<PubMe__c> PubMeList, id PubId, SubmissionCycle__c fromSubmissionCycle, FPR_Cycle__c fromFprCycle,
        //SubmissionCycle__c toSubCycle, FPR_Cycle__c toFprCycle, Id PubStatusId
        SubmissionCycle__c subcycle= [Select id from SubmissionCycle__c where Publication__c =: pub.Id];
        PubMeModelNoSharing.copyME(pubMeList1,pub.Id,subcycle,nextFprCycle,nextSubmissionCycle,nextFprCycle,ps1.id);
        
        
        
        PubME__c pubMENew = activePub.pubMe.NewPubWritingRoleMembers;
        pubMENew.WritingRoleMember__c = AppearContactModel.SimilarContacts('Maxwell, Michelle', 10)[0].id;
        pubMENew.AppearRole__c = AppearRoleModel.AppearRoleMapByName.get('Writer').id;
        pubMENew.Emp_Type__c = AppearContactModel.findContactEmployeeType(AppearContactModel.SimilarContacts('Maxwell, Michelle', 10)[0].id);
        pubMENew.id = null;
        activePub.pubMe.saveNewWritingRoleMember();
        List<PubME__c> pubMeList2 = activePub.PubMe.PubMeList;
        PubMeModelNoSharing.copyMEforNonMaterialChange(pubMeList2,pub.Id,ps1.id);
        
        // Appear Enhancement Release 2
        strObj =objPubMeModel.AssignedTo;
        List<SelectOption> LSToPTION = objPubMeModel.getassignToOpt();
        
        
        objPubMeModel.CurrentSubmissionCycle = null;
        pubMeList = objPubMeModel.PubMeList;
        
        
        //objPubMeModel.objPubMeModel();
        objPubMeModel.clearPubMeList();
        objPubMeModel.cancel();
        System.Test.stopTest();
    }
   
    public static AppearPubModel createData(){
        
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndiObjectiveModelData.createData();
        MEScopeOfWorkModelData.createData();
        AppearRoleModelData.createData();
        
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
        StatusModelData.createData();
        
        
        Publication__c pub = UnitTestData.PublicationNew('PubMEUnitTest');
        
        AppearPubModel activePub = new AppearPubModel(pub.id);
        
        return activePub;
    }
    
    

}