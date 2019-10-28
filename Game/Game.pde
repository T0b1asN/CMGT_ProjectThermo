/*
// -------------------
 //         TODO
 // -------------------
 
 1 Graphics
 1.1 player graphics
 done 1.2 enemy graphics
 1.3 bomb graphics
 1.4 UI graphics (maybe not necessary)
 2 Gameplay
 2.1 Balancing
 2.1.1 figure out enemy stats
 2.1.2 figure out player stats
 2.1.3 figure out bomb statsd
 ...
 5000 highscore system
 ...
 10000 make render handler
 
 // -------------------
 //     END OF TODO
 // -------------------
 */

//is the game in debug mode
boolean debug = false;

//the instance of the MainMenu class handling the main menu
MainMenu menu;
//the instance of the MainGame class handling the main game
MainGame game;
//the instance of the DeathMenu class handling the death menu/game over screen
DeathMenu deathMenu;

HighscoreHandler hsHandler;

//The enum to describe the state the game is in currently
//  MAINMENU: the game is in main menu and is going to be started
//  PLAY    : the game is playing right now and the player is fighting enemy tanks
//  DIE     : the player died and the death menu is being shown
enum GameState
{
  MAINMENU, PLAY, DIE
}
//the instance of the GameState enum, keeping track of the current game state
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
  
  hsHandler = new HighscoreHandler();
  hsHandler.readHighscores();

  //create a new main menu
  menu = new MainMenu();
  
  //set the initial game state, which is the main menu
  state = GameState.MAINMENU;
}

//function that can be called, to reset the game
void reset()
{
  //reinitialize the mouse, the keyboard and collisions
  initMouse();
  initKeys();
  initCollisions();

  //reset the main menu
  menu.reset();
  //destroy the instances of the death menu and the main game
  // due to them being initialized when they are needed
  deathMenu = null;
  game = null;
  //reset the game state to the main menu
  state = GameState.MAINMENU;
}

//draw function
void draw()
{
  //check in which game state the game is currently
  switch(state)
  {
  case MAINMENU:
    //if the game is in the main menu, call the function handling it
    mainMenu();
    break;
  case PLAY:
    //if the game is in gameplay, call the function handling that
    mainGame();
    break;
  case DIE:
    //if the player is dead, call the function handling that
    dieState();
    break;
  default:
    //handle illegal state
    println("ERROR: illegal state!");
    break;
  }
}

//function that handles the main menu game state
void mainMenu()
{
  //menu.run returns true, while it should be open and returns false when it should be closed
  // it also handles everything in the main menu
  if (!menu.run())
  {
    //this code is called, when the main menu is closed
    
    //set the game state to playing
    state = GameState.PLAY;
    //disable button input for the main menu
    menu.setEnabled(false);
    //instantiate a new MainGame instance
    game = new MainGame();
  }
}

//function that handles the main game game state
void mainGame()
{
  //game.run returns true while it should run and returns false if gameplay should end
  if (!game.run())
  {
    //this code is called when gameplay should end (player is dead, bomb detonated)
    
    //set game state to DIE, because player is dead
    state = GameState.DIE;
    //instantiate a new DeathMenu instance
    deathMenu = new DeathMenu();
    
    //IMPORTANT: don't destroy the MainGame instance yet
    //  the DeathMenu instance relies on some data from the MainGame instance
  }
}

//functions that handles the death menu game state
void dieState()
{
  //only shows the death menu
  deathMenu.show();
  //the death menu works differently, because it relies on button callbacks
  //  if the correct button is pressed, it resets the game itself
}

//enable debug mode, by enabling all the coresponding variables
void debugMode()
{
  debug_showHitboxes = true;
}

//the class handling the main game
public class MainGame
{
  //the player
  Player p;
  //the game ui
  GameUI ui;
  //the bomb
  Bomb b;
  //the score the player has reached so far
  int score = 0;

  //bomb animation
  //these are values used for the detonating bomb "animation" in the end
  //how long is the animation in frames
  int bomb_frameCount = 90;
  //how big is the largest radius of the explosion
  float bomb_maxRadius;
  //how big is the current radius of the explosion
  float bomb_radius;
  //how fast should the explosion expand
  float bomb_speed;
  //is the bomb animation playing
  boolean bomb_isPlaying = false;

  public MainGame()
  {
    //create the player
    p = new Player();
    //seems redundant but is REALLY important
    game = this;
    //instantiate a new bomb
    b = new Bomb();

    //create the game ui
    //CRUCIAL: do this after creating the player
    ui = new GameUI();

    //initialize the enemy handler
    //CRUCIAL: do this after creating the player
    initEnemyHandler();
    
    initBulletHandling();
    
    //set the score to 0
    score = 0;
  
    //calculate the animations max radius
    //    it is the distance from the left edge to the right edge of the screen
    bomb_maxRadius = (new PVector(width, height)).mag();
    //get the starting radius of the explosion (size of the bomb)
    //choose which size coordinate of the bomb is bigger
    bomb_radius = b.size.x > b.size.y ? b.size.x : b.size.y;
    //calculate the speed of the explosion in pixels per frame
    bomb_speed = bomb_maxRadius / (float)bomb_frameCount;
    //set the bomb animation to not be playing
    bomb_isPlaying = false;
  }

  //return the current Player instance
  //if there is no player, create a new one
  public Player getP() { 
    if (p == null) return p = new Player(); 
    else return p;
  }
  
  //returns the current Bomb instance
  public Bomb getB()
  {
    return b;
  }
  
  //increase the score by some amount
  public void increaseScore(int amount) { 
    score += amount;
  }
  
  //return the score
  public int getScore() { 
    return score;
  }
  
  //run the main game
  public boolean run()
  {
    //check if the bomb animation is playing
    if (!bomb_isPlaying)
    {
      //if the animation is not playing do the normal gameplay stuff
      
      background(0);
      //handle mouse input
      handleMouse();
      //handle keyboard input
      handleKeys();
      //handle enemies (showing, moving, spawning)
      handleEnemies();
      //handle collisions
      handleCollisions();

      //show the player, bomb and bomb health
      b.show();
      p.show();
      b.showHealth();
      
      handleBullets();
      
      //if in debug mode, draw all colliders
      debugCollisions();

      //show the ui
      ui.show();
      if (p.isDead()) {
        //if the player is dead, clean up the game and return false,
        //  because the game should stop playing
        cleanup();
        return false;
      } else if (b.isDead()) {
        //if the bomb is dead, clean up the game and set the animation to play
        //  dont return false to stop the game loop from playing,
        //  because the bomb animation should still play
        cleanup();
        bomb_isPlaying = true;
      }
      //return true because run loop ran unhindered and game thus shouldnt stop
      return true;
    } else {
      //bomb animation should play
      if (bomb_radius <= bomb_maxRadius * 1.05f) {
        //explosion radius isnt big enough and should increase
        
        //draw the explosion in form of a white circle
        pushStyle();
        noStroke();
        fill(255);
        circle(width/2f, height/2f, bomb_radius);
        popStyle();
        //increase the current bomb radius
        bomb_radius += bomb_speed;
        return true;
      } else {
        //the explosion animation is finished and the game loop should stop, return false
        return false;
      }
    }
  }
  //clean up the game
  void cleanup()
  {
    //clean up the enemy handler
    cleanupEnemies();
    //call the Players onDestroy() to destroy it safely
    p.onDestroy();
  }
}
