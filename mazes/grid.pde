import java.util.function.Predicate;

class Grid {
  ArrayList<ArrayList<Cell>> _cells;
  int _height;
  int _width;
  Palette _palette;
  Arrow _startArrow;
  Arrow _finishArrow;
  
  int MARGIN = 50;
  int LEFT_ = MARGIN, TOP_ = MARGIN, RIGHT_ = width - MARGIN, BOTTOM_ = height - MARGIN;
  int STEP_H;
  int STEP_W;
    
  
  Grid() {
  }
  
  Grid(int h, int w){
    _height = h;
    _width = w;
    _cells = new ArrayList<ArrayList<Cell>>(h);
    STEP_H = (BOTTOM_ - TOP_) / this._height;
    STEP_W = (RIGHT_ - LEFT_) / this._width;
  
    _palette = new Palette(_height, _width, color(0, 255, 0), color(204, 85, 0), color(204, 85, 0));
    
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
    
    _startArrow = new Arrow(color(0, 255, 0), 
       new PVector(MARGIN + STEP_W / 2, MARGIN + STEP_H / 2));
    _finishArrow = new Arrow(color(255, 0, 0), 
      new PVector( STEP_W * this._width + MARGIN + STEP_W / 2, STEP_H * this._height + MARGIN + STEP_H / 2));
  }

  
  void onDraw(){
    stroke(255);
    strokeWeight(2);
    fill(255);
    
   
    for( int h = 0; h < this._height ; h++ ){
      for( int w = 0 ; w < this._width; w++ ){
        PVector origin = new PVector(LEFT_ + STEP_W * w, TOP_ + STEP_H * h);
        Cell current_cell = _cells.get(h).get(w);
        
        if( current_cell == null  || current_cell.links().isEmpty() )
          continue;
          
        _palette.colorizeRowCol(current_cell.pos);
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
    _startArrow.draw();
    _finishArrow.draw();
  
}
  
  Cell[] deadEnds(){
    ArrayList<Cell> deadends = new ArrayList<Cell>();
    for( int h = 0; h < this._cells.size() ; h++ )
    {
      for( int w = 0 ; w < this._cells.get(h).size(); w++ ){
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
  
  void braid(float p) {
    ArrayList<Cell> _deadends_list = new ArrayList<Cell>();
    Collections.addAll(_deadends_list, deadEnds());
    Collections.shuffle(_deadends_list);
    
    if( p > 0 ) {
      for( Cell c : _deadends_list) {
        if( c.links.size() != 1 || random(1) > p)
          continue;
        
        ArrayList _bestNeighbors = new ArrayList<Cell>();
        for( Cell n: c.neighbors() ) {
          if( !c.isLinked((n)) )
          {
            _bestNeighbors.add(n);
          }
        }
        
        Cell[] best = _bestNeighbors.isEmpty() ? c.neighbors() : (Cell[])_bestNeighbors.toArray(new Cell[0]);
        c.link(best[(int)random(best.length)], true);
      }
    }
    else if( p < 0) {
      for( Cell c : _deadends_list) {
        if( c.links.size() != 1 || random(-1, 0) < p)
          continue;
        
        //make sparse
        Cell sparse_head = c.links().iterator().next();
        Cell sparse_tail = c;
        while( sparse_head.links().size() == 2)
        {
          sparse_head.unlink(sparse_tail, true);
          sparse_tail = sparse_head;
          sparse_head = sparse_head.links().iterator().next();
        }
      }
    }
  }
}
