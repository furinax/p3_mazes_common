import java.util.Collections;

class TriangleCell extends Cell {
  
  TriangleCell(int x, int y){
    super(x, y);
  }

  boolean upright() {
     return (this.pos.x + this.pos.y) % 2 == 0; 
  }

  Cell[] neighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>(); 

    if( this.left != null )
      neighbors.add(this.left);

    if( this.right != null )
      neighbors.add(this.right);
      
    if( this.up != null && !upright() )
      neighbors.add(this.up);

    if( this.down != null && upright() )
      neighbors.add(this.down);

    
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
}
