Player p;
RectCollTest r;

void setup()
{
  //fullScreen();
  size(800,800);
  
  initKeys();
  initCollisions();
  
  p = new Player();
  r = new RectCollTest(new PVector(100,100), new PVector(100,100), "box");
}

void draw()
{
  background(0);
  handleKeys();
  handleCollisions();
  
  p.show();
  r.show();
}
