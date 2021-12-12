import java.util.Arrays;

class UnderCell extends Cell {
  PVector pos;
  OverCell up, down, left, right;
  HashMap<Cell, Boolean> links;

  
  UnderCell(OverCell over_cell){
    super((int)over_cell.pos.x, (int)over_cell.pos.y);
    
    if( over_cell.isHorizontalPassage() )
    {
       this.up = over_cell.up;
       ((Cell)over_cell.up).down = this;
       this.down = over_cell.down;
       ((Cell)over_cell.down).up = this;
       
       link(up, true);
       link(down, true);
    } else {
       this.right = over_cell.right;
       ((Cell)this.right).left = this;
       this.left = over_cell.left;
       ((Cell)over_cell).left.right = this;
       
       link(right, true);
       link(left, true);
    }
    
  }
  
  
  boolean isHorizontalPassage() {
    return left != null || right != null;
  }
  
  boolean isVerticalPassage() {
    return up != null || down != null;
  }
  
}
