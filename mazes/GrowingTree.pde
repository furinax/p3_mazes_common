import java.util.Map;
import java.util.Comparator;

class GrowingTree {
  void on(Grid g){
    Cell current = g.randomCell();
    ArrayList<Cell> active = new ArrayList<Cell>();
    active.add(current);
    
    while( !active.isEmpty() )
    {
      Cell cell = getNext(active);
      ArrayList<Cell> availableNeighbors = new ArrayList<Cell>();
      for( Cell c : cell.neighbors() )
      {
        if( c.links().isEmpty() )
          availableNeighbors.add(c);
      }
      
      if( !availableNeighbors.isEmpty() )
      {
        Cell neighbor = getNextNeighbor(availableNeighbors);
        cell.link(neighbor, true);
        active.add(neighbor);
      }
      else
      {
        active.remove(cell);
      }
    }    
  }
  
  Cell getNext(ArrayList<Cell> active) {
    // modify this to tweak the algorithm
    if( random(1) < .5){
      return active.get(active.size() > 1 ? active.size() - 1: 0);
    }
    return active.get(int(random(active.size())));
  }
  
  Cell getNextNeighbor(ArrayList<Cell> neighbors) {
    
    return neighbors.get(int(random(neighbors.size())));
  }
  
}
