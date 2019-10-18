Player p;
GameUI ui;
//Enemy e1, e2;

boolean debug = false;

void setup()
{
  //fullScreen();
  size(800, 800);
  
  //if desired enter debug mode
  if(debug) debugMode();

  //initialize the mouse, the keyboard and collisions
  initMouse();
  initKeys();
  initCollisions();
  
  //create the player
  p = new Player();
  
  //initialize the enemy handler
  //CRUCIAL: do this after creating the player
  initEnemyHandler();
  
  //create the game ui
  //CRUCIAL: do this after creating the player
  ui = new GameUI();
}

void draw()
{
  background(0);
  //handle mouse input
  handleMouse();
  //handle keyboard input
  handleKeys();
  //handle collisions
  handleCollisions();
  //handle enemies (showing, moving, spawning)
  handleEnemies();

  //show the player
  p.show();

  //if in debug mode, draw all colliders
  debugCollisions();

  //show the ui
  ui.show();
}

void debugMode()
{
  debug_showHitboxes = true;
}
