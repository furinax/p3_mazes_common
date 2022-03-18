class SideWinder2 {
  void on(Grid g){
    int irow = 0;
    for( ArrayList<Cell> row : g._cells )
    {
      irow++;
      ArrayList<Cell> run = new ArrayList<Cell>();
       for( Cell cell : row )
       {
         run.add(cell);
         
          boolean isRight = cell.right == null, isUp = cell.up == null;
          
          boolean isCloseRow = isRight || (!isUp && ((int) random(irow % 5 + 5) == 0));
          
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
