global class IdAuthorDTO {

	public string id {get;set;}
	public string name {get;set;}
	public string email {get;set;}
	public string address {get;set;}
	
	public IdAuthorDTO(string id, string name, string email, string MailingStreet, string MailingCity, string MailingState,
		string MailingPostalCode, string MailingCountry){
		this.id = id;
		
		//Def #667 - remove '
		this.name = name.remove('\'');
		this.email = email;
		this.address = MailingStreet+', '+ MailingCity+', '+
			MailingState+', '+
			MailingPostalCode+', '+
			MailingCountry;
		this.address = this.address.remove('\'');	
		
		//AppLogModel.LogDebug('IdAuthorDTO::constructor', 'DTO with email : '+this.email+' | address: '+this.address);
	}
}