import java.util.Set;
import java.util.Iterator;


Grid g;

void setup(){
  size(800,600);
  g = new Grid(80, 60);
  (new HuntAndKill()).on(g);
}

void draw() {
  background(0);
  g.onDraw();
}
