class WeaveGrid extends Grid {
  ArrayList<UnderCell> underCells;
  float inset = .1f;
  WeaveGrid(int rows, int columns) {
      super(rows, columns);
      underCells = new ArrayList<UnderCell>();
      prepare();
      super.configure();
  }
  
  void prepare() {

    for( int h = 0; h < this._height ; h++ )
    {
      _cells.add(new ArrayList<Cell>(this._width));
      for( int w = 0 ; w < this._width; w++ ){
        _cells.get(h).add(new OverCell(h, w, this));
      }
    }
  }
  
  void tunnelUnder( OverCell over_cell ) {
    UnderCell under_cell = new UnderCell(over_cell);
    underCells.add(under_cell);
  }
  
  Cell[] eachCell() {

    Cell[] retVal = new Cell[this._height*_cells.get(0).size() + underCells.size()];
    int retValInsertionIndex = 0;
    for( int h = 0; h < this._height ; h++ )
    {
      for( int w = 0 ; w < this._width; w++ ){
        retVal[retValInsertionIndex++] = _cells.get(h).get(w);
      }
    }
    for( int i = 0; i < underCells.size() ; i++ )
    {
      retVal[retValInsertionIndex++] = underCells.get(i);
    }
    
    return retVal;
  }
  
  void onDraw() {
    stroke(255);
    strokeWeight(2);
    fill(255);
    
    int MARGIN = 50;
    int LEFT_ = MARGIN, TOP_ = MARGIN, RIGHT_ = width - MARGIN, BOTTOM_ = height - MARGIN;
    int STEP_H = (BOTTOM_ - TOP_) / this._height;
    int STEP_W = (RIGHT_ - LEFT_) / this._width;
    int inset_w = int(STEP_W * inset);
    int inset_h = int(STEP_H * inset);

    for( int h = 0; h < this._height ; h++ ){
      for( int w = 0 ; w < this._width; w++ ){
        PVector origin = new PVector(LEFT_ + STEP_W * w, TOP_ + STEP_H * h);
        Cell current_cell = _cells.get(h).get(w);
        
        if( current_cell == null || current_cell.links().isEmpty() )
          continue;
          
        // cell coordinates with inset
        float x1 = origin.x, x4 = origin.x + STEP_W;
        float x2 = x1 + inset_w, x3 = x4 - inset_w;
        float y1 = origin.y, y4 = origin.y + STEP_H;
        float y2 = y1 + inset_h, y3 = y4 - inset_h;
        _palette.colorizeRowCol(current_cell.pos);
        
        if( current_cell instanceof OverCell ) //we should really solve this with polymorphism
        {
        
          if( current_cell.links().contains(current_cell.up) ) {
            line( x2, y1, x2, y2);
            line( x3, y1, x3, y2);
          }
          else {
            line( x2, y2, x3, y2);
          }
          
          if( current_cell.links().contains( current_cell.down ) ){
            line( x2, y3, x2, y4);
            line( x3, y3, x3, y4);
          }
          else {
            line( x2, y3, x3, y3);
          }
          
          if( current_cell.links().contains( current_cell.left )) {
            line( x1, y2, x2, y2);
            line( x1, y3, x2, y3);
          } else {
            line( x2, y2, x2, y3);
          }
          
          if( current_cell.links().contains( current_cell.right )) {
            line( x3, y2, x4, y2);
            line( x3, y3, x4, y3);
          } else {
            line( x3, y2, x3, y3);
          }
        } else {
          if( ((OverCell)current_cell).isVerticalPassage() )
          {
            line( x2, y1, x2, y2);
            line( x3, y1, x3, y2);
            line( x2, y3, x2, y4);
            line( x3, y3, x3, y4);
          } else {
            line( x1, y2, x2, y2);
            line( x1, y3, x2, y3);
            line( x3, y2, x4, y2);
            line( x3, y3, x4, y3);
          }
        }
        
      }
    }
      _startArrow.draw();
        _finishArrow.draw();
  }
}
