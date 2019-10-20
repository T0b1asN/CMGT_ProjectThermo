/*
// -------------------
 //         TODO
 // -------------------
 
 1 make main game loop a class, that takes care of all of the enemies and the player, etc.
 1.1 make that elements of game (player, enemies, etc.) only get initialized after the main menu
 and that they get destroyed when the game ends
 2 make render handler
 3 finish state system
 
 // -------------------
 //     END OF TODO
 // -------------------
 */


//Enemy e1, e2;

boolean debug = false;

MainMenu menu;
MainGame game;
DeathMenu deathMenu;

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
    dieState();
    break;
  case WIN:
    break;
  default:
    break;
  }
}

void mainMenu()
{
  if (!menu.run())
  {
    state = GameState.PLAY;
    menu.setEnabled(false);
    game = new MainGame();
  }
}

void mainGame()
{
  if(!game.run())
  {
    state = GameState.DIE;
    deathMenu = new DeathMenu();
  }
}

void dieState()
{
  background(0);
  deathMenu.show();
}

void debugMode()
{
  debug_showHitboxes = true;
}

public class MainGame
{
  Player p;
  GameUI ui;
  public MainGame()
  {
    //create the player
    p = new Player();
    //seems redundant but is REALLY important
    game = this;

    //create the game ui
    //CRUCIAL: do this after creating the player
    ui = new GameUI();

    //initialize the enemy handler
    //CRUCIAL: do this after creating the player
    initEnemyHandler();
  }
  
  public Player getP() { if(p == null) return p = new Player(); else return p; }

  public boolean run()
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
    if(p.isDead())
    {
      cleanup();
      return false;
    }
    else return true;
  }
  
  void cleanup()
  {
    cleanupEnemies();
    p.onDestroy();
  }
}
