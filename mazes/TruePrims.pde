import java.util.Map;
import java.util.Comparator;

class TruePrims {
  void on(Grid g){
    Cell current = g.randomCell();
    ArrayList<Cell> active = new ArrayList<Cell>();
    active.add(current);
    
    HashMap<Cell, Float> costs = new HashMap<Cell, Float>();
    for(Cell c: g.eachCell()) {
      costs.put(c, random(100));
    }
    while( !active.isEmpty() )
    {
      Cell cell = getMin(active, costs);
      ArrayList<Cell> availableNeighbors = new ArrayList<Cell>();
      for( Cell c : cell.neighbors() )
      {
        if( c.links().isEmpty() )
          availableNeighbors.add(c);
      }
      
      if( !availableNeighbors.isEmpty() )
      {
        Cell neighbor = getMinNeighbor(availableNeighbors, costs);
        cell.link(neighbor, true);
        active.add(neighbor);
      }
      else
      {
        active.remove(cell);
      }
    }    
  }
  
  Cell getMin(ArrayList<Cell> active ,HashMap<Cell, Float> costs) {
    
    Cell localMin = null;
    for( Cell c : active ) {
      if( localMin == null )
      {
        localMin = c;
      }
      else if( costs.get(localMin) > costs.get(c) )
      {
        localMin = c;
      }
    }
    return localMin;
  }
  
  Cell getMinNeighbor(ArrayList<Cell> neighbors, HashMap<Cell, Float> costs) {
    float min = costs.get(neighbors.get(0));
    Cell retVal = neighbors.get(0);
    for( Cell c : neighbors) {
      if( costs.get(c) < min ) {
        min = costs.get(c);
        retVal = c;
      }
        
    }
    
    return retVal;
  }
  
}
