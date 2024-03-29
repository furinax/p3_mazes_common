class PolarGrid extends Grid {
  int CELL_SIZE = 13;
  
  PolarGrid(int rows) {
    _cells = new ArrayList<ArrayList<Cell>>(rows);
    this._height = rows;
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
    
    
    PVector origin = new PVector(width/2, height/2);
    float theta = 2*PI/_cells.get(_cells.size() - 1 ).size();
    int inner_radius = _cells.size()  * CELL_SIZE;
    float theta_ccw = _cells.get(0).size()  * theta;


    //set cell selection vars
    int startX = _cells.size() - 1;
    int startY = (_cells.get(_cells.size() - 1).size()-1)/2+1;
    _cells.get(startX).get(startY).isCurrent = true;
    _cells.get(startX).get(startY).isVisited = true;
    _selectedCell = _cells.get(startX).get(startY);

     //set start/finish arrows
     _startArrow = new Arrow(color(0, 255, 0), 
       new PVector(origin.x - int(inner_radius * cos(theta_ccw)), 
       origin.y - int(inner_radius * sin(theta_ccw))));
    _finishArrow = new Arrow(color(255, 0, 0), 
      new PVector(origin.x + int(inner_radius * cos(theta_ccw) + 2 * CELL_SIZE), 
      origin.y + int(inner_radius * sin(theta_ccw))));
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
    PVector origin = new PVector(width/2, height/2);
    fill(255);
    noStroke();
    circle(origin.x, origin.y, _cells.size()*CELL_SIZE*2 );
    
    stroke(0);
    strokeWeight(2);
    noFill();
    
    

    for( int h = 0; h < _cells.size() ; h++ ){
      for( int w = 0 ; w < _cells.get(h).size(); w++ ){
        
        PolarCell current_cell = (PolarCell)_cells.get(h).get(w);

        if( current_cell == null )
          continue;
        
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
        
      
        //draw background        
        if( mouseX < Math.max(Math.max(ax, bx), Math.max(cx, dx)) && 
        mouseY < Math.max(Math.max(ay, by), Math.max(cy, dy)) && 
        mouseX > Math.min(Math.min(ax, bx), Math.min(cx, dx)) &&
        mouseY > Math.min(Math.min(ay, by), Math.min(cy, dy)))
        {
          if( current_cell.isLinked(_selectedCell) || current_cell.isVisited)
          {
            _selectedCell.isCurrent = false;
            current_cell.isVisited = true;
            current_cell.isCurrent = true;
            _selectedCell = current_cell;
          }
        } else if( h == 0 && dist(mouseX, mouseY, origin.x, origin.y) < CELL_SIZE )
        {
          if( current_cell.isLinked(_selectedCell) || current_cell.isVisited)
          {
            _selectedCell.isCurrent = false;
            current_cell.isVisited = true;
            current_cell.isCurrent = true;
            _selectedCell = current_cell;
          }

        }
       
        
        if( current_cell.isVisited )
        {
          noStroke();
          if( current_cell.isCurrent )
            fill(0, 165, 0);
          else
            fill(200, 200, 200);
            
          if( h == 0 ) // draw middle circle
            circle( origin.x, origin.y, CELL_SIZE/2);
          else
            circle((ax+bx+cx+dx)/4 , (ay+by+cy+dy)/4, CELL_SIZE/2);
        }
        
        noFill();
        _palette.colorizeRow(current_cell.pos);
        // draw boundaries
        if( current_cell.pos.x == 0)
          continue;
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
     _startArrow.draw();
    _finishArrow.draw();
  }
  
}
