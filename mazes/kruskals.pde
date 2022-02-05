import javafx.util.Pair;
import java.util.HashSet;
import java.util.LinkedList;

class Kruskals {
  
  State _state;
  
  void on(WeaveGrid g){
    _state = new State(g);
    LinkedList<Pair<Cell, Cell>> neighbors = new LinkedList<Pair<Cell, Cell>>();
    neighbors.addAll(_state._neighbors);
    Collections.shuffle(neighbors);
    
    while( !neighbors.isEmpty() ) {
      Pair<Cell, Cell> n = neighbors.pop();
      if( _state.canMerge(n.getKey(), n.getValue()))
        _state.merge(n.getKey(), n.getValue());
    }
  }
}
