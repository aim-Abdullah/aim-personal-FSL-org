public  class PubTypeModelData {

    public static void createData() {
        
        integer dataCount = [select count() from PubType__c];
        if ( dataCount <> 0) return;
        
        
        List<PubType__c> pubtypes = new List<PubType__c>();
        
        pubTypes.add( new PubType__c(name='Abstract', displayOrder__c=10, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0.15, ME_plus__c=0.15, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Ad Board Summary', displayOrder__c=20, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0.33, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='AMCP Dossier', displayOrder__c=30, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Book Chapter', displayOrder__c=40, DefaultTargetType__c= 'Meeting',
            MePoint__c = 2.0, ME_plus__c=0, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Brief Report', displayOrder__c=50, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0, ME_plus__c=0, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Case Report', displayOrder__c=60, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0.66, ME_plus__c=0, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='CMS/Response', displayOrder__c=70, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Editorial', displayOrder__c=80, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0.33, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='GVD', displayOrder__c=90, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='HTA', displayOrder__c=100, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Letter to Editor', displayOrder__c=110, DefaultTargetType__c= 'Journal',
            MePoint__c = 0.33, ME_plus__c=0, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Manuscript', displayOrder__c=120, DefaultTargetType__c= 'Journal',
            MePoint__c = 1.00, ME_plus__c=0.25, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Meeting Summary', displayOrder__c=130, DefaultTargetType__c= 'Journal',
            MePoint__c = 1.00, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Newsletter Article', displayOrder__c=140, DefaultTargetType__c= 'Journal',
            MePoint__c = 0.33, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Oral Presentation (Slide Deck)', displayOrder__c=150, DefaultTargetType__c= 'Journal',
            MePoint__c = 0.33, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Other', displayOrder__c=160, DefaultTargetType__c= 'Journal',
            MePoint__c = 0, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Poster', displayOrder__c=170, DefaultTargetType__c= 'Meeting',
            MePoint__c = 0.33, ME_plus__c=0));
        pubTypes.add( new PubType__c(name='Review Article', displayOrder__c=180, DefaultTargetType__c= 'Journal',
            MePoint__c = 2.00, ME_plus__c=0.25, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Supplement Article (Non English Language Only)', displayOrder__c=190, DefaultTargetType__c= 'Journal',
            MePoint__c = 0, ME_plus__c=0, isInitalStatusSuggested__c=true));
        pubTypes.add( new PubType__c(name='Translation', displayOrder__c=200, DefaultTargetType__c= 'Journal',
            MePoint__c = 0, ME_plus__c=0));
        
        insert PubTypes;
    }
}

/* need 0 for the blank cell - or the addition in ME calc will fail....

    public static void createData() {
        
        integer dataCount = [select count() from PubType__c];
       // if ( dataCount <> 0) return;
        
        
        List<PubType__c> pubtypes = new List<PubType__c>();
        
        pubTypes.add( new PubType__c(name='Abstract', displayOrder__c=10, DefaultTargetType__c= 'Meeting', MePoint__c=0.15, ME_plus__c=0.15));
        pubTypes.add( new PubType__c(name='Ad Board Summary', displayOrder__c=20, DefaultTargetType__c= 'Meeting', MePoint__c=0.33));
        pubTypes.add( new PubType__c(name='AMCP Dossier', displayOrder__c=30, DefaultTargetType__c= 'Meeting'));
        pubTypes.add( new PubType__c(name='Book Chapter', displayOrder__c=40, DefaultTargetType__c= 'Meeting', MePoint__c=2.00));
        pubTypes.add( new PubType__c(name='Brief Report', displayOrder__c=50, DefaultTargetType__c= 'Meeting'));
        pubTypes.add( new PubType__c(name='Case Report', displayOrder__c=60, DefaultTargetType__c= 'Meeting', MePoint__c=0.66));
        pubTypes.add( new PubType__c(name='CMS/Response', displayOrder__c=70, DefaultTargetType__c= 'Meeting'));
        pubTypes.add( new PubType__c(name='Editorial', displayOrder__c=80, DefaultTargetType__c= 'Meeting', MePoint__c=0.33));
        pubTypes.add( new PubType__c(name='GVD', displayOrder__c=90, DefaultTargetType__c= 'Meeting'));
        pubTypes.add( new PubType__c(name='HTA', displayOrder__c=100, DefaultTargetType__c= 'Meeting'));
        pubTypes.add( new PubType__c(name='Letter to Editor', displayOrder__c=110, DefaultTargetType__c= 'Journal'));
        pubTypes.add( new PubType__c(name='Manuscript', displayOrder__c=120, DefaultTargetType__c= 'Journal', MePoint__c=1.00, ME_plus__c=0.25));
        pubTypes.add( new PubType__c(name='Meeting Summary', displayOrder__c=130, DefaultTargetType__c= 'Journal', MePoint__c=1.00));
        pubTypes.add( new PubType__c(name='Newsletter Article', displayOrder__c=140, DefaultTargetType__c= 'Journal', MePoint__c=0.33));
        pubTypes.add( new PubType__c(name='Oral Presentation (Slide Deck)', displayOrder__c=150, DefaultTargetType__c= 'Journal', MePoint__c=0.33));
        pubTypes.add( new PubType__c(name='Other', displayOrder__c=160, DefaultTargetType__c= 'Journal'));
        pubTypes.add( new PubType__c(name='Poster', displayOrder__c=170, DefaultTargetType__c= 'Meeting', MePoint__c=0.33));
        pubTypes.add( new PubType__c(name='Review Article', displayOrder__c=180, DefaultTargetType__c= 'Journal', MePoint__c=2.00, ME_plus__c=0.25));
        pubTypes.add( new PubType__c(name='Supplement Article (Non English Language Only)', displayOrder__c=190, DefaultTargetType__c= 'Journal'));
        pubTypes.add( new PubType__c(name='Translation', displayOrder__c=200, DefaultTargetType__c= 'Journal'));
        
        insert PubTypes;
    }
}
*/