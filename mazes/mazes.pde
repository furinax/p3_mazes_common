import java.util.Set;
import java.util.Iterator;
import java.io.*;

MaskedGrid g;
Distances d;
Colorizer c;
Mask mask;

void setup(){
  size(800,600);
  int mazeHeight = 20;
  int mazeWidth = 20;
  try {
    mask = initializeMaskFromFile("C:\\Users\\Lightspeed\\Documents\\Processing3\\p3_mazes_common\\mazes\\mask.txt", mazeHeight, mazeWidth);
    
    g = new MaskedGrid(mask);
    (new RecursiveBacktracker()).on(g);
    d = g.cells[0][0].distances();
    c = new Colorizer(g, d);
    
    // metrics
    print("Deadends : ", g.deadEnds().length , "/", mazeHeight * mazeWidth, " (", (int)(100*g.deadEnds().length / (mazeHeight * mazeWidth)), "%)");
  }
  catch(IOException e) {
    e.printStackTrace();
  }
}

Mask initializeMaskFromFile(String filename, int mazeHeight, int mazeWidth ) throws FileNotFoundException, IOException {
  Mask m = new Mask(mazeHeight, mazeWidth);
  File file = new File(filename);
  BufferedReader br = new BufferedReader(new FileReader(file));

  String st;
  int r = 0;
  while((st = br.readLine()) != null && r < mazeHeight) {
    for( int c = 0 ; c < mazeWidth; c++ ) {
      if( st.charAt(c) == 'x' ) {
        m.set(r, c, false);
      }
      else {
        m.set(r, c, true);
      }
    }
    r++;
  }

  return m;
}

void draw() {
  background(0);
  g.onDraw();
  c.onDraw();
}
