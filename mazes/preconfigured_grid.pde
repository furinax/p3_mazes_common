class PreconfiguredGrid extends WeaveGrid {
  // for kruskals
  PreconfiguredGrid(int rows, int columns) {
    super(rows, columns);
  }
  
  void prepare() {
    
    _cells.clear();
    for( int h = 0; h < this._height ; h++ )
    {
      _cells.add(new ArrayList<Cell>(this._width));
      for( int w = 0 ; w < this._width; w++ ){
        _cells.get(h).add(new SimpleOverCell(h, w, this));
      }
    }
  }
  
  
}
