Player p;
RectCollTest r;
PolygonCollTest t;
GameUI ui;

void setup()
{
  //fullScreen();
  size(800,800);
  
  initKeys();
  initCollisions();
  
  ui = new GameUI();
  
  p = new Player();
  r = new RectCollTest(new PVector(100,100), new PVector(100,100), "box");
  t = new PolygonCollTest(new PVector(0, 0), "polygon");
}

void draw()
{
  background(0);
  handleKeys();
  handleCollisions();
  
  p.show();
  r.show();
  t.show();
  
  ui.show();
}
