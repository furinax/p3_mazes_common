class Colorizer {
  Grid grid;
  
  Colorizer(Grid g) {
    this.grid = g;
  }
  
  void onDraw() {
    noStroke();
    fill(230);
    int MARGIN = 50;
    int line_weight = 5;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    int STEP_H = (BOTTOM - TOP) / this.grid._height;
    int STEP_W = (RIGHT - LEFT) / this.grid._width;
    
    for( int h = 0; h < this.grid._height ; h++ ){
      for( int w = 0 ; w < this.grid._width; w++ ){
        PVector origin = new PVector(LEFT + STEP_W * w, TOP + STEP_H * h);
        Cell current_cell = this.grid.get(h,w);
        rect(origin.x+line_weight/2, origin.y+line_weight/2, STEP_W-line_weight, STEP_H-line_weight);
      }
    }
  }
}
