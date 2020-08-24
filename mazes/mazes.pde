import java.util.Set;
import java.util.Iterator;


Grid g;

void setup(){
  size(800,600);
  int mazeHeight = 20;
  int mazeWidth = 20;
  g = new Grid(mazeWidth, mazeHeight);
  (new BinaryTree()).on(g);
  
  
  // metrics
  print("Deadends : ", g.deadEnds().length , "/", mazeHeight * mazeWidth, " (", (int)(100*g.deadEnds().length / (mazeHeight * mazeWidth)), "%)");
}

void draw() {
  background(0);
  g.onDraw();
}
