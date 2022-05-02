class SimplifiedPrims {
  void on(Grid g){
    Cell current = g.randomCell();
    ArrayList<Cell> active = new ArrayList<Cell>();
    active.add(current);

    while( !active.isEmpty() )
    {
      Cell cell = active.get((int)random(active.size()));
      ArrayList<Cell> availableNeighbors = new ArrayList<Cell>();
      for( Cell c : cell.neighbors() )
      {
        if( c.links().isEmpty() )
          availableNeighbors.add(c);
      }
      
      if( !availableNeighbors.isEmpty() )
      {
        Cell neighbor = availableNeighbors.get((int)random(availableNeighbors.size()));
        cell.link(neighbor, true);
        active.add(neighbor);
      }
      else
      {
        active.remove(cell);
      }
    }    
  }
}
