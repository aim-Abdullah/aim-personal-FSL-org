@IsTest
public class GroupModelTest {

	@IsTest
	public static void UnitTest() {
		Group newGroup = new Group();
		newGroup.name = 'TestGroup';
		newGroup.DeveloperName = 'TestGroup';
		insert newGroup;
		
		List<id> idList = new List<id>();
		idList.add(newGroup.id);
		List<Group>  groups = GroupModel.getGroupList(idList);
		
		Map<Id, Group> groupMap = GroupModel.getGroupMap(idList);
	}
}