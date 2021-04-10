class PolarGrid extends Grid {
  private final Mask _mask;
  
  PolarGrid(Mask mask) {
    super(mask.rows, mask.cols);
    this._mask = mask;
    prepareMask();
    configure(); //reconfigure, how do we avoid this?
  }
  
  void prepareMask() {
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        if( !this._mask.get(h, w) )
          this.cells[h][w] = null;
      }
    }
  }
  
  Cell randomCell() {
    PVector p = this._mask.randomLocation();
    return this.cells[int(p.y)][int(p.x)];
  }
  
  int size() {
     return this._mask.count(); 
  }
  
void onDraw(){

    stroke(255);
    strokeWeight(2);
    noFill();
    int MARGIN = 50;
    int CELL_SIZE = 20;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    PVector origin = new PVector(width/2, height/2);

    for( int h = 0; h < cells.length ; h++ ){
      for( int w = 0 ; w < cells[0].length; w++ ){
        
        Cell current_cell = cells[h][w];

        if( current_cell == null )
          continue;

        float theta = 2*PI/cells[0].length;
        int inner_radius = h * CELL_SIZE;
        int outer_radius = (h+1) * CELL_SIZE;
        float theta_ccw = w * theta;
        float theta_cw = (w+1) * theta;

        float ax = origin.x + inner_radius * cos(theta_ccw); 
        float ay = origin.y + inner_radius * sin(theta_ccw);
        float bx = origin.x + outer_radius * cos(theta_ccw); 
        float by = origin.y + outer_radius * sin(theta_ccw);
        float cx = origin.x + inner_radius * cos(theta_cw); 
        float cy = origin.y + inner_radius * sin(theta_cw);
        float dx = origin.x + outer_radius * cos(theta_cw); 
        float dy = origin.y + outer_radius * sin(theta_cw);
        

        if( current_cell.up == null || !current_cell.links().contains(current_cell.up))
          arc(origin.x, origin.y, 2*inner_radius, 2*inner_radius, theta_ccw, theta_cw);
        if( current_cell.down == null || !current_cell.links().contains(current_cell.down))
          arc(origin.x, origin.y, 2*outer_radius, 2*outer_radius, theta_ccw, theta_cw);
        if( current_cell.left == null || !current_cell.links().contains(current_cell.left))
          line(ax, ay, bx, by);
        if( current_cell.right == null || !current_cell.links().contains(current_cell.right))
          line(cx, cy, dx, dy);
      }
    }
    
  }

}
