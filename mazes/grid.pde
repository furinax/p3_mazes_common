class Grid {
  Cell[][] cells;
  Grid(int h, int w){
    cells = new Cell[h][w];
    prepare();
    configure();
  }
  
  Cell get(int h, int w){
    if( h < 0 || h > cells.length - 1)
      return null;
    if( w < 0 || w > cells[0].length - 1)
      return null; 
    return cells[h][w];
  }
  
  Cell randomCell() {
    return cells[(int)random(cells.length)][(int)random(cells[0].length)];
  }
  
  Cell[] eachCell() {
    Cell[] retVal = new Cell[cells.length*cells[0].length];
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        retVal[h*cells[0].length + w] = cells[h][w];
      }
    }
    return retVal;
  }
  
  
  int size() {
     return cells.length * cells[0].length;
  }
  
  void prepare(){
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        cells[h][w] = new Cell(h, w);
      }
    }
  }
  
  void configure() {
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        cells[h][w].up = this.get(h-1,w);
        cells[h][w].down = this.get(h+1,w);
        cells[h][w].left = this.get(h,w-1);
        cells[h][w].right = this.get(h,w+1);
      }
    }
  }

  
  void onDraw(){
    stroke(255);
    strokeWeight(2);
    int MARGIN = 50;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    int STEP_H = (BOTTOM - TOP) / cells.length;
    int STEP_W = (RIGHT - LEFT) / cells[0].length;
    for( int h = 0; h < cells.length ; h++ ){
      for( int w = 0 ; w < cells[0].length; w++ ){
        PVector origin = new PVector(LEFT + STEP_W * w, TOP + STEP_H * h);
        Cell current_cell = cells[h][w];
        if( current_cell.up == null || !current_cell.links().contains(current_cell.up))
          line(origin.x, origin.y, origin.x+STEP_W, origin.y);
        if( current_cell.down == null || !current_cell.links().contains(current_cell.down))
          line(origin.x, origin.y+STEP_H, origin.x+STEP_W, origin.y+STEP_H);
        if( current_cell.left == null || !current_cell.links().contains(current_cell.left))
          line(origin.x, origin.y, origin.x, origin.y+STEP_H);
        if( current_cell.right == null || !current_cell.links().contains(current_cell.right))
          line(origin.x+STEP_W, origin.y, origin.x+STEP_W, origin.y+STEP_H);
      }
    }
    
  }
  
  Cell[] deadEnds(){
    ArrayList<Cell> deadends = new ArrayList<Cell>();
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        if( cells[h][w].links().size() == 1 )  
          deadends.add(cells[h][w]);
      }
    }
    Cell[] retVal = new Cell[deadends.size()];
    retVal = deadends.toArray(retVal);
    return retVal;
  }
}
