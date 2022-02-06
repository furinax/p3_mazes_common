import java.util.Set;
import java.util.Iterator;
import java.io.*;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

Grid g;
Distances d;
Colorizer c;
Mask mask;

Grid obtainMaskedGrid() throws FileNotFoundException, IOException{
  int mazeHeight = 20;
  int mazeWidth = 20;
  mask = initializeMaskFromImage("C:\\Users\\Lightspeed\\Documents\\Processing3\\p3_mazes_common\\mazes\\full.png", mazeHeight, mazeWidth);
  Grid grid = new MaskedGrid(mask);
  (new RecursiveBacktracker()).on(grid);
  //grid.braid(-1f);
  return grid;
}

Grid obtainWeaveGrid(){
  int mazeHeight = 20;
  int mazeWidth = 20;
  Grid grid = new WeaveGrid(mazeHeight, mazeWidth);
  (new RecursiveBacktracker()).on(grid);
  return grid;
}

Grid obtainKruskalsGrid() {
  int mazeHeight = 20;
  int mazeWidth = 20;
  WeaveGrid grid = new PreconfiguredGrid(mazeHeight, mazeWidth);
  State state = new State(grid);
  for( int i = 0 ; i < mazeHeight ; i++ ) {
    int row = 1 + int(random(mazeHeight - 2));
    int col = 1 + int(random(mazeWidth - 2));
    
    state.addCrossing(grid.get(row, col));
  }
  (new Kruskals()).on(grid);
  return grid;
}

Grid obtainPolarGrid() {
  int mazeRadius = 29;
  Grid grid = new PolarGrid(mazeRadius);
  (new RecursiveBacktracker()).on(grid);
  grid.braid(0.f);
  return grid;
}

Grid obtainHexGrid() {
  int mazeHeight = 16;
  int mazeWidth = 25;
  Grid grid = new HexGrid(mazeHeight, mazeWidth);
  (new RecursiveBacktracker()).on(grid);
  grid.braid(0.25f);
  return grid;
}

Grid obtainTriangleGrid() {
  int mazeHeight = 30;
  int mazeWidth = 50;
  Grid grid = new TriangleGrid(mazeHeight, mazeWidth);
  (new RecursiveBacktracker()).on(grid);
  return grid;
}

void setup(){
  size(800,600);

  try {
    g = obtainKruskalsGrid();
    //d = g.cells[0][0].distances();

    // metrics
    //print("Deadends : ", g.deadEnds().length , "/", mazeHeight * mazeWidth, " (", (int)(100*g.deadEnds().length / (mazeHeight * mazeWidth)), "%)");
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

Mask initializeMaskFromImage(String filename, int mazeHeight, int mazeWidth ) throws FileNotFoundException, IOException {
  Mask m = new Mask(mazeHeight, mazeWidth);
  File file = new File(filename);
  BufferedImage img = ImageIO.read(file);
  int iwidth          = img.getWidth();
  int iheight         = img.getHeight();
  
  for( int h = 0; h <= mazeHeight; h++){
    for( int w = 0; w <= mazeWidth; w++){
      m.set(h, w, img.getRGB((int)map( h, 0, mazeHeight, 0, iheight - 1), (int) map(w, 0, mazeWidth, 0, iwidth - 1) ) == -1);
    }
  }

  return m;
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
  //c.onDraw();
}
