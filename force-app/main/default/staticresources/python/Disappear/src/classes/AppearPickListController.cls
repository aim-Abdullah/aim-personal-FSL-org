public class AppearPickListController {

	private string pCurrentView = null;
	public string CurrentView {
		get {
			return pCurrentView;
		}
	}

	private string pPickListValues = null;
	public string pickListValues { 
		get {
			return pPickListValues;   // not the usual lazy load since we may have many picklist values to copy in 
		}
	}
	
	public void ProdIndPickList() {
		string result = '';
		for( ProductIndication__c prodInd : ProductIndicationModel.getAllProductIndications()) {
			result = result + prodInd.Name + '<br/>';
		}
		
		pCurrentView = 'ProdIndPickList';
		pPickListValues = result;
	}

	public void TherapeuticAreaPickList() {
		string result = '';
		for( TherapeuticArea__c ta : TherapeuticAreaModel.TaList) {
			result = result + ta.Name + '<br/>';
		}
		
		pCurrentView = 'TherapeuticAreaPickList';
		pPickListValues = result;
	}

	public void DataSourcePickList() {
		string result = '';
		for( DataSource__c ds : DataSourceModel.DataSourceList) {
			result = result + ds.Name + '<br/>';
		}
		
		pCurrentView = 'DataSourcePickList';
		pPickListValues = result;
	}
	
	public void SponsoringDeptPickList() {
		string result = '';
		for( Department__c dept : DepartmentModel.SponsoringDepartmentList) {
			result = result + dept.Name + '<br/>';
		}
		
		pCurrentView = 'SponsoringDeptPickList';
		pPickListValues = result;
	}
	
	public void SponsoringOrgPickList() {
		string result = '';
		for( Organization__c org : OrganizationModel.SponsoringOrganizationList) {
			result = result + org.Name + '<br/>';
		}
		
		pCurrentView = 'SponsoringOrgPickList';
		pPickListValues = result;
	}
	
		
	public void SubGroupPickList() {
		string result = '';
		for( SubGroup__c sg : SubGroupModel.SubGroupList) {
			result = result + sg.Name + '<br/>';
		}
		
		pCurrentView = 'SubGroupPickList';
		pPickListValues = result;
	}
	
	public void AppearRolePickList() {
		string result = '';
		for( Appear_Role__c ar : AppearRoleModel.AppearRoleList) {
			result = result + ar.Name + '<br/>';
		}
		
		pCurrentView = 'AppearRolePickList';
		pPickListValues = result;
	}
	
	public void RegionPickList() {
		string result = '';
		for( Region__c r : RegionModel.RegionList) {
			result = result + r.Name + '<br/>';
		}
		
		pCurrentView = 'RegionPickList';
		pPickListValues = result;
	}
	
	public void CountryPickList() {
		string result = '';
		for( Country__c c : CountryModel.CountryList) {
			result = result + c.Name + '<br/>';
		}
		
		pCurrentView = 'CountryPickList';
		pPickListValues = result;
	}
	
	public void PubTypePickList() {
		string result = '';
		for( PubType__c pt : PubTypeModel.PubTypeList) {
			result = result + pt.Name + '<br/>';
		}
		
		pCurrentView = 'PubTypePickList';
		pPickListValues = result;
	}
}