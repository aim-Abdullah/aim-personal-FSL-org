@IsTest
public class RecordTypeModelTest {
    //RecordType is metadata - expect to see all recordType even without SeeAllData=true

    @IsTest
    public static void unitTest() {
        //Status__c
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Status__c','Department Status'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Status__c','Department_Status'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Status__c','Global Status'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Status__c','Global_Status'));
        
        //publication__c
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Publication__c','Execute'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Publication__c','FPR Only'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Publication__c','Plan'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Publication__c','Review'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Publication__c','Submit'));
        System.assertNotEquals(null, RecordTypeModel.LookupRecordType('Publication__c','Suggestion'));
        
        RecordType RecType = RecordTypeModel.LookupRecordType('Publication__c','Execute');
        Id Test1 =   RecType.Id;
        String Find = RecordTypeModel.findRecordTypeNameById(test1);
        System.assertEquals(null, RecordTypeModel.LookupRecordType('Publication__c','DOES NOT EXIST'));
        List<RecordType> rt = New List<RecordType>();
        
        System.assertNotEquals(null, RecordTypeModel.recordTypeMap);
        System.assert(RecordTypeModel.recordTypeMap.size() > 0);
        
        System.assertNotEquals(null, RecordTypeModel.PubReviewTeamLegacyRecTypeId);
        
        System.assertNotEquals(null, RecordTypeModel.PubStatusLegacyRecTypeId);
        
        Map<id,RecordType> Map1 = RecordTypeModel.RecordTypeMapById;
        Map<Id,RecordType> Map2 = New Map<id,RecordType>();
        Map<String,RecordType> Map3 = New Map<String,RecordType>();
        Set<Id> Set2 = New Set<id>();
        Set<Id> Set1 = RecordTypeModel.LegacyInProgressPubRecordIdSet;
        id id1 = RecordTypeModel.PublicationReviewRecTypeId;
        id id2 = RecordTypeModel.PublicationInFPRCTypeId;
        id id3 = RecordTypeModel.PublicationAssignedToFPRCTypeId;
        RecordTypeModel.RecordTypeMapById = map2;
        RecordTypeModel.RecordTypeList = rt;
        RecordTypeModel.RecordTypeMap = Map3;
        RecordTypeModel.LegacyPubRecordIdSet = Set2;
        RecordTypeModel.LegacyInProgressPubRecordIdSet = Set2;
        RecordTypeModel.LegacyPubStatusRecordIdSet = Set2;
        RecordTypeModel.LegacyPubReviewTeamRecordIdSet = Set2;
        Id Record;
        RecordTypeModel.PubReviewTeamLegacyRecTypeId = Record;
        RecordTypeModel.PubStatusLegacyRecTypeId = Record;
        RecordTypeModel.StatusDeptStatusRecTypeId = Record;
        RecordTypeModel.PublicationPlanRecTypeId = Record;
        RecordTypeModel.PublicationFPROnlyRecTypeId = Record;
        RecordTypeModel.PublicationSuggestionRecTypeId = Record;
        RecordTypeModel.PublicationSubmitRecTypeId = Record;
        RecordTypeModel.PublicationReviewRecTypeId = Record;
        RecordTypeModel.PublicationInFPRCTypeId = Record;
        RecordTypeModel.PublicationAssignedToFPRCTypeId = Record;
        RecordTypeModel.PublicationLegacyFPROnlyRecTypeId = Record;
        RecordTypeModel.PublicationLegacyFPROnlyInProgressRecTypeId = Record;
        RecordTypeModel.PublicationLegacyInProgressRecTypeId = Record;
        RecordTypeModel.PublicationLegacyPublicationRecTypeId = Record;
        
        
        
        System.assertNotEquals(null, RecordTypeModel.PublicationPlanRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationFPROnlyRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationSuggestionRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationSubmitRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationLegacyFPROnlyRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationLegacyFPROnlyInProgressRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationLegacyInProgressRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PublicationLegacyPublicationRecTypeId);
        
        System.assertNotEquals(null, RecordTypeModel.PubReviewTeamLegacyRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.PubStatusLegacyRecTypeId);
        System.assertNotEquals(null, RecordTypeModel.StatusDeptStatusRecTypeId);
          
        System.assertNotEquals(null, RecordTypeModel.LegacyPubRecordIdSet);
        System.assertNotEquals(null, RecordTypeModel.LegacyPubStatusRecordIdSet);
        System.assertNotEquals(null, RecordTypeModel.LegacyPubReviewTeamRecordIdSet);
    }

}