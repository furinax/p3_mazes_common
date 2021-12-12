import java.util.Arrays;

class OverCell extends Cell {
  PVector pos;
  OverCell up, down, left, right;
  HashMap<Cell, Boolean> links;
  WeaveGrid grid;
  
  OverCell(int x, int y, WeaveGrid _grid){
    super(x, y);
    this.grid = _grid;
  }
  
  Cell[] neighbors() {

    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    Collections.addAll(neighbors, super.neighbors());
    
    if( canTunnelUp() ) neighbors.add(up.up);
     
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
  
  boolean canTunnelUp() {
    return up != null && up.up != null && up.isHorizontalPassage();
  }
  
  boolean canTunnelDown() {
    return down != null && down.down != null && down.isHorizontalPassage();
  }
  
  boolean canTunnelLeft() {
    return left != null && left.left != null && left.isVerticalPassage();
  }
  
  boolean canTunnelRight() {
    return right != null && right.right != null && right.isVerticalPassage();
  }
  
  boolean isHorizontalPassage() {
    return isLinked(left) && isLinked(right) && !isLinked(up) && !isLinked(down);
  }
  
  boolean isVerticalPassage() {
    return isLinked(up) && isLinked(down) && !isLinked(left) && !isLinked(right);
  }
  
  void link(Cell c, boolean bidi) {
    Cell neighbor = null;
    
    if( up != null && up == c.down)
      neighbor = up;
    else if( down != null && down == c.up)
      neighbor = down;
    else if( right != null && right == c.left )
      neighbor = right;
    else if( left != null && left == c.right )
      neighbor = left;
      
    if( neighbor != null )
    {
      this.grid.tunnelUnder((OverCell)neighbor);
    }
    else
    {
      super.link(c, bidi);
    }
      
  }
  
}
