class AlduousBroder {
  void on(Grid g){
    Cell c = g.randomCell();
    int unvisited = g.size() - 1;
    
    while (unvisited > 0) {
      Cell[] neighbors = c.neighbors();
      Cell neighbor = neighbors[(int)random(neighbors.length)];
      if( neighbor.links().isEmpty() )
      {
        c.link(neighbor,true);
        unvisited -= 1;
      }
      c = neighbor;
    }
  }
}
