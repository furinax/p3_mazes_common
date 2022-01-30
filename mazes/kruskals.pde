import javafx.util.Pair;
import java.util.HashSet;
import java.util.LinkedList;

class Kruskals {
  
  class State {
    Grid _grid;
    ArrayList< Pair<Cell, Cell> > _neighbors;
    HashMap<Cell, Integer> _setForCell;
    HashMap<Integer, ArrayList<Cell> > _cellsInSet;
    
    State(Grid g) {
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
      return _setForCell.get(left) != _setForCell.get(right);
    }
    
    void merge(Cell left, Cell right) {
      print( "merge " + left + " " + right + "\n");
      left.link(right, true);
      
      int winner = _setForCell.get(left);
      int loser = _setForCell.get(right);
      ArrayList<Cell> losers = new ArrayList<Cell>();
      print( "cells in set loser" + _cellsInSet.get(loser));
      losers.addAll(_cellsInSet.get(loser));
      losers.add(right);
      
      ArrayList<Cell> toAdd = new ArrayList<Cell>();
      for( Cell c : losers )
      {
        //_cellsInSet.get(winner).add(c);
        toAdd.add(c);
        _setForCell.put(c, winner);
      }
      
      print( "cells in set winner " + _cellsInSet.get(winner));
      _cellsInSet.get(winner).addAll(toAdd);
      
      _cellsInSet.remove(loser);
    }
    
  }
  
  State _state;
  
  void on(Grid g){
    _state = new State(g);
    LinkedList<Pair<Cell, Cell>> neighbors = new LinkedList<Pair<Cell, Cell>>();
    neighbors.addAll(_state._neighbors);
    Collections.shuffle(neighbors);
    
    while( !neighbors.isEmpty() ) {
      Pair<Cell, Cell> n = neighbors.pop();
      if( _state.canMerge(n.getKey(), n.getValue()));
        _state.merge(n.getKey(), n.getValue());
    }
  }
}
