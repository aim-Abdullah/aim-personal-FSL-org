global class IdNameDTO {

	public string id {get;set;}
	public string name {get;set;}
	
	global IdNameDTO(string id, string name){
		this.id = id;
		
		//Def #667 - remove ' from name to make name IE compatible
		this.name = name.remove('\'');
	}
	
	@IsTest
	public static void unitTest1() {
		IdNameDTO testDTO = new IdNameDTO('anId', 'aName');
		System.assertEquals('anId', testDTO.id); 
		System.assertEquals('aName', testDTO.name); 
	}
	

	@IsTest
	public static void unitTest2() {
		IdNameDTO testDTO = new IdNameDTO('anId', 'aN\'ame');
		System.assertEquals('anId', testDTO.id); 
		System.assertEquals('aName', testDTO.name); 
	}
	
}