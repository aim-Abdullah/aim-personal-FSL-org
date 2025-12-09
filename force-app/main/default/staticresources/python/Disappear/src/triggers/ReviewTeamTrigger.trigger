/***************************************************************************************************
 * $Id$ : ReviewTeamTrigger 
 * $Modified Date$ : 2014/04/03
 * $Author$ : Sudha
 * $Description$ : Moved all logic in class ReviewTeamController  . 
 ***********************************************************************************************/
trigger ReviewTeamTrigger on Review_Team__c (before insert, before update) {
    if (( Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
        //trigger to autoset review team name
        ReviewTeamTriggerLogic.validateReviewTeam(Trigger.new);
    } 
}