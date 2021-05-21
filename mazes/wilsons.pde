class Wilsons {
  void on(Grid g){
    ArrayList<Cell> unvisited = new ArrayList<Cell>();
    for( Cell c: g.eachCell())
    {
      unvisited.add(c);
    }
    
    int first_index = (int)random(unvisited.size());
    unvisited.remove(first_index);
    
    while( !unvisited.isEmpty() )
    {
      Cell cell = unvisited.get((int)random(unvisited.size()));
      ArrayList<Cell> path = new ArrayList<Cell>();
      path.add(cell);
      while(unvisited.indexOf(cell) >= 0 )
      {
        print("\n",cell.pos.x, " " , cell.pos.y);
         cell = cell.neighbors()[(int)random(cell.neighbors().length)]; //<>// //<>// //<>// //<>//
         int position = path.indexOf(cell);
         if( position >= 0 )
         {
           path = new ArrayList<Cell>(path.subList(0, position+1));
         }
         else
         {
           path.add(cell);
         }
      }
      for( int x = 0 ; x < path.size() - 1; x++ )
      {
        ((Cell)path.get(x)).link(path.get(x+1), true);
        unvisited.remove(path.get(x));
      }
    }
  }
}
