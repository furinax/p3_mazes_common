class PolarGrid extends Grid {
  
  ArrayList<ArrayList<PolarCell>> _rows;

  PolarGrid(int rows) {
    super(rows, 1);
    prepare();
    configure();
  }
  
  void prepare(){
    int row_count = this.cells.length;
    _rows = new ArrayList<ArrayList<PolarCell>>(row_count);
    float row_height = 1.0 / row_count;
    _rows.add(new ArrayList<PolarCell>());
    _rows.get(0).add(new PolarCell(0, 0));

    for( int i = 1 ; i < row_count; i++) {
      float radius = (float) i / row_count;
      float circumference = 2 * PI * radius;

      int previous_count = _rows.get(i - 1).size();
      float estimated_cell_width = circumference / previous_count;

      float ratio = round(estimated_cell_width / row_height);

      int numCells = int(previous_count * ratio);

      _rows.add( new ArrayList<PolarCell>(numCells));
      for( int j = 0 ; j < numCells; j++ ) {
        _rows.get(i).add(new PolarCell(i, j));
      }
    }
  }
  
  void configure() {
    for( int row = 0; row < _rows.size(); row++){
      for( int col = 0; col < _rows.get(row).size(); col++){
        if (row > 0) {
          PolarCell cell = _rows.get(row).get(col);
          
          if( col < _rows.get(row).size() - 1)
            cell.cw = _rows.get(row).get(col+1);
          else
            cell.cw = _rows.get(row).get(0);
          
          if( col > 0 )
            cell.ccw = _rows.get(row).get(col-1);
          else
            cell.ccw = _rows.get(row).get(_rows.get(row).size()-1);
            
          float ratio = float(_rows.get(row).size()) / _rows.get(row-1).size();
          PolarCell parent = _rows.get(row-1).get(int(col/ratio));
          parent._outward.add(cell);
          cell.inward = parent;
        }
        else
        {
          PolarCell cell = _rows.get(0).get(0);
          cell._outward.addAll(_rows.get(1));
        }
      }
    }
  }

  Cell randomCell() {
    int row = int(random(_rows.size()));
    return this._rows.get(row).get(int(random(_rows.get(row).size())));
  }
  
  Cell[] eachCell() {
    ArrayList<Cell> mergedList = new ArrayList<Cell>();
    for( int h = 0; h < this._rows.size() ; h++ )
    {
      mergedList.addAll(this._rows.get(h));
    }
    return mergedList.toArray(new Cell[0]);
  }
  
  int size() {
    int s = 0;
     for( int row = 0; row < _rows.size(); row++) {
       s += _rows.get(row).size();
     } 
     return s;
  }
  
void onDraw(){

    stroke(255);
    strokeWeight(2);
    noFill();
    int MARGIN = 50;
    int CELL_SIZE = 20;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    PVector origin = new PVector(width/2, height/2);

    for( int h = 0; h < _rows.size() ; h++ ){
      for( int w = 0 ; w < _rows.get(h).size(); w++ ){
        
        PolarCell current_cell = _rows.get(h).get(w);

        if( current_cell == null  || current_cell.pos.x == 0)
          continue;

        float theta = 2*PI/_rows.get(h).size();
        int inner_radius = h * CELL_SIZE;
        int outer_radius = (h+1) * CELL_SIZE;
        float theta_ccw = w * theta;
        float theta_cw = (w+1) * theta;

        float ax = origin.x + int(inner_radius * cos(theta_ccw)); 
        float ay = origin.y + int(inner_radius * sin(theta_ccw));
        float bx = origin.x + int(outer_radius * cos(theta_ccw)); 
        float by = origin.y + int(outer_radius * sin(theta_ccw));
        float cx = origin.x + int(inner_radius * cos(theta_cw)); 
        float cy = origin.y + int(inner_radius * sin(theta_cw));
        float dx = origin.x + int(outer_radius * cos(theta_cw)); 
        float dy = origin.y + int(outer_radius * sin(theta_cw));
        
      
        if( current_cell.inward == null || !current_cell.links().contains(current_cell.inward))
          arc(origin.x, origin.y, 2*inner_radius, 2*inner_radius, theta_ccw, theta_cw);
        if( current_cell._outward.size() == 0 )
          arc(origin.x, origin.y, 2*outer_radius, 2*outer_radius, theta_ccw, theta_cw);
        if( current_cell.ccw == null || !current_cell.links().contains(current_cell.ccw))
          line(ax, ay, bx, by);
        if( current_cell.cw == null || !current_cell.links().contains(current_cell.cw))
          line(cx, cy, dx, dy);
      }
    }
    
  }

}
