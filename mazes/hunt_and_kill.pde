class HuntAndKill {
  void on(Grid g){
    Cell current = g.randomCell();

    while( current != null )
    {
      ArrayList<Cell> unvisitedNeighbors = new ArrayList<Cell>();
      
      for( Cell c: current.neighbors() )
      {
          if( c.links().isEmpty() )
          {
            unvisitedNeighbors.add(c);
          }
      }
      
      if(unvisitedNeighbors.size() > 0)
      {
         Cell neighbor = unvisitedNeighbors.get((int)random(unvisitedNeighbors.size()));
         current.link(neighbor, true);
         current = neighbor;
      }
      else
      {
        current = null;
        
        for( Cell c : g.eachCell())
        {
          ArrayList<Cell> visitedNeighbors = new ArrayList<Cell>();
          for( Cell n: c.neighbors() )
          {
              if( !n.links().isEmpty() )
              {
                visitedNeighbors.add(n);
              }
          }
          
          if(c.links().isEmpty() && !visitedNeighbors.isEmpty())
          {
            current = c;
            Cell neighbor = visitedNeighbors.get((int)random(visitedNeighbors.size()));
            current.link(neighbor, true);
            break;
          }
        } 
      }
    }
    
  }
}
