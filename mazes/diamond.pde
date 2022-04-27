class DiamondGrid extends Grid {
  
  DiamondGrid(int rows, int columns) {
      super(rows, columns);
      STEP_H = 26;
      STEP_W = 20;
      LEFT_ = width/2;
      
    //init arrows
    _startArrow = new Arrow(color(0, 255, 0), 
       new PVector(LEFT_, TOP_));
    _finishArrow = new Arrow(color(255, 0, 0), 
      new PVector( LEFT_, BOTTOM_));
  }
 
  
  void onDraw() {
    
    stroke(255);
    strokeWeight(STROKEWEIGHT_);
    fill(255);
    
    
   
    for( int h = 0; h < this._height ; h++ ){
      for( int w = 0 ; w < this._width; w++ ){
        PVector origin = new PVector(LEFT_ + STEP_W/2 * w - STEP_W/2 * h, TOP_ + STEP_H/2 * w + STEP_H/2 * h);
        Cell current_cell = _cells.get(h).get(w);
        
        if( current_cell == null  || current_cell.links().isEmpty() )
          continue;

        //draw boundaries of cell
        _palette.colorizeRowCol(current_cell.pos);
        
        
        
        if( current_cell.up == null || !current_cell.links().contains(current_cell.up))
          line(origin.x, origin.y, origin.x+STEP_W/2, origin.y+STEP_H/2);
        if( current_cell.down == null || !current_cell.links().contains(current_cell.down))
          line(origin.x-STEP_W/2, origin.y+STEP_H/2, origin.x, origin.y+STEP_H);
        if( current_cell.left == null || !current_cell.links().contains(current_cell.left))
          line(origin.x, origin.y, origin.x - STEP_W/2, origin.y+ STEP_H/2);
        if( current_cell.right == null || !current_cell.links().contains(current_cell.right))
          line(origin.x+STEP_W/2, origin.y+STEP_H/2, origin.x, origin.y+STEP_H);
      }
    }
    _startArrow.draw();
    _finishArrow.draw();
    
  }
}
