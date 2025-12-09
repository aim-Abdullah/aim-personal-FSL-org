global class TargetUpdate_SchedulerClass implements Schedulable{

    public static String scheduleTime = '00 00 06 * * ?';  

    global static String schedule_Method() {
        targetUpdate_SchedulerClass  SC = new targetUpdate_SchedulerClass(); 
        return System.schedule('CurrentTargetUpdateBatch', scheduleTime, SC);
    }

    global void execute(SchedulableContext sc) {

        Update_PubCurrentTargetBatch updatePCTB = new Update_PubCurrentTargetBatch();
        ID batchprocessid = Database.executeBatch(updatePCTB,50);           
    }
}