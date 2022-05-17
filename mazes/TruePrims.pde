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
      Cell cell = getMin(costs);
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
  
  Cell getMin(HashMap<Cell, Float> costs) {
   Map.Entry<Cell, Float> min = Collections.min(costs.entrySet(), new Comparator<Map.Entry<Cell, Float>>() {
    public int compare(Map.Entry<Cell, Float> entry1, Map.Entry<Cell, Float> entry2) {
        return entry1.getValue().compareTo(entry2.getValue());
    }
});
  return (Cell) min.getKey();
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
