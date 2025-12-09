public class AppearRoleModelData {

    public static void deleteData() {
        list<Appear_Role__c> roles = [select id from Appear_Role__c];
        delete roles;
    }

    public static void createData() {
        
        integer dataCount = [select count() from Appear_Role__c];
        if ( dataCount <> 0) {
            return;
        }
        AppearRoleModel.resetCache();
        
        RecordType pubTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','PubTeamRole');
        RecordType reviewTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','ReviewTeamRole');
        
        System.assertNotEquals(null, pubTeamRoleRecType);
        System.assertNotEquals(null, reviewTeamRoleRecType);
        
        List<Appear_Role__c> roleList = new List<Appear_Role__c>(); 

        roleList.add( new Appear_Role__c(name= 'FPR Reviewer', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        roleList.add( new Appear_Role__c(name= 'FPR Copy Only', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        roleList.add( new Appear_Role__c(name= 'FPR Comments Only', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        roleList.add( new Appear_Role__c(name= 'FPR Coordinator', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        roleList.add( new Appear_Role__c(name= 'Study Coordinator', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        roleList.add( new Appear_Role__c(name= 'Vice President', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        
        //ref pg 78 storyboard 1.1
        roleList.add( new Appear_Role__c(name= 'Sponsoring Amgen Dept', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Sponsoring Org', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Meeting Coordinator', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Principal Investigator', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Quoted in Press Release', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Business Admin', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'GPPL', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Sponsor', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Approver', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Reviewer', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'GDL', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'GML', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'USML', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'IML', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Safety', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'GPM', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'GHE', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'EU Pub Mgr', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'GPL', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Sponsoring Org Contact', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'SAPM', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Proxy', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Corp Comm', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Submitter', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Research', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Biostatistician', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Regulatory', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'EDL', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'PKPD', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Legal', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Business Partner Contact', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'MedCom - Other', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'MedInfo', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'RML Rep', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'FPR Submitter', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Amgen Contact', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Author', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'CfOR', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Contract Writer', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Corresponding Author', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Editor-in-Chief', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'First Author', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Investigator', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Journal Editor', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'KOL', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Managing Editor', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Amgen Observer', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Blended IPM/FPRC', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'IPM', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'main WC', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Pub Team Member', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'Record Owner', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
		roleList.add( new Appear_Role__c(name= 'System Admin', isWritingRole__c = false, RecordTypeId = pubTeamRoleRecType.id));
        
        //writing roles
        roleList.add( new Appear_Role__c(name= 'Writing Coordinator', isWritingRole__c = true,RecordTypeId = pubTeamRoleRecType.id,	displayOrder__c = 100));              
        roleList.add( new Appear_Role__c(name= 'Support WC', isWritingRole__c = true,RecordTypeId = pubTeamRoleRecType.id, displayOrder__c = 110));  
        roleList.add( new Appear_Role__c(name= 'Writer', isWritingRole__c = true, RecordTypeId = pubTeamRoleRecType.id,displayOrder__c = 120));
        roleList.add( new Appear_Role__c(name= 'Editorial Support', isWritingRole__c = true,RecordTypeId = pubTeamRoleRecType.id, displayOrder__c = 130));
                
        insert roleList;
    
    }
    

}