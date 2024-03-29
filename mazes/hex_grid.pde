class HexGrid extends Grid {
  int MARGIN = 10;
  int CELL_SIZE = 20;
  int STROKE_WEIGHT = 2;
    
  HexGrid(int rows, int cols) {
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
        _cells.get(h).add(new HexCell(h, w));
      }
    }
  }
  
  void configure() { //<>// //<>//
    for( int row = 0; row < _cells.size(); row++){
      for( int col = 0; col < _cells.get(row).size(); col++){
        int north_diagonal, south_diagonal;
        if( col % 2 == 0) {
          north_diagonal = row - 1;
          south_diagonal = row;
        } else {
          north_diagonal = row;
          south_diagonal = row + 1;
        }
        HexCell current_cell = (HexCell) this._cells.get(row).get(col);
        
        if( col - 1 >= 0 && north_diagonal >= 0 )
          current_cell.nw = (HexCell) this._cells.get(north_diagonal).get(col-1);
        if( row > 0 )  
          current_cell.up = this._cells.get(row - 1).get(col);
        if( col < _width - 1 && north_diagonal >= 0)
          current_cell.ne = (HexCell)this._cells.get(north_diagonal).get(col+1);
        if( col - 1 >= 0 && south_diagonal < _height)
          current_cell.sw = (HexCell)this._cells.get(south_diagonal).get(col-1);
        if( row < _height - 1 )
          current_cell.down = this._cells.get(row + 1).get(col);
        if( col < _width - 1 && south_diagonal < _height)
          current_cell.se = (HexCell)this._cells.get(south_diagonal).get(col+1);
        
      }
    }
    _startArrow = new Arrow(color(0, 255, 0), 
       new PVector(CELL_SIZE , CELL_SIZE));
       double hex_size = (CELL_SIZE * Math.sqrt(3));
    _finishArrow = new Arrow(color(255, 0, 0), 
      new PVector( (int)(hex_size * .85 * _cells.get(0).size()) + 35, (int)(hex_size * _cells.size()) + 25));
  }
  
void onDraw(){
    
    
    pushMatrix();
    translate(MARGIN, MARGIN);
    
    stroke(0);
    fill(255);
    strokeWeight(STROKE_WEIGHT);

    float a_size = CELL_SIZE / 2.0;
    float b_size = (float)(CELL_SIZE * Math.sqrt(3) / 2.0);
    int CELL_HEIGHT = parseInt(b_size * 2);
    
    boolean drawBackground = true;
    
    for( int i = 0 ; i < 2 ; i++, drawBackground = false)
    for( int h = 0; h < _cells.size() ; h++ ){
      for( int w = 0 ; w < _cells.get(h).size(); w++ ){
        HexCell current_cell = (HexCell)this._cells.get(h).get(w);
        
        int cx = parseInt(CELL_SIZE + 3 * current_cell.pos.y * a_size);
        int cy = parseInt(b_size + current_cell.pos.x * CELL_HEIGHT);
        if( current_cell.pos.y % 2 == 1 )
          cy += b_size;

        // f/n = far/near
        // n/s/e/w = north south east west

        int x_fw = cx - CELL_SIZE,
        x_nw = parseInt(cx - a_size),
        x_ne = parseInt(cx + a_size),
        x_fe = parseInt(cx + CELL_SIZE);

        // m = middle

        int y_n = parseInt(cy - b_size),
        y_m = cy,
        y_s = parseInt(cy + b_size);

        if( drawBackground )
        {
          stroke(255);
          beginShape();
          vertex(x_nw, y_s);
          vertex(x_fw, y_m);
          vertex(x_nw, y_n);
          vertex(x_ne, y_n);
          vertex(x_fe, y_m);
          vertex(x_ne, y_s);
          endShape(CLOSE);
        }
        else
        {
        strokeWeight(STROKE_WEIGHT);
        _palette.colorizeRowCol(current_cell.pos);
        //draw cell edges
        if( current_cell.sw == null ) 
          line(x_fw, y_m, x_nw, y_s);
        if( current_cell.nw == null ) 
          line(x_fw, y_m, x_nw, y_n);
        if( current_cell.up == null ) 
          line(x_nw, y_n, x_ne, y_n);
        if( !current_cell.isLinked(current_cell.ne)) 
          line(x_ne, y_n, x_fe, y_m);
        if( !current_cell.isLinked(current_cell.se)) 
          line(x_fe, y_m, x_ne, y_s);
        if( !current_cell.isLinked(current_cell.down)) 
          line(x_ne, y_s, x_nw, y_s);
        }
      }
    }
    
      _startArrow.draw();
    _finishArrow.draw();
    popMatrix();
  }

}
