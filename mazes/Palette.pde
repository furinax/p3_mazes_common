class Palette {
  color _c1, _c2, _c3;
  int _height, _width;
  
  Palette(int mazeHeight, int mazeWidth, color c1, color c2, color c3) {    
    _c1 = c1;
    _c2 = c2;
    _c3 = c3;
    _height = mazeHeight;
    _width = mazeWidth;
  }
  
  void colorizeRow(PVector pos) {
    color inter = lerpColor(_c1, _c2, (float)pos.x/_width);
    stroke(inter);
  }
  
  void colorizeCol(PVector pos) {
    color inter = lerpColor(_c1, _c3, (float)pos.y/_height);
    stroke(inter);
  }
  
  void colorizeRowCol(PVector pos) {
    color inter = lerpColor(_c1, _c3, ((float)pos.y + (float)pos.x)/(_width + _height) );
    stroke(inter);
  }
}
