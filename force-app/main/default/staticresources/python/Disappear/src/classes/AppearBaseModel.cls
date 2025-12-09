// AppearBaseModel

public virtual class AppearBaseModel {

	public void AppearAddErrorMessage(string message){
		ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.FATAL, message);
		ApexPages.addMessage(errMsg);
	}
	

}