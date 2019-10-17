Player p;
GameUI ui;
Enemy e;

boolean fullscreen = true;

void setup()
{
  fullScreen();
  //size(800,800);
  
  initMouse();
  initKeys();
  initCollisions();
  
  ui = new GameUI();
  
  p = new Player();
  e = new Enemy(new PVector(100, 100), new PVector(50f, 50f));
}

void draw()
{
  background(0);
  handleMouse();
  handleKeys();
  handleCollisions();
  
  p.show();
  e.show();
  
  e.move();
  
  ui.show();
  
  debugCollisions();
}
