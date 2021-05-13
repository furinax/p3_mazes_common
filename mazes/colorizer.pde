class Colorizer {
  Grid grid;
  Distances distances;
  
  Colorizer(Grid g, Distances d) {
    this.grid = g;
    this.distances = d;
    
  }
  
  void onDraw() {
    noStroke();
    int MARGIN = 50;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    int STEP_H = (BOTTOM - TOP) / this.grid._height;
    int STEP_W = (RIGHT - LEFT) / this.grid._width;
    float maximum = (float) this.distances.maximum();
    
    for( int h = 0; h < this.grid._height ; h++ ){
      for( int w = 0 ; w < this.grid._width; w++ ){
        PVector origin = new PVector(LEFT + STEP_W * w, TOP + STEP_H * h);
        Cell current_cell = this.grid.get(h,w);
        if( current_cell != null )
          fill(color(0, 0, 255, 255 * ((maximum - this.distances.get(current_cell) + 1) * .8 / maximum) ));
        else
          fill(color(0, 0, 0));
        rect(origin.x, origin.y, STEP_W, STEP_H);
      }
    }
  }
}
