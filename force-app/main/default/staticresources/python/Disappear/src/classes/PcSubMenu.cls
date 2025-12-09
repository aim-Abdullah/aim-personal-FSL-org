public class PcSubMenu {

	public string Label { get;set; }
	public boolean isSeparator {get;set;}
	public boolean isSelected { get;set; }
	public boolean isClickable{ get;set; }
	public boolean isChevronShape {get;set;}
	public string url {get;set;}
	
	public PcSubMenu(string Label, boolean isSelected, boolean isClickable, string url){
		this.label = label;
		this.isSeparator = false;
		this.isSelected = isSelected;
		this.isClickable = isClickable;
		this.isChevronShape = false;
		this.url = url;
	}
	
	////////////////////////////////////////////////////////////////////

	public static List<PcSubMenu> SearchSubMenu(
		boolean selectSuggestionSubMenu, 
		boolean selectFprRequestSubMenu,
		boolean selectPublSubMenu, 
		boolean selectContactSubMenu,
		boolean selectUserSubMenu){
 
		List<PcSubMenu> result = new List<PcSubMenu>();
		boolean isClickable = true;
		
		result.add(new PcSubMenu(AppearConstants.SearchSubMenuSuggestions,
			selectSuggestionSubMenu, isClickable,  
			AppearUrlModel.AppearSearchMenuUrl(AppearConstants.SearchSubMenuSuggestions)));
			
		result.add(new PcSubMenu(AppearConstants.SearchSubMenuFprRequests,
			selectFprRequestSubMenu, isClickable, 
			AppearUrlModel.AppearSearchMenuUrl(AppearConstants.SearchSubMenuFprRequests)));
			
		result.add(new PcSubMenu(AppearConstants.SearchSubMenuPublications,
			selectPublSubMenu, isClickable, 
			AppearUrlModel.AppearSearchMenuUrl(AppearConstants.SearchSubMenuPublications)));	  
				
		result.add(new PcSubMenu(AppearConstants.SearchSubMenuContacts,
			selectContactSubMenu, isClickable, 
			AppearUrlModel.AppearSearchMenuUrl(AppearConstants.SearchSubMenuContacts)));	
				
		result.add(new PcSubMenu(AppearConstants.SearchSubMenuUsers,
			selectUserSubMenu, isClickable, 
			AppearUrlModel.AppearSearchMenuUrl(AppearConstants.SearchSubMenuUsers)));		
	
		return result;

	} 
 
	
	
	private static List<PcSubMenu> SetStateSymbol(List<PcSubMenu> subMenus){
		for( PcSubMenu subMenu : subMenus){
			subMenu.isClickable = false;
			subMenu.isChevronShape = true;
		}
		return subMenus;
	}
	
	//PubSubMenu is like state
	public static List<PcSubMenu> PubSubMenu(
		boolean selectSuggestionSubMenu,
		boolean selectPlanSubMenu, 
		boolean selectExecuteSubMenu,
		boolean selectReviewSubMenu, 
		boolean selectSubmitSubMenu){
			
		List<PcSubMenu> result = new List<PcSubMenu>();

		result.add(new PcSubMenu(AppearConstants.PubSubMenuSuggest,  
			selectSuggestionSubMenu, false, 
			AppearUrlModel.AppearPubMenuUrl(AppearConstants.PubSubMenuSuggest, 
			AppearConstants.PubActionTile)));
		
		result.add(new PcSubMenu(AppearConstants.PubSubMenuPlan,
			selectPlanSubMenu, false, 
			AppearUrlModel.AppearPubMenuUrl(AppearConstants.PubSubMenuPlan, 
			AppearConstants.PubActionTile)));
			
		result.add(new PcSubMenu(AppearConstants.PubSubMenuExecute,
			selectExecuteSubMenu, false, 
			AppearUrlModel.AppearPubMenuUrl(AppearConstants.PubSubMenuExecute, 
			AppearConstants.PubActionTile)));
			
		result.add(new PcSubMenu(AppearConstants.PubSubMenuReview,
			selectReviewSubMenu, false, 
			AppearUrlModel.AppearPubMenuUrl(AppearConstants.PubSubMenuReview, 
			AppearConstants.PubActionTile)));  
			
		result.add(new PcSubMenu(AppearConstants.PubSubMenuSubmit,
			selectSubmitSubMenu, false, 
			AppearUrlModel.AppearPubMenuUrl(AppearConstants.PubSubMenuSubmit, 
			AppearConstants.PubActionTile)));
		
		return SetStateSymbol(result);
	}
	
}