global class IdStudyProjectDTO {
	public string id {get;set;}
	public string name {get;set;}
	public string title {get;set;}
	
	global IdStudyProjectDTO(string id, string name, string title){
		this.id = id;
		this.name = name;
		this.title = title;
	}
}