import java.util.Arrays;

class Cell {
  PVector pos;
  Cell up, down, left, right;
  HashMap<Cell, Boolean> links;
  
  Cell(int x, int y){
    pos = new PVector(x, y);
    links = new HashMap<Cell, Boolean>();
  }
  
  void link(Cell c, boolean bidi) {
    links.put(c,true);
    if( bidi )
      c.link(this, false);
  }
  
  void unlink( Cell c, boolean bidi) {
    links.remove(c);
    if(bidi)
      c.unlink(this, false);
  }
  
  Set<Cell> links(){
    return links.keySet();
  }
  
  boolean isLinked(Cell c) {
    return links.containsKey(c);
  }
  
  Cell[] neighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    if( this.up != null )
      neighbors.add(this.up);
    if( this.down != null )
      neighbors.add(this.down);
    if( this.left != null )
      neighbors.add(this.left);
    if( this.right != null )
      neighbors.add(this.right);
    
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
  
  Distances distances() {
    Distances retVal = new Distances(this);
    ArrayList<Cell> frontier = new ArrayList<Cell>(Arrays.asList(this));
    while( !frontier.isEmpty() ) {
      ArrayList<Cell> newFrontier = new ArrayList<Cell>();
      for( Cell c : frontier ) {
        for( Cell link : c.links()) {
          if(retVal.cells.keySet().contains(link))
            continue;
          retVal.set(link, retVal.get(c) + 1);
          newFrontier.add(link);
        }
      }
      frontier = newFrontier;
    }
    
    return retVal;
  }
}
