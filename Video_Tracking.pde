Tracker t;

void setup() {
  size(640, 480);
//  t = new Tracker(this, 100, 255, 200, 255, 100, 255); //green post-it note
  t = new Tracker(this, 0, 150, 100, 255, 100, 150);
}

void draw() {
  t.update(true);
  int[] center = t.averagePoints();
  if(t.depth() > 50)
    ellipse(center[0], center[1], t.depth()/500, t.depth()/500);
}


