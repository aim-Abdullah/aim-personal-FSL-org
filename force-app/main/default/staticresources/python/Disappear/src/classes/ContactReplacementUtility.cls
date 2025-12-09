public with sharing class ContactReplacementUtility {
    //This method will read the ID from the fromContact. With the exclusion of the User object, which is handled before this function, It will look for *ALL* references to that contact (lookups) and replace *ALL* existing references with the id of toContact. fromContact will then later be deleted by a different function.
    

    
    //@future
    public static void ReplaceContact(Id fromContactId, Id toContactId) {
        //so far, brandon notices to exclude Asset, Case, CaseContactRole, Contact, Lead
        //expect: one query and one update DML statement per object type. Update List<SObject>.
        
        //ReviewTeamMember
        List<ReviewTeamMember__c> reviewTeamMembers = [Select ReviewTeamMember__c, id FROM ReviewTeamMember__c WHERE ReviewTeamMember__c =: fromContactid];
        if (reviewTeamMembers.size() > 0) {
            for(ReviewTeamMember__c reviewTeamMember : reviewTeamMembers) {
                reviewTeamMember.ReviewTeamMember__c = toContactId;
            }
            update reviewTeamMembers;
        }
        //ContactDelegate
        List<ContactDelegate__c> contactDelegates = [Select Contact__c,Delegate__c, id FROM ContactDelegate__c WHERE (Contact__c =: fromContactid Or Delegate__c =: fromContactid)];
        if (contactDelegates .size() > 0) {
            for(ContactDelegate__c contactDelegate : contactDelegates) {
                if(contactDelegate.Contact__c == FromContactId) {
                    contactDelegate.Contact__c = toContactId;
                }
                if(contactDelegate.Delegate__c == FromContactId) {
                    contactDelegate.Delegate__c = toContactId;
                }
            }
            update contactDelegates;
        }
        //ProdIndTeamMember
        List<ProdIndTeamMember__c> ProdIndTeamMembers = [Select Contact__c, id FROM ProdIndTeamMember__c WHERE Contact__c =: fromContactid];
        if (ProdIndTeamMembers.size() > 0) {
            for(ProdIndTeamMember__c ProdIndTeamMember : ProdIndTeamMembers) {
                ProdIndTeamMember.Contact__c= toContactId;
            }
            update ProdIndTeamMembers;
        }
        //ProductTeamContact
        List<ProductTeamContact__c> ProdTeamContacts = [Select ProductTeamContactName__c, id FROM ProductTeamContact__c WHERE ProductTeamContactName__c=: fromContactid];
        if (ProdTeamContacts.size() > 0) {
            for(ProductTeamContact__c ProdTeamContact : ProdTeamContacts ) {
                ProdTeamContact.ProductTeamContactName__c = toContactId;
            }
            update ProdTeamContacts;
        }
        //PublicationAuthor
        List<pubAuthor__c> PubAuthors = [Select Author__c , id FROM pubAuthor__c WHERE Author__c =: fromContactid];
        if (PubAuthors.size() > 0) {
            for(pubAuthor__c PubAuthor : PubAuthors) {
                PubAuthor.Author__c= toContactId;
            }
            update PubAuthors ;
        }
        //Publication
        List<Publication__c> Publications = [Select Assigned_FPRC__c,First_Author__c,FPR_Submitter__c,RAE__c, id FROM Publication__c WHERE (Assigned_FPRC__c =: fromContactid Or First_Author__c =: fromContactid Or FPR_Submitter__c =: fromContactid Or RAE__c =: fromContactid)];
        if (Publications.size() > 0) {
            for(Publication__c Publication : Publications ) {
                if(Publication.Assigned_FPRC__c == FromContactId) {
                    Publication.Assigned_FPRC__c = toContactId;
                }
                if(Publication.First_Author__c == FromContactId) {
                    Publication.First_Author__c = toContactId;
                }
                if(Publication.FPR_Submitter__c == FromContactId) {
                    Publication.FPR_Submitter__c= toContactId;
                }
                if(Publication.RAE__c == FromContactId) {
                    Publication.RAE__c = toContactId;
                }
            }
            update Publications ;
        }
        //PublicationPreFprReviewer
        List<PublicationPreFprReviewer__c> FprReviewers = [Select PreFprReviewer__c, id FROM PublicationPreFprReviewer__c WHERE PreFprReviewer__c=: fromContactid];
        if (FprReviewers.size() > 0) {
            for(PublicationPreFprReviewer__c FprReviewer: FprReviewers ) {
                FprReviewer.PreFprReviewer__c = toContactId;
            }
            update FprReviewers ;
        }
       //PublicationTeamMember
        List<PublicationTeamMember__c> pubTeamMembers = [Select Member__c, id FROM PublicationTeamMember__c WHERE Member__c =: fromContactid];
        if (pubTeamMembers.size() > 0) {
            for(PublicationTeamMember__c pubTeamMember : pubTeamMembers) {
                pubTeamMember.Member__c= toContactId;
            }
            update pubTeamMembers;
        }
       //PublicationMe 
        List<PubME__c> PubMes = [Select WritingRoleMember__c , id FROM PubME__c WHERE WritingRoleMember__c =: fromContactid];
        if (Pubmes.size() > 0) {
            for(PubME__c PubME : PubMes ) {
                PubME.WritingRoleMember__c = toContactId;
            }
            update PubMes ;
        }
        //Study
        List<Study__c> Studies= [Select StudySponsor__c, id FROM Study__c WHERE StudySponsor__c=: fromContactid];
        if (Studies.size() > 0) {
            for(Study__c Study: Studies) {
                Study.StudySponsor__c= toContactId;
            }
            update Studies;
        }
        //PublicationReviewTeam 
        List<PubReviewTeam__c> PubreviewTeams= [Select Reviewer__c,TriageDelegatedBy__c, id FROM PubReviewTeam__c WHERE (Reviewer__c=: fromContactid Or TriageDelegatedBy__c =: fromContactid) ];
        if (PubreviewTeams.size() > 0) {
            for(PubReviewTeam__c PubreviewTeam: PubreviewTeams) {
                if(PubreviewTeam.TriageDelegatedBy__c == FromContactId) {
                    PubreviewTeam.TriageDelegatedBy__c = toContactId;
                }
                if(PubreviewTeam.Reviewer__c== FromContactId) {
                    PubreviewTeam.Reviewer__c = toContactId;
                }
            }
            update PubreviewTeams;
        }
     
    }
}