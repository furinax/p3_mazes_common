class Grid {
  ArrayList<ArrayList<Cell>> _cells;
  int _height;
  int _width;
  
  PVector _start, _finish;
  
  Grid() {
  }
  
  Grid(int h, int w){
    _height = h;
    _width = w;
    _cells = new ArrayList<ArrayList<Cell>>(h);
    _start = new PVector(0, 0);
    _finish = new PVector(_height-1, _width-1);
    
    prepare();
    configure();
  }
  
  Cell get(int h, int w){
    if( h < 0 || h > this._height - 1)
      return null;
    if( w < 0 || w > this._width - 1)
      return null;
    return _cells.get(h).get(w);
  }
  
  Cell randomCell() {
    return _cells.get((int)random(this._height)).get((int)random(this._width));
  }
  
  Cell[] eachCell() {
    Cell[] retVal = new Cell[this._height*_cells.get(0).size()];
    for( int h = 0; h < this._height ; h++ )
    {
      for( int w = 0 ; w < this._width; w++ ){
        retVal[h*this._height + w] = _cells.get(h).get(w);
      }
    }
    return retVal;
  }
  
  
  int size() {
     return this._height * this._width;
  }
  
  void prepare(){
    for( int h = 0; h < this._height ; h++ )
    {
      _cells.add(new ArrayList<Cell>(this._width));
      for( int w = 0 ; w < this._width; w++ ){
        _cells.get(h).add(new Cell(h, w));
      }
    }
  }
  
  void configure() {
    for( int h = 0; h < this._height ; h++ )
    {
      for( int w = 0 ; w < this._width; w++ ){
        if( _cells.get(h).get(w) == null )
          continue;
        _cells.get(h).get(w).up = this.get(h-1,w);
        _cells.get(h).get(w).down = this.get(h+1,w);
        _cells.get(h).get(w).left = this.get(h,w-1);
        _cells.get(h).get(w).right = this.get(h,w+1);
      }
    }
  }

  
  void onDraw(){
    stroke(255);
    strokeWeight(2);
    fill(255);
    int MARGIN = 50;
    int LEFT_ = MARGIN, TOP_ = MARGIN, RIGHT_ = width - MARGIN, BOTTOM_ = height - MARGIN;
    int STEP_H = (BOTTOM_ - TOP_) / this._height;
    int STEP_W = (RIGHT_ - LEFT_) / this._width;
    for( int h = 0; h < this._height ; h++ ){
      for( int w = 0 ; w < this._width; w++ ){
        PVector origin = new PVector(LEFT_ + STEP_W * w, TOP_ + STEP_H * h);
        Cell current_cell = _cells.get(h).get(w);
        if( current_cell == null )
          continue;
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
    drawEndpoints(LEFT_, TOP_, RIGHT_, BOTTOM_, STEP_W, STEP_H);
  }
  
  void drawEndpoints(int LEFT_, int TOP_, int RIGHT_, int BOTTOM_, int STEP_W, int STEP_H) {
    textSize(32);
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    text("S", LEFT_ + STEP_W/2, TOP_ + STEP_H/2);
    fill(0, 255, 0);
    text("F", RIGHT_ - STEP_W/2, BOTTOM_ - STEP_H/2);
  }
  
  Cell[] deadEnds(){
    ArrayList<Cell> deadends = new ArrayList<Cell>();
    for( int h = 0; h < this._height ; h++ )
    {
      for( int w = 0 ; w < this._width; w++ ){
        if( _cells.get(h).get(w) == null)
          continue;
        if( _cells.get(h).get(w).links().size() == 1 )  
          deadends.add(_cells.get(h).get(w));
      }
    }
    Cell[] retVal = new Cell[deadends.size()];
    retVal = deadends.toArray(retVal);
    return retVal;
  }
}
