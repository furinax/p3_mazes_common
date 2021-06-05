import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Set; 
import java.util.Iterator; 
import java.io.*; 
import java.awt.Image; 
import java.util.Arrays; 
import java.util.Collections; 
import java.util.Deque; 
import java.util.ArrayDeque; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class mazes extends PApplet {






MaskedGrid g;
Distances d;
Colorizer c;
Mask mask;

public void setup(){
  
  int mazeHeight = 20;
  int mazeWidth = 20;
  try {
    mask = initializeMaskFromImage("C:\\Users\\Lightspeed\\Documents\\Processing3\\p3_mazes_common\\mazes\\mask.png", mazeHeight, mazeWidth);
    
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

public Mask initializeMaskFromImage(String filename, int mazeHeight, int mazeWidth ) throws FileNotFoundException, IOException {
  Mask m = new Mask(mazeHeight, mazeWidth);
  File file = new File(filename);
  BufferedImage bimg = ImageIO.read(file);
  int iwidth          = bimg.getWidth();
  int iheight         = bimg.getHeight();
  
  for( int h = 0; h <= mazeHeight; h++){
    for( int w = 0; w <= mazeWidth; w++){
      m.set(h, w, img.getRGB( lerp(0, mazeHeight, h / mazeHeight), 
                              lerp(0, mazeWidth, w / mazeWidth) ) != 0);
    }
  }

  return m;
}


public Mask initializeMaskFromFile(String filename, int mazeHeight, int mazeWidth ) throws FileNotFoundException, IOException {
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

public void draw() {
  background(0);
  g.onDraw();
  c.onDraw();
}
class AlduousBroder {
  public void on(Grid g){
    Cell c = g.randomCell();
    int unvisited = g.size() - 1;
    
    while (unvisited > 0) {
      Cell[] neighbors = c.neighbors();
      Cell neighbor = neighbors[(int)random(neighbors.length)];
      if( neighbor.links().isEmpty() )
      {
        c.link(neighbor,true);
        unvisited -= 1;
      }
      c = neighbor;
    }
  }
}
class BinaryTree {
  public void on(Grid g){
    Cell[] gc = g.eachCell();
    for( Cell c : gc )
    {
      ArrayList<Cell> neighbors = new ArrayList<Cell>();
      if( c.down != null)
        neighbors.add(c.down);
      if( c.right != null)
        neighbors.add(c.right);
        
      if( neighbors.size() > 0 ) {
        int index = (int) random(neighbors.size());
        Cell newNeighbor = neighbors.get(index);
        c.link(newNeighbor, true);
      }
    }
  }
}


class Cell {
  PVector pos;
  Cell up, down, left, right;
  HashMap<Cell, Boolean> links;
  
  Cell(int x, int y){
    pos = new PVector(x, y);
    links = new HashMap<Cell, Boolean>();
  }
  
  public void link(Cell c, boolean bidi) {
    links.put(c,true);
    if( bidi )
      c.link(this, false);
  }
  
  public void unlink( Cell c, boolean bidi) {
    links.remove(c);
    if(bidi)
      c.unlink(this, false);
  }
  
  public Set<Cell> links(){
    return links.keySet();
  }
  
  public boolean isLinked(Cell c) {
    return links.containsKey(c);
  }
  
  public Cell[] neighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    if( this.up != null )
      neighbors.add(this.up);
    if( this.down != null )
      neighbors.add(this.down);
    if( this.left != null )
      neighbors.add(this.left);
    if( this.right != null )
      neighbors.add(this.right);
    
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
  
  public Distances distances() {
    Distances retVal = new Distances(this);
    ArrayList<Cell> frontier = new ArrayList<Cell>(Arrays.asList(this));
    while( !frontier.isEmpty() ) {
      ArrayList<Cell> newFrontier = new ArrayList<Cell>();
      for( Cell c : frontier ) {
        for( Cell link : c.links()) {
          if(retVal.cells.keySet().contains(link))
            continue;
          retVal.set(link, retVal.get(c) + 1);
          newFrontier.add(link);
        }
      }
      frontier = newFrontier;
    }
    
    return retVal;
  }
}
class Colorizer {
  Grid grid;
  Distances distances;
  
  Colorizer(Grid g, Distances d) {
    this.grid = g;
    this.distances = d;
    
  }
  
  public void onDraw() {
    noStroke();
    int MARGIN = 50;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    int STEP_H = (BOTTOM - TOP) / this.grid.cells.length;
    int STEP_W = (RIGHT - LEFT) / this.grid.cells[0].length;
    float maximum = (float) this.distances.maximum();
    
    for( int h = 0; h < this.grid.cells.length ; h++ ){
      for( int w = 0 ; w < this.grid.cells[0].length; w++ ){
        PVector origin = new PVector(LEFT + STEP_W * w, TOP + STEP_H * h);
        Cell current_cell = this.grid.cells[h][w];
        if( current_cell != null )
          fill(color(0, 0, 255, 255 * ((maximum - this.distances.get(current_cell) + 1) * .8f / maximum) ));
        else
          fill(color(0, 0, 0));
        rect(origin.x, origin.y, STEP_W, STEP_H);
      }
    }
  }
}


class Distances {
  Cell root;
  HashMap<Cell, Integer> cells;
  
  Distances(Cell root){
    this.root = root;
    this.cells = new HashMap<Cell, Integer>();
    cells.put(root, 0);
  }
  
  public int get(Cell c) {
    if( c == null )
      return 0;
    return this.cells.get(c);
  }
  
  public void set(Cell c, int distance) {
    this.cells.put(c, distance);
  }
  
  public Cell[] cells() {
    Cell[] retVal = new Cell[this.cells.keySet().size()];
    retVal = this.cells.keySet().toArray(retVal);
    return retVal;
  }
  
  public int maximum() {
    return Collections.max(this.cells.values());
  }
}
class Grid {
  Cell[][] cells;
  Grid(int h, int w){
    cells = new Cell[h][w];
    prepare();
    configure();
  }
  
  public Cell get(int h, int w){
    if( h < 0 || h > cells.length - 1)
      return null;
    if( w < 0 || w > cells[0].length - 1)
      return null;
    if( cells[h][w] == null )
      return null;
    return cells[h][w];
  }
  
  public Cell randomCell() {
    return cells[(int)random(cells.length)][(int)random(cells[0].length)];
  }
  
  public Cell[] eachCell() {
    Cell[] retVal = new Cell[cells.length*cells[0].length];
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        retVal[h*cells[0].length + w] = cells[h][w];
      }
    }
    return retVal;
  }
  
  
  public int size() {
     return cells.length * cells[0].length;
  }
  
  public void prepare(){
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        cells[h][w] = new Cell(h, w);
      }
    }
  }
  
  public void configure() {
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        if( cells[h][w] == null )
          continue;
        cells[h][w].up = this.get(h-1,w);
        cells[h][w].down = this.get(h+1,w);
        cells[h][w].left = this.get(h,w-1);
        cells[h][w].right = this.get(h,w+1);
      }
    }
  }

  
  public void onDraw(){
    stroke(255);
    strokeWeight(2);
    fill(255);
    int MARGIN = 50;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    int STEP_H = (BOTTOM - TOP) / cells.length;
    int STEP_W = (RIGHT - LEFT) / cells[0].length;
    for( int h = 0; h < cells.length ; h++ ){
      for( int w = 0 ; w < cells[0].length; w++ ){
        PVector origin = new PVector(LEFT + STEP_W * w, TOP + STEP_H * h);
        Cell current_cell = cells[h][w];
        if( current_cell == null )
          continue;
        if( current_cell.up == null || !current_cell.links().contains(current_cell.up))
          line(origin.x, origin.y, origin.x+STEP_W, origin.y);
        if( current_cell.down == null || !current_cell.links().contains(current_cell.down))
          line(origin.x, origin.y+STEP_H, origin.x+STEP_W, origin.y+STEP_H);
        if( current_cell.left == null || !current_cell.links().contains(current_cell.left))
          line(origin.x, origin.y, origin.x, origin.y+STEP_H);
        if( current_cell.right == null || !current_cell.links().contains(current_cell.right))
          line(origin.x+STEP_W, origin.y, origin.x+STEP_W, origin.y+STEP_H);
      }
    }
    
  }
  
  public Cell[] deadEnds(){
    ArrayList<Cell> deadends = new ArrayList<Cell>();
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        if( cells[h][w] == null)
          continue;
        if( cells[h][w].links().size() == 1 )  
          deadends.add(cells[h][w]);
      }
    }
    Cell[] retVal = new Cell[deadends.size()];
    retVal = deadends.toArray(retVal);
    return retVal;
  }
}
class HuntAndKill {
  public void on(Grid g){
    Cell current = g.randomCell();

    while( current != null )
    {
      ArrayList<Cell> unvisitedNeighbors = new ArrayList<Cell>();
      
      for( Cell c: current.neighbors() )
      {
          if( c.links().isEmpty() )
          {
            unvisitedNeighbors.add(c);
          }
      }
      
      if(unvisitedNeighbors.size() > 0)
      {
         Cell neighbor = unvisitedNeighbors.get((int)random(unvisitedNeighbors.size()));
         current.link(neighbor, true);
         current = neighbor;
      }
      else
      {
        current = null;
        
        for( Cell c : g.eachCell())
        {
          ArrayList<Cell> visitedNeighbors = new ArrayList<Cell>();
          for( Cell n: c.neighbors() )
          {
              if( !n.links().isEmpty() )
              {
                visitedNeighbors.add(n);
              }
          }
          
          if(c.links().isEmpty() && !visitedNeighbors.isEmpty())
          {
            current = c;
            Cell neighbor = visitedNeighbors.get((int)random(visitedNeighbors.size()));
            current.link(neighbor, true);
            break;
          }
        } 
      }
    }
    
  }
}
class Mask {
 int rows, cols;
 Boolean [][] bits;
  
