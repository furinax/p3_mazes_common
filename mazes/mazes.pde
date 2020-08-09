import java.util.Set;
import java.util.Iterator;


Grid g;

void setup(){
  size(800,600);
  int mazeHeight = 60;
  int mazeWidth = 80;
  g = new Grid(mazeWidth, mazeHeight);
  (new HuntAndKill()).on(g);
  
  
  // metrics
  print("Hunt and Kill deadends : ", g.deadEnds().length , "/", mazeHeight * mazeWidth, " (", (int)(100*g.deadEnds().length / (mazeHeight * mazeWidth)), "%)");
}

void draw() {
  background(0);
  g.onDraw();
}
