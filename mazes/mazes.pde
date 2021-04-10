import java.util.Set;
import java.util.Iterator;
import java.io.*;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

PolarGrid g;
//MaskedGrid g;
Distances d;
Colorizer c;
Mask mask;

void setup(){
  size(800,600);
  int mazeHeight = 20;
  int mazeWidth = 20;
  try {
    mask = initializeMaskFromImage("C:\\Users\\Lightspeed\\Documents\\Processing3\\p3_mazes_common\\mazes\\full.png", mazeHeight, mazeWidth);
    
    //g = new MaskedGrid(mask);
    //(new RecursiveBacktracker()).on(g);
    //d = g.cells[0][0].distances();
    //c = new Colorizer(g, d);
    g = new PolarGrid(mask);
    
    // metrics
    print("Deadends : ", g.deadEnds().length , "/", mazeHeight * mazeWidth, " (", (int)(100*g.deadEnds().length / (mazeHeight * mazeWidth)), "%)");
  }
  catch(IOException e) {
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