  Mask(int _rows, int _cols){
    rows = _rows;
    cols = _cols;
    bits = new Boolean[rows][cols];
    for( int r = 0; r < rows; r++ )
      for( int c = 0 ; c < cols; c++ )
        bits[r][c] = true;
  }
  
  
  public Boolean get(int r, int c){
    if( r < rows && c < cols )
      return bits[r][c];
    else
      return false;
  }
  
  public void set(int r, int c, Boolean v){
    if( r < rows && c < cols )
      bits[r][c] = v;
  }
  
  public int count(){
    int count = 0;
    for( int r = 0; r < rows; r++ )
      for( int c = 0 ; c < cols; c++ )
        if( bits[r][c] )
          count += 1;
          
    return count;
  }
  
  public PVector randomLocation()
  {
    do {
      int r = PApplet.parseInt(random(rows));
      int c = PApplet.parseInt(random(cols));
      if( bits[r][c] )
        return new PVector(r, c);
    } while(true);
  }
}
class MaskedGrid extends Grid {
  private final Mask _mask;
  
  MaskedGrid(Mask mask) {
    super(mask.rows, mask.cols);
    this._mask = mask;
    prepareMask();
    configure(); //reconfigure, how do we avoid this?
  }
  
  public void prepareMask() {
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        if( !this._mask.get(h, w) )
          this.cells[h][w] = null;
      }
    }
  }
  
  public Cell randomCell() {
    PVector p = this._mask.randomLocation();
    return this.cells[PApplet.parseInt(p.y)][PApplet.parseInt(p.x)];
  }
  
  public int size() {
     return this._mask.count(); 
  }
  
}



