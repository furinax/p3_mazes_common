class SideWinder {
  void on(Grid g){
    for( Cell[] row : g.cells )
    {
      ArrayList<Cell> run = new ArrayList<Cell>();
       for( Cell cell : row )
       {
         run.add(cell);
         
          boolean isRight = cell.right == null, isUp = cell.up == null;
          
          boolean isCloseRow = isRight || (!isUp && ((int) random(2) == 0));
          
          if( isCloseRow )
          {
            Cell member = run.get((int) random(run.size()));
            if( member.up != null )
              member.link(member.up, true);
            run.clear();
          }
          else
          {
            cell.link(cell.right, true);
          }
          
       }
    }
  }
}
