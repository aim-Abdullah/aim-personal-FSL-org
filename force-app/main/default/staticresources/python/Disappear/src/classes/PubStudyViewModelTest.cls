@IsTest
public class PubStudyViewModelTest {

	@IsTest
	public static void UnitTest() {
		OrganizationModelData.createData();
		DepartmentModelData.createData();
		TherapeuticAreaModelData.createData();
		
		StudyModelData.createData();
	
	
		List<IdStudyProjectDTO> dtoStudy = PubStudyViewModel.findStudiesByNameTitle('study', 'Enbrel RA Remission Study');
		System.assertNotEquals(null, dtoStudy); 
		System.assertNotEquals(0, dtoStudy.size());

		dtoStudy = PubStudyViewModel.findStudiesByNameTitle('study', 'Enbrel');
		System.assertNotEquals(null, dtoStudy);
		System.assertNotEquals(0, dtoStudy.size());
		
		dtoStudy = PubStudyViewModel.findStudiesByNameTitle('study', '201190');
		System.assertNotEquals(null, dtoStudy);
		System.assertNotEquals(0, dtoStudy.size());
		
		List<IdStudyProjectDTO> dtoProject = PubStudyViewModel.findStudiesByNameTitle('project', 'Dummy Project 1');
		System.assertNotEquals(null, dtoProject);
		System.assertNotEquals(0, dtoProject.size());
	}
}