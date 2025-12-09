public class AppearTiles {
	
	
	public static PcTile AppearTile(string title, string url){

		return AppearTile(title, title, url);		
	}
	
	public static PcTile AppearTile(string tileId, string title, string url){
		PcTile result = new PcTile(tileId, title, url);
		return result;		
	}
	
	public static PcTile AppearSeparator(){
		PcTile separatorTile = new PcTile('', '', '');
		separatorTile.isSeparator = true;
		return separatorTile;		
	}
	

	////////////////////////////////////////////////////////////////////
	// Pub tiles	
	
	public static PcTile GetPubTile(string menuName, string tileName, string activePubId) {
		PcTile result = new PcTile(tileName, tileName, '');
		result.Url = AppearUrlModel.AppearPubMenuUrl(menuName,tileName,activePubId);
		return result;
	}
	
	public static PcTile GetFprTile(string menuName, string tileName, string activePubId) {
		PcTile result = new PcTile(tileName, tileName, '');
		result.Url = AppearUrlModel.AppearFprMenuUrl(menuName,tileName,activePubId);
		return result;
	}
	
	public static PcTile GetFprSubmitterTile(string menuName, string tileName, string activePubId, boolean isRequired) {
		PcTile result = new PcTile(tileName, tileName, '');
		result.Url = AppearUrlModel.AppearFprSubmitterMenuUrl(menuName,tileName,activePubId);
		result.isRequired = isRequired;
		return result;
	}

	public static PcTile GetAuthorTile(string menuName, string tileName, string activePubId, boolean isRequired) {
		PcTile result = new PcTile(tileName, tileName, '');
		result.Url = AppearUrlModel.AppearAuthorMenuUrl(menuName,tileName,activePubId);
		result.isRequired = isRequired;
		return result;
	}
	

	////////////////////////////////////////////////////////////////////
	// list of tiles by page
	
	public static List<PcTile> SearchTiles(string MenuName) {
		//no restriction for SearchTiles for now
		
		List<PcTile> result = new List<PcTile>(); 
		
		result.add(AppearTiles.AppearTile(AppearConstants.SearchFilterTile,
			AppearUrlModel.AppearSearchTileUrl(MenuName,AppearConstants.SearchFilterTile)) ); 
		result.add(AppearTiles.AppearTile(AppearConstants.SearchRecentTile,
			AppearUrlModel.AppearSearchTileUrl(MenuName,AppearConstants.SearchRecentTile)) );
		result.add(AppearTiles.AppearTile(AppearConstants.SearchMyFavTile,
			AppearUrlModel.AppearSearchTileUrl(MenuName,AppearConstants.SearchMyFavTile)) ); 
		result.add(AppearTiles.AppearTile(AppearConstants.SearchMyTeamTile,
			AppearUrlModel.AppearSearchTileUrl(MenuName,AppearConstants.SearchMyTeamTile)) ); 
		result.add(AppearTiles.AppearTile(AppearConstants.SearchMyDeptTile,
			AppearUrlModel.AppearSearchTileUrl(MenuName,AppearConstants.SearchMyDeptTile)) ); 	
		return PcTile.SelectFirstTile(result);
	}
	
	public static List<PcTile> PubTiles(String MenuName, string activePubId) {
		set<string> TileAccessList = ProfileTabModel.PubTileAccessList;
		
		List<PcTile> result = new List<PcTile>(); 
		
		if ( TileAccessList.contains(AppearConstants.PubDetailsTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubDetailsTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubStatusTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubStatusTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubAuthors)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubAuthors,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubStudiesTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubStudiesTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubStatementsTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubStatementsTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubTeamTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubTeamTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubRolesTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubRolesTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubRelatedTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubRelatedTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubAttachmentsTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubAttachmentsTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubPreFPRReviewersTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubPreFPRReviewersTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubReviewersTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubReviewersTile,activePubId));
		}
		if ( TileAccessList.contains(AppearConstants.PubFprcQueue)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubFprcQueue,activePubId)); 
		}
		if ( TileAccessList.contains(AppearConstants.PubTOVTile)) {
			result.add(AppearTiles.GetPubTile(MenuName, AppearConstants.PubTOVTile,activePubId)); 
		}
		
		return PcTile.SelectFirstTile(result);
	}
	
	public static List<PcTile> FprTiles(String MenuName, string activePubId) {
		List<PcTile> result = new List<PcTile>();
		
		result.add(AppearTiles.GetFprTile(MenuName, AppearConstants.FprDetailsTile,activePubId));
		result.add(AppearTiles.GetFprTile(MenuName, AppearConstants.FprPreFprTile,activePubId)); 
		result.add(AppearTiles.GetFprTile(MenuName, AppearConstants.PubStudiesTile,activePubId));
		result.add(AppearTiles.GetFprTile(MenuName, AppearConstants.FprOtherDetailsTile,activePubId));
		result.add(AppearTiles.GetFprTile(MenuName, AppearConstants.FprAttachmentsTile,activePubId));
		result.add(AppearTiles.GetFprTile(MenuName, AppearConstants.FprPubsForReviewTile,activePubId));
		
		return PcTile.SelectFirstTile(result);
	}
	
	public static List<PcTile> FprSubmitterTiles(String MenuName, string activePubId) {
		List<PcTile> result = new List<PcTile>();
		
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.FprMyRequests,activePubId,false));	
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.FprOnlyNewPub,activePubId,false));
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.FprDetailsTile,activePubId,false));
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.FprPreFprTile,activePubId,true)); 
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.PubAuthors,activePubId,true));
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.PubStudiesTile,activePubId,false));
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.FprOtherDetailsTile,activePubId,false));
		result.add(AppearTiles.GetFprSubmitterTile(MenuName, AppearConstants.PubAttachmentsTile,activePubId,true));
		
		return PcTile.SelectFirstTile(result);
	}

	// Release 4.0
	public static List<PcTile> AuthorTiles(String MenuName, string activePubId) {
		List<PcTile> result = new List<PcTile>();
		
		result.add(AppearTiles.GetAuthorTile(MenuName, AppearConstants.AuthorMyPubTile,activePubId,false));	
		result.add(AppearTiles.GetAuthorTile(MenuName, AppearConstants.AuthorPubDetailsTile,activePubId,false));
		// result.add(AppearTiles.GetAuthorTile(MenuName, AppearConstants.AuthorActivityTile,activePubId,false));
		// result.add(AppearTiles.GetAuthorTile(MenuName, AppearConstants.AuthorPubContentTile,activePubId,false)); 
		
		return PcTile.SelectFirstTile(result);
	}



	
}