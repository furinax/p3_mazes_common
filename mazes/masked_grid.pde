class MaskedGrid extends Grid {
  private final Mask _mask;
  
  MaskedGrid(Mask mask) {
    super(mask.rows, mask.cols);
    this._mask = mask;
    prepareMask();
    configure(); //reconfigure, how do we avoid this?
  }
  
  void prepareMask() {
    for( int h = 0; h < this._height ; h++ )
    {
      for( int w = 0 ; w < this._width; w++ ){
        if( !this._mask.get(h, w) )
          this._cells.get(h).set(w, null);
      }
    }
  }
  
  Cell randomCell() {
    PVector p = this._mask.randomLocation();
    return this._cells.get(int(p.x)).get(int(p.y));
  }
  
  int size() {
     return this._mask.count(); 
  }
  
}
