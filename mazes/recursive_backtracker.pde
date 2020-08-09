import java.util.Deque;
import java.util.ArrayDeque;

class RecursiveBacktracker {
  void on(Grid g){
    Cell start_at = g.randomCell();
    Deque<Cell> stack = new ArrayDeque<Cell>();
    stack.push(start_at);
    
    while(!stack.isEmpty()){
      Cell current = stack.getFirst();
      ArrayList<Cell> unvisitedNeighbors = new ArrayList<Cell>();
      
      for( Cell c: current.neighbors() )
      {
          if( c.links().isEmpty() )
          {
            unvisitedNeighbors.add(c);
          }
      }
      
      if(unvisitedNeighbors.isEmpty())
      {
        stack.pop();
      }
      else
      {
        Cell neighbor = unvisitedNeighbors.get((int)random(unvisitedNeighbors.size()));
        current.link(neighbor, true);
        stack.push(neighbor);
      }
    }
    
  }
}
