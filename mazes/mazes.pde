import java.util.Set;
import java.util.Iterator;


Grid g;
Distances d;
Colorizer c;

void setup(){
  size(800,600);
  int mazeHeight = 20;
  int mazeWidth = 20;
  g = new Grid(mazeWidth, mazeHeight);
  (new RecursiveBacktracker()).on(g);
  d = g.cells[0][0].distances();
  c = new Colorizer(g, d);
  
  // metrics
  print("Deadends : ", g.deadEnds().length , "/", mazeHeight * mazeWidth, " (", (int)(100*g.deadEnds().length / (mazeHeight * mazeWidth)), "%)");
}

void draw() {
  background(0);
  g.onDraw();
  c.onDraw();
}
