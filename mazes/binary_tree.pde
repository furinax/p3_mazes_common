class BinaryTree {
  void on(Grid g){
    Cell[] gc = g.eachCell();
    for( Cell c : gc )
    {
      ArrayList<Cell> neighbors = new ArrayList<Cell>();
      if( c.down != null)
        neighbors.add(c.down);
      if( c.right != null)
        neighbors.add(c.right);
        
      if( neighbors.size() > 0 ) {
        int index = (int) random(neighbors.size());
        Cell newNeighbor = neighbors.get(index);
        c.link(newNeighbor, true);
      }
    }
  }
}
