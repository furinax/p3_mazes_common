class RainbowPalette extends Palette{
  
  RainbowPalette(int mazeHeight, int mazeWidth, color c1, color c2, color c3) {
    super(mazeHeight, mazeWidth, c1, c2, c3);
  }
  
  void colorizeRow(PVector pos) {
    color c = randomizeColor(int(pos.x));
    stroke(c);
  }
  
  void colorizeCol(PVector pos) {
    color c = randomizeColor(int(pos.y));
    stroke(c);
  }
  
  void colorizeRowCol(PVector pos) {
    color c = randomizeColor(int(pos.x + pos.y));
    color cc = randomizeColor(int(pos.x * pos.y));
    //c = lerpColor(cc, c, .5);//.2 * sin(pos.x / 10) + .7);
    stroke(c);
  }
  
  color randomizeColor(int val) {
    if( val % 3 == 0 )
      return _c1;
    else if( val % 3 == 1 )
      return _c2;
    else
      return _c3;
  }
}
