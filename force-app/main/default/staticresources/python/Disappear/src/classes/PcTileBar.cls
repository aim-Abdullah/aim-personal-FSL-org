public class PcTileBar {
	
	public PcTileBar(PcTile[] PcTiles){
		pTiles = PcTiles;
	}

	private PcTile[] pTiles = null;
	public PcTile[] Tiles {
		get {
			if (pTiles == null){
				return new list<PcTile>();
			} else {
				return pTiles;
			}
		}
		set{
			pTiles = value;
			pMaxLabel = null;
			pMaxLabelLength = -1;
		}
	}
	
	private PcTile pActiveTile = null;
	public PcTile ActiveTile {
		get{
			if (pActiveTile == null) {
				for(PcTile tile : Tiles) {
					if (tile.isSelected) {
						pActiveTile = tile;
						break;
					}
				}
			}
			return pActiveTile;
		}
	}
	
	private void calcMaxLabel() {
		if (pTiles == null){
			return;
		}
		for(PcTile tile : pTiles){
			if (tile.label <> null && tile.label.length()> pMaxLabelLength){
				pMaxLabel = tile.label;
				pMaxLabelLength = pMaxLabel.length();
			}
		}
	}
	
	public integer maxLabelEm {
		get {
			integer result = Math.Round(maxLabelLength/2)+1;
			return result;
		}
	}
	private integer pMaxLabelLength = -1;
	public integer maxLabelLength {
		get{
			if ( pMaxLabelLength == -1){
				calcMaxLabel();
			}
			return pMaxLabelLength;
		}
	}	
	
	private string pMaxLabel = null;
	public string maxLabel {
		get {
			if ( pMaxLabel == null) {
				calcMaxLabel();
			}
			return pMaxLabel;
		}
	}



}