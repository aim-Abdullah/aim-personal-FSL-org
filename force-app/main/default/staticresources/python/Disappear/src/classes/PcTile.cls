public class PcTile {
	public string PcTileId{get;set;}    // API name for this Tile
	public string label{get;set;}       // User Friendly name for this Tile
	public boolean isVisible{get;set;}  
	public boolean isButton{get;set;}
	public boolean isComponent{get;set;}
	public boolean isSelected { get;set; }
	public boolean isClickable{ get;set; }
	public string PcComponent{get;set;}
	public string Url{get;set;}
	public boolean isAltShape { get;set; }
	public boolean isSeparator { get; set; }
	public string help { get; set; }
	public boolean isRequired { get; set; }
	
	//constructor to create a buttonTile 
	//setup API name to same as Label
	/*  -- disabled on 5/21 - need to keep TileId & Label independent
	public PcTile(string Label){
		this(Label, Label, 'http://www.google.com');
	}
	*/
		
	public PcTile(string TileId, string Label, string url){
		this.PcTileId = TileId;
		this.label = label;
		this.isVisible = true;
		this.isButton = true;
		this.isComponent = false;
		this.isSelected = false;
		this.isClickable = true;
		this.PcComponent = null;
		this.isSeparator = false;
		this.isAltShape = false;
		this.isRequired = false;
		this.Url = url;
		this.help = '';  //Def #609 - removed sample hover help
	}
	
	
	public void show(){
		isVisible = true;
	}
	
	public void hide(){
		isVisible = false;
	}
	
	//////////  public static methods - that act on collection of tiles /////////
	
	public static List<PcTile> SelectFirstTile( List<PcTile> tiles){
		if (tiles == null || tiles.size() == 0){
			return new List<PcTile>();
		}
		for(PcTile tile : tiles) {
			tile.isSelected = false;
		}
		tiles[0].isSelected = true;
		
		return tiles;
	}
	
	//2013-04-16 - changed Select Algorithm to look at PcTileId instead of label
	public static List<PcTile> SelectTile( List<PcTile> tiles, string selectTile){
		if (tiles == null || tiles.size() == 0){
			return new List<PcTile>();
		}
		boolean notFound = true;
		for(PcTile tile : tiles) {
			if (tile.PcTileId == selectTile) {
				notFound = false;
				tile.isSelected = true;
			} else {
				tile.isSelected = false;
			}
		}
		
		if ( notFound){
			return SelectFirstTile(tiles);
		} else {	
			return tiles;
		}
	}


}