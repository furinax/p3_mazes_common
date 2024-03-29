class TriangleGrid extends Grid {

    int MARGIN = 50;
    int CELL_SIZE = 20;
    
    float half_width = CELL_SIZE / 2.0;
    float cell_height = (float)(CELL_SIZE * Math.sqrt(3) / 2.0);
    float half_height = cell_height / 2.0;
  
  TriangleGrid(int rows, int cols) {
    _cells = new ArrayList<ArrayList<Cell>>(rows);
    this._height = rows;
    this._width = cols;
    prepare();
    configure();
  }
  
  void prepare(){
    for( int h = 0; h < this._height ; h++ )
    {
      _cells.add(new ArrayList<Cell>(this._width));
      for( int w = 0 ; w < this._width; w++ ){
        _cells.get(h).add(new TriangleCell(h, w));
        
      }
    }
  }
  
  void configure() {
    for( int row = 0; row < _cells.size(); row++){
      for( int col = 0; col < _cells.get(row).size(); col++){
        TriangleCell current_cell = (TriangleCell) this._cells.get(row).get(col);
        if( col > 0 )
          current_cell.left = _cells.get(row).get(col - 1);
        if( col < this._width - 1 )
          current_cell.right = _cells.get(row).get(col + 1);
        
        if( current_cell.upright() ) {
          if( row < this._height - 1)
            current_cell.down = _cells.get(row + 1).get(col);
        } else {
          if( row > 0 )
            current_cell.up = _cells.get(row - 1).get(col);          
        }
      }
    }
    _startArrow = new Arrow(color(0, 255, 0), new PVector(10, 10));
    _finishArrow = new Arrow(color(255, 0, 0), new PVector(half_width * this._width + 30, cell_height * this._height + 20));
    
  }
  
void onDraw(){

    
    pushMatrix();
    translate(MARGIN, MARGIN);
    
    stroke(255);
    strokeWeight(2);
    noFill();
    
    boolean drawBackground = true;

    for( int i = 0; i < 2 ; i++, drawBackground = false) {
      for( int h = 0; h < _cells.size() ; h++ ){
        for( int w = 0 ; w < _cells.get(h).size(); w++ ){
          TriangleCell current_cell = (TriangleCell)this._cells.get(h).get(w);
          
          
          float cx = half_width + current_cell.pos.y * half_width;
          float cy = half_height + current_cell.pos.x * cell_height;
          
          int west_x = int(cx - half_width);
          int mid_x = int(cx);
          int east_x = int(cx + half_width);
          int apex_y, base_y;
          if( current_cell.upright() ) {
            apex_y = int(cy - half_height);
            base_y = int(cy + half_height);
            
          } else {
            apex_y = int(cy + half_height);
            base_y = int(cy - half_height);
          }
          
          if( drawBackground )
          {
            fill(255);
            beginShape();

            vertex(west_x, base_y);
            vertex(mid_x, apex_y);
            vertex(east_x, base_y);

            endShape(CLOSE);
          }
          else
          {
            _palette.colorizeRowCol(current_cell.pos);
            
            if( current_cell.left == null )
              line(west_x, base_y, mid_x, apex_y);
            
            if( !current_cell.isLinked(current_cell.right) )
              line(east_x, base_y, mid_x, apex_y);
            
            boolean no_south = current_cell.upright() && current_cell.down == null;
            boolean not_linked = !current_cell.upright() && !current_cell.isLinked( current_cell.up );
            
            if( no_south || not_linked )
            {
              line( east_x, base_y, west_x, base_y);
            }
          }
        }
      }  
    }
    _startArrow.draw();
    _finishArrow.draw();
    popMatrix();
  }

}
