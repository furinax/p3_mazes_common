class PolarGrid extends Grid {

  PolarGrid(int rows) {
    _cells = new ArrayList<ArrayList<Cell>>(rows);
    this._height = rows;
    _palette = new Palette(_height, _height, color(200, 50, 50), color(0, 120, 120), color(0, 0, 255));
    prepare();
    configure();
  }
  
  void prepare(){
    float row_height = 1.0 / this._height;
    _cells.add(new ArrayList<Cell>());
    _cells.get(0).add(new PolarCell(0, 0));

    for( int i = 1 ; i < this._height; i++) {
      float radius = (float) i / this._height;
      float circumference = 2 * PI * radius;

      int previous_count = _cells.get(i - 1).size();
      float estimated_cell_width = circumference / previous_count;

      float ratio = round(estimated_cell_width / row_height);

      int numCells = int(previous_count * ratio);

      _cells.add( new ArrayList<Cell>(numCells));
      for( int j = 0 ; j < numCells; j++ ) {
        _cells.get(i).add(new PolarCell(i, j));
      }
    }
  }
  
  void configure() {
    for( int row = 0; row < _cells.size(); row++){
      for( int col = 0; col < _cells.get(row).size(); col++){
        if (row > 0) {
          PolarCell cell = (PolarCell)_cells.get(row).get(col);
          
          if( col < _cells.get(row).size() - 1)
            cell.cw = (PolarCell)_cells.get(row).get(col+1);
          else
            cell.cw = (PolarCell)_cells.get(row).get(0);
          
          if( col > 0 )
            cell.ccw = (PolarCell)_cells.get(row).get(col-1);
          else
            cell.ccw = (PolarCell)_cells.get(row).get(_cells.get(row).size()-1);
            
          float ratio = float(_cells.get(row).size()) / _cells.get(row-1).size();
          PolarCell parent = (PolarCell)_cells.get(row-1).get(int(col/ratio));
          parent._outward.add(cell);
          cell.inward = parent;
        }
        else
        {
          PolarCell cell = (PolarCell)_cells.get(0).get(0);
          for(int i = 0; i < _cells.get(1).size(); i++)
            cell._outward.add((PolarCell)_cells.get(1).get(i));
        }
      }
    }
  }
  
  Cell[] eachCell() {
    ArrayList<Cell> mergedList = new ArrayList<Cell>();
    for( int h = 0; h < this._cells.size() ; h++ )
    {
      mergedList.addAll(this._cells.get(h));
    }
    return mergedList.toArray(new Cell[0]);
  }
  
  int size() {
    int s = 0;
     for( int row = 0; row < _cells.size(); row++) {
       s += _cells.get(row).size();
     } 
     return s;
  }
  
void onDraw(){

    stroke(0);
    strokeWeight(2);
    noFill();
    int MARGIN = 50;
    int CELL_SIZE = 20;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    PVector origin = new PVector(width/2, height/2);

    for( int h = 0; h < _cells.size() ; h++ ){
      for( int w = 0 ; w < _cells.get(h).size(); w++ ){
        
        PolarCell current_cell = (PolarCell)_cells.get(h).get(w);

        if( current_cell == null  || current_cell.pos.x == 0)
          continue;
        _palette.colorizeRow(current_cell.pos);
        
        float theta = 2*PI/_cells.get(h).size();
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
