import java.util.Set;
import java.util.Iterator;


MaskedGrid g;
Distances d;
Colorizer c;
Mask mask;

void setup(){
  size(800,600);
  int mazeHeight = 20;
  int mazeWidth = 20;
  mask = new Mask(mazeHeight, mazeWidth);
  mask.set(1, 1, false);
  mask.set(3, 3, false);
  mask.set(5, 5, false);
  
  
  g = new MaskedGrid(mask);
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
