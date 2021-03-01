class MaskedGrid extends Grid {
  private final Mask _mask;
  
  MaskedGrid(Mask mask) {
    super(mask.rows, mask.cols);
    this._mask = mask;
    prepareMask();
  }
  
  void prepareMask() {
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        if( !this._mask.get(h, w) )
          this.cells[h][w].active = false;
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
  
}
