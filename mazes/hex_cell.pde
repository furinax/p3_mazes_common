import java.util.Collections;

class HexCell extends Cell {
  public HexCell ne, nw, se, sw;

  HexCell(int x, int y){
    super(x, y);
  }

  Cell[] neighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>(); //<>// //<>//
    if( this.nw != null )
      neighbors.add(this.nw);
    if( this.up != null )
      neighbors.add(this.up);
    if( this.ne != null )
      neighbors.add(this.ne);
    if( this.sw != null )
      neighbors.add(this.sw);
    if( this.down != null )
      neighbors.add(this.down);
    if( this.se != null )
      neighbors.add(this.se);
    
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
}
