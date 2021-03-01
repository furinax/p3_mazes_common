class Mask {
 int rows, cols;
 Boolean [][] bits;
  
  Mask(int _rows, int _cols){
    rows = _rows;
    cols = _cols;
    bits = new Boolean[rows][cols];
    for( int r = 0; r < rows; r++ )
      for( int c = 0 ; c < cols; c++ )
        bits[r][c] = true;
  }
  
  
  Boolean get(int r, int c){
    if( r < rows && c < cols )
      return bits[r][c];
    else
      return false;
  }
  
  void set(int r, int c, Boolean v){
    if( r < rows && c < cols )
      bits[r][c] = v;
  }
  
  int count(){
    int count = 0;
    for( int r = 0; r < rows; r++ )
      for( int c = 0 ; c < cols; c++ )
        if( bits[r][c] )
          count += 1;
          
    return count;
  }
  
  PVector randomLocation()
  {
    do {
      int r = int(random(rows));
      int c = int(random(cols));
      if( bits[r][c] )
        return new PVector(r, c);
    } while(true);
  }
}
