class State {
  
    class PairContains<E> implements Predicate<Pair<Cell, Cell>> {
      Cell _c;
      PairContains(Cell c) {
        _c = c;
      }
      @Override
      public boolean test(Pair<Cell, Cell> v) {
          return v.getKey() == _c || v.getValue() == _c;
      }
  }
  
    WeaveGrid _grid;
    ArrayList< Pair<Cell, Cell> > _neighbors;
    HashMap<Cell, Integer> _setForCell;
    HashMap<Integer, ArrayList<Cell> > _cellsInSet;
    
    State(WeaveGrid g) {
      _grid = g;
      _neighbors = new ArrayList< Pair<Cell, Cell> >();
      _setForCell = new HashMap<Cell, Integer>();
      _cellsInSet = new HashMap<Integer, ArrayList<Cell> >();
      
      for( Cell c: _grid.eachCell()) {
        int set = _setForCell.size();
        _setForCell.put(c, set);
        _cellsInSet.put(set, new ArrayList<Cell>(Arrays.asList(c)));
        if( c.down != null )
          _neighbors.add( new Pair<Cell, Cell>(c, c.down));
        if( c.right != null )
          _neighbors.add(new Pair<Cell, Cell>(c, c.right));
      }
    }
    
    boolean canMerge(Cell left, Cell right) {
      return (_setForCell.get(left).intValue() != _setForCell.get(right).intValue());
    }
    
    void merge(Cell left, Cell right) {
      left.link(right, true);
      //print(" merge " + left + " " + right + " ");
      if( left instanceof UnderCell || right instanceof UnderCell)
        return;
      
      int winner = _setForCell.get(left);
      int loser = _setForCell.get(right);
      ArrayList<Cell> losers = new ArrayList<Cell>();

      if( !_cellsInSet.get(loser).isEmpty() )
        losers.addAll(_cellsInSet.get(loser));
      else
        losers.add(right);

      ArrayList<Cell> toAdd = new ArrayList<Cell>();
      for( Cell c : losers )
      {
        toAdd.add(c);
        _setForCell.put(c, winner);
      }

      _cellsInSet.get(winner).addAll(toAdd);

      _cellsInSet.remove(loser);
      print("\n");
    }
    
    boolean addCrossing(Cell c) {
      if (!(c.links().isEmpty() && canMerge(c.left, c.right) && canMerge(c.up, c.down))) {
        return false;
      }
      
      PairContains pairContains = new PairContains(c);
      _neighbors.removeIf(pairContains);
      
      if( int(random(2)) == 0) {
        merge( c.left, c);
        merge( c, c.right);
        ((WeaveGrid)_grid).tunnelUnder((OverCell)c);
        merge(c.up, c.up.down);
        merge(c.down, c.down.up);
      } else {
        merge(c.up, c);
        merge(c, c.down);
        ((WeaveGrid)_grid).tunnelUnder((OverCell)c);
        merge(c.left, c.left.right);
        merge(c.right, c.right.left);
      }
      
      return true;
    }
    
  }
  
