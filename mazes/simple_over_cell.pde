import java.util.Arrays;

class SimpleOverCell extends OverCell {
  
  SimpleOverCell(int x, int y, WeaveGrid _grid) {
      super(x, y, _grid);
  }
  
  // new class for Kruskals
  Cell[] neighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    //Collections.addAll(neighbors, super.neighbors());
    
    if( up != null ) neighbors.add(up);
    if( down != null ) neighbors.add(down);
    if( left != null ) neighbors.add(left);
    if( right != null ) neighbors.add(right);

    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
}
