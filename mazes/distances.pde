import java.util.Collections;

class Distances {
  Cell root;
  HashMap<Cell, Integer> cells;
  
  Distances(Cell root){
    this.root = root;
    this.cells = new HashMap<Cell, Integer>();
    cells.put(root, 0);
  }
  
  int get(Cell c) {
    if( c == null )
      return 0;
    return this.cells.get(c);
  }
  
  void set(Cell c, int distance) {
    this.cells.put(c, distance);
  }
  
  Cell[] cells() {
    Cell[] retVal = new Cell[this.cells.keySet().size()];
    retVal = this.cells.keySet().toArray(retVal);
    return retVal;
  }
  
  int maximum() {
    return Collections.max(this.cells.values());
  }
}
