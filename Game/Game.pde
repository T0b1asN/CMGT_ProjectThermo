/*
// -------------------
 //         TODO
 // -------------------
 
 1 Gameplay
 done 1.1 enemy AI
 done 1.1.1 AI aims at whats nearer (bomb or player)
 done 1.2 enemy spawning
 done 1.2.1 spawn enemy at random point around edge
 2 Graphics
 2.1 player graphics
 2.2 enemy graphics
 2.3 bomb graphics
 2.4 UI graphics (maybe not necessary)
 3 Gameplay
 3.1 Balancing
 3.1.1 figure out enemy stats
 3.1.2 figure out player stats
 3.1.3 figure out bomb stats
 ...
 5000 highscore system
 ...
 10000 make render handler
 
 // -------------------
 //     END OF TODO
 // -------------------
 */

boolean debug = false;

MainMenu menu;
MainGame game;
DeathMenu deathMenu;

enum GameState
{
  MAINMENU, PLAY, DIE
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

void reset()
{
  //initialize the mouse, the keyboard and collisions
  initMouse();
  initKeys();
  initCollisions();

  menu.reset();
  deathMenu = null;
  game = null;
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
  case DIE:
    dieState();
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
  if (!game.run())
  {
    state = GameState.DIE;
    deathMenu = new DeathMenu();
  }
}

void dieState()
{
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

  Bomb b;

  int score = 0;

  //bomb animation
  int bomb_frameCount = 90;
  float bomb_maxRadius;
  float bomb_radius;
  float bomb_speed;
  boolean bomb_isPlaying = false;

  public MainGame()
  {
    //create the player
    p = new Player();
    //seems redundant but is REALLY important
    game = this;

    b = new Bomb();

    //create the game ui
    //CRUCIAL: do this after creating the player
    ui = new GameUI();

    //initialize the enemy handler
    //CRUCIAL: do this after creating the player
    initEnemyHandler();

    score = 0;

    bomb_maxRadius = (new PVector(width, height)).mag();
    bomb_radius = b.size.x > b.size.y ? b.size.x : b.size.y;
    bomb_speed = bomb_maxRadius / (float)bomb_frameCount;
    bomb_isPlaying = false;
  }

  public Player getP() { 
    if (p == null) return p = new Player(); 
    else return p;
  }
  
  public Bomb getB()
  {
    return b;
  }

  public void increaseScore(int amount) { 
    score += amount;
  }

  public int getScore() { 
    return score;
  }

  public boolean run()
  {
    if (!bomb_isPlaying)
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
      b.show();
      p.show();
      b.showHealth();
      //if in debug mode, draw all colliders
      debugCollisions();

      //show the ui
      ui.show();
      if (p.isDead()) {
        cleanup();
        return false;
      } else if (b.isDead()) {
        cleanup();
        bomb_isPlaying = true;
      }
      return true;
    } else {
      if (bomb_radius <= bomb_maxRadius * 1.05f) {
        pushStyle();
        noStroke();
        fill(255);
        circle(width/2f, height/2f, bomb_radius);
        popStyle();
        bomb_radius += bomb_speed;
        return true;
      } else {
        return false;
      }
    }
  }

  void cleanup()
  {
    cleanupEnemies();
    p.onDestroy();
  }
}
