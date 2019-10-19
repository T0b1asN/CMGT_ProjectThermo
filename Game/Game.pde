/*
// -------------------
//         TODO
// -------------------

1 make main game loop a class, that takes care of all of the enemies and the player, etc.
2 make render handler
3 finish state system

// -------------------
//     END OF TODO
// -------------------
*/

Player p;
GameUI ui;
//Enemy e1, e2;

boolean debug = false;

MainMenu menu;

enum GameState
{
  MAINMENU, PLAY, PAUSE, DIE, WIN
}

GameState state;

void setup()
{
  //fullScreen();
  size(800, 800);

  //if desired enter debug mode
  if (debug) debugMode();

  //initialize the mouse, the keyboard and collisions
  initMouse();
  initKeys();
  initCollisions();
  
  menu = new MainMenu();

  //create the player
  p = new Player();

  //initialize the enemy handler
  //CRUCIAL: do this after creating the player
  initEnemyHandler();

  //create the game ui
  //CRUCIAL: do this after creating the player
  ui = new GameUI();

  state = GameState.MAINMENU;
}

void draw()
{
  switch(state)
  {
    case MAINMENU:
      mainMenu();
      break;
    case PLAY:
      mainGame();
      break;
    case PAUSE:
      break;
    case DIE:
      break;
    case WIN:
      break;
    default:
      break;
  }
}

void mainMenu()
{
  if(!menu.run())
    state = GameState.PLAY;
}

void mainGame()
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
