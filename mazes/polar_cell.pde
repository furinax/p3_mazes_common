import java.util.Collections;

class PolarCell extends Cell {
  public PolarCell cw, ccw, inward;
  ArrayList<PolarCell> _outward;

  PolarCell(int x, int y){
    super(x, y);
    _outward = new ArrayList<PolarCell>();
  }

  Cell[] neighbors() {
    ArrayList<PolarCell> neighbors = new ArrayList<PolarCell>(); //<>//
    if( this.cw != null )
      neighbors.add(this.cw);
    if( this.ccw != null )
      neighbors.add(this.ccw);
    if( this.inward != null )
      neighbors.add(this.inward);

    neighbors.addAll(this.outward());
    
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }

  ArrayList<PolarCell> outward() {
    return new ArrayList<PolarCell>(_outward);
  }
}