class RecursiveBacktracker {
  public void on(Grid g){
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
class SideWinder {
  public void on(Grid g){
    for( Cell[] row : g.cells )
    {
      ArrayList<Cell> run = new ArrayList<Cell>();
       for( Cell cell : row )
       {
         run.add(cell);
         
          boolean isRight = cell.right == null, isUp = cell.up == null;
          
          boolean isCloseRow = isRight || (!isUp && ((int) random(2) == 0));
          
          if( isCloseRow )
          {
            Cell member = run.get((int) random(run.size()));
            if( member.up != null )
              member.link(member.up, true);
            run.clear();
          }
          else
          {
            cell.link(cell.right, true);
          }
          
       }
    }
  }
}
class Wilsons {
  public void on(Grid g){
    ArrayList<Cell> unvisited = new ArrayList<Cell>();
    for( Cell c: g.eachCell())
    {
      unvisited.add(c);
    }
    
    int first_index = (int)random(unvisited.size());
    unvisited.remove(first_index);
    
    while( !unvisited.isEmpty() )
    {
      Cell cell = unvisited.get((int)random(unvisited.size()));
      ArrayList<Cell> path = new ArrayList<Cell>();
      path.add(cell);
      while(unvisited.indexOf(cell) >= 0 )
      {
         cell = cell.neighbors()[(int)random(cell.neighbors().length)];
         int position = path.indexOf(cell);
         if( position >= 0 )
         {
           path = new ArrayList<Cell>(path.subList(0, position+1));
         }
         else
         {
           path.add(cell);
         }
      }
      for( int x = 0 ; x < path.size() - 1; x++ )
      {
        ((Cell)path.get(x)).link(path.get(x+1), true);
        unvisited.remove(path.get(x));
      }
    }
  }
}
  public void settings() {  size(800,600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "mazes" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
