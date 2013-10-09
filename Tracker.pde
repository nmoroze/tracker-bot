import processing.video.*;

class Tracker {
  Capture video;
  color highlight;

  int RED_LOWER;
  int RED_UPPER;
  int GREEN_LOWER;
  int GREEN_UPPER;
  int BLUE_LOWER;
  int BLUE_UPPER;

  ArrayList<int[]> coordinates = new ArrayList<int[]>();

  public Tracker(PApplet parent, int RED_LOWER, int RED_UPPER, 
  int GREEN_LOWER, int GREEN_UPPER, 
  int BLUE_LOWER, int BLUE_UPPER) {
    this.RED_LOWER = RED_LOWER;
    this.RED_UPPER = RED_UPPER;
    this.GREEN_LOWER = GREEN_LOWER;
    this.GREEN_UPPER = GREEN_UPPER;
    this.BLUE_LOWER = BLUE_LOWER;
    this.BLUE_UPPER = BLUE_UPPER;
    
    video = new Capture(parent, width, height);
    video.start(); 
    noCursor();
    smooth();
    highlight = color(255, 204, 0);
  }
  
  public void update(boolean display) {
    if (video.available()) {
      video.read();
      video.loadPixels();
      if(display)
        loadPixels();
      coordinates.clear();
      for (int i = 0; i < video.width * video.height - 1; i++) {
        if (green(video.pixels[i])>=GREEN_LOWER && green(video.pixels[i])<=GREEN_UPPER
          && blue(video.pixels[i])>=BLUE_LOWER && blue(video.pixels[i])<=BLUE_UPPER
          && red(video.pixels[i])>=RED_LOWER && red(video.pixels[i])<=RED_UPPER) {
          if(display) 
            pixels[i] = highlight;
          coordinates.add(pixelToCoord(i));
        }
        else if(display)
          pixels[i] = video.pixels[i];
      }
    }
    if(display)  
      updatePixels();
  }
  
  public void calibrate() {
    if(video.available()) {
      video.read();
      video.loadPixels();
              
        RED_UPPER=0;
        RED_LOWER=255;
        GREEN_UPPER=0;
        GREEN_LOWER=255;
        BLUE_UPPER=0;
        BLUE_LOWER=255;

      for (int i = 0; i < video.width * video.height - 1; i++) {
        int r = (int) red(video.pixels[i]);
        int b = (int) blue(video.pixels[i]);
        int g = (int) green(video.pixels[i]);
        
        if(r>RED_UPPER)
          RED_UPPER = r;
        if(r<RED_LOWER)
          RED_LOWER = r;
        if(b>BLUE_UPPER)
          BLUE_UPPER = b;
        if(b<BLUE_LOWER)
          BLUE_LOWER = b;
        if(g>GREEN_UPPER)
          GREEN_UPPER = g;
        if(g<GREEN_LOWER)
          GREEN_LOWER = g;
      }
      println("Calibrated");
      println(RED_UPPER);
      println(RED_LOWER);
      println(GREEN_UPPER);
      println(GREEN_LOWER);
      println(BLUE_UPPER);
      println(BLUE_LOWER);
    }  
    else 
      println("Failed");
  }
  
  public int depth() {
    return coordinates.size();
  }
  
  public int errorX() {
    return averagePoints()[0] - width/2;
  }
  
  public int errorY() {
    return averagePoints()[1] - height/2;
  }
  
  private int[] pixelToCoord(int pixel) {
    int[] coords = new int[2]; 
    coords[1] = (int) pixel/width;
    coords[0] = pixel - coords[1]*width;
    return coords;
  }

  public int[] averagePoints() {
    int[] coords = new int[2];
    int xSum=0;
    int ySum=0;
    for (int i=0; i<coordinates.size(); i++) {
      xSum+=coordinates.get(i)[0];
      ySum+=coordinates.get(i)[1];
    }
    if(coordinates.size()>0) {
      coords[0] = xSum/coordinates.size();
      coords[1] = ySum/coordinates.size();
    }
    else {
      coords[0] = -1;
      coords[1] = -1;
    }
    return coords;
  }
}
