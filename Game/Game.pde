Player p;
GameUI ui;
Enemy e1, e2;

boolean fullscreen = true;

void setup()
{
  //fullScreen();
  size(800, 800, P2D);

  initMouse();
  initKeys();
  initCollisions();

  ui = new GameUI();

  p = new Player();
  e1 = new Enemy(new PVector(random(50f, width-50f), random(50f, height-50f)), 
    new PVector(50f, 50f));
  e2 = new Enemy(new PVector(random(50f, width-50f), random(50f, height-50f)), 
    new PVector(50f, 50f));
}

void draw()
{
  background(0);
  handleMouse();
  handleKeys();
  handleCollisions();

  p.show();
  e1.show();
  e2.show();

  e1.move();
  e2.move();

  ui.show();

  debugCollisions();
}
