global class GroupModel {


	public static Map<Id, Group> getGroupMap(List<id> pubUserOrGroupIds) {
		Map<Id, Group> resultMap = new Map<Id, Group>();
		for(Group g : getGroupList(pubUserOrGroupIds)) {
			if ( g <> null) {
				resultMap.put(g.id, g);
			}
		}
		return resultMap;
	}
	
	public static List<Group> getGroupList(List<id> pubUserOrGroupIds) {
		list<Group> result = [ 
			select id, DeveloperName, DoesIncludeBosses, name , RelatedId
			from Group 
			where id in :pubUserOrGroupIds
		];
		return result;
	}
	
	

}