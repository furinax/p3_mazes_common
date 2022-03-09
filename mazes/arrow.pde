class Arrow {
  color _c;
  PVector _pos;
  int _length = 30;
  
  Arrow(color c, PVector pos) {    
    _pos = pos;
    _c = c;
  }
  
  
  void draw() {
    stroke(_c);
    strokeWeight(8);
    line( _pos.x-_length, _pos.y-_length, _pos.x, _pos.y);
    line( _pos.x, _pos.y, _pos.x, _pos.y - _length/2);
    line( _pos.x, _pos.y, _pos.x - _length/2, _pos.y);
  }
}
