//the Games UI
public class GameUI
{
  //the font used in the game
  PFont font;

  //the right coordinate of the health display, if it is a line
  PVector healthRight = new PVector();
  //the height of the health display
  float healthHeight = 30f;
  //the maxWidth of the health display
  float healthWidth = 200f;

  //default constructor
  public GameUI()
  {
    //load the font
    font = loadFont("Bahnschrift-128.vlw");
    //set the loaded font as the used font
    textFont(font);
    //set the text size
    textSize(32);

    healthRight.set(width-10f, height-10f-healthHeight/2f);
  }

  //show the UI
  public void show()
  {
    //draw the fps in the top left corner
    pushStyle();
    textSize(32);
    textAlign(LEFT);
    text("fps: " + round(frameRate), 0, 32);
    popStyle();
    //draw the health
    drawHealth();
    //draw the score
    drawScore();
  }

  //show the score in the middle of the screen
  void drawScore()
  {
    pushStyle();
    textSize(64);
    textAlign(CENTER);
    text("Score: " + game.getScore(), width/2f, 200f);
    popStyle();
  }

  //draw the health bar
  void drawHealth()
  {
    //calculate the percentage of health left
    float perc = (float)game.getP().health/(float)game.getP().maxHealth;
    //translate the left percentage to the health display width
    float actWidth = perc * healthWidth;

    //TODO: no rounded edges for the line
    pushStyle();
    //strokeWeight(healthHeight);
    fill(255, 0, 0);
    noStroke();
    //draw the underying rectangle with the normal width
    rect(healthRight.x-healthWidth, healthRight.y-healthHeight/2f, healthWidth, healthHeight);
    if (perc > 0f)
    {
      fill(0, 255, 0);
      //draw the top rectangle displaying the actual health with the width
      //  coresponding to the health
      rect(healthRight.x - actWidth, healthRight.y-healthHeight/2f, actWidth, healthHeight);
    }
    popStyle();
  }
}

//the main menu class
public class MainMenu implements ButtonEnabled
{
  //the start button and its id
  static final String startButtonID = "start";
  Button startButton;

  //should the game start
  boolean startGame = false;

  public MainMenu()
  {
    //instantiate the start button with the id, a position, a size and set some text for it
    startButton = new Button(this, startButtonID, 
      new PVector(width/2f-100f, height/2f-50f), 
      new PVector(200f, 100f))
      .setText("Start Game");
  }

  //is the button input for it enabled
  boolean isEnabled = true;
  //set if the button input is enabled for it
  public void setEnabled(boolean newState)
  {
    isEnabled = newState;
  }
  //return if the button input is enabled for this menu
  public boolean isEnabled() { 
    return isEnabled;
  }

  //run the main menu
  //  returns true, if the menu should continue
  //  returns false, if the menu should be closed
  public boolean run()
  {
    background(0);
    //draw the button
    startButton.show();
    //return true if the game shouldnt start
    return !startGame;
  }

  //button callback
  public void onButtonClick(String buttonID)
  {
    //if the start button has been clicked, set startGame to true,
    //  to signalize, that the menu should be closed
    if (buttonID == startButtonID) {
      startGame = true;
    }
  }
  
  //function to reset the menu to its initial state
  public void reset()
  {
    //reset the booleans
    isEnabled = true;
    startGame = false;
    //readd the button to the mouse callback list
    startButton.resetMouseEnabled();
  }
}

//the DeathMenu class (game over screen
public class DeathMenu implements ButtonEnabled
{
  //close button with id
  Button closeButton;
  private static final String closeButtonID = "close";
  
  //menu button with id
  Button menuButton;
  private static final String menuButtonID = "restart";
  
  //the score (gotten from the main menu class)
  int score = 0;

  //default constructor
  public DeathMenu()
  {
    //instantiate the close button with the id, a position and a size and set some values
    closeButton = new Button(this, closeButtonID, 
      new PVector(width/2f - 150f, height/2f - 50f), 
      new PVector(300f, 75f))
      .setText("Close")
      .setNormalC(color(200))
      .setHighlightC(color(150))
      .setTextC(color(0));
    //instantiate the menu button with the id, a position and a size and set some values
    menuButton = new Button(this, menuButtonID, 
      new PVector(width/2f - 100f, height/2f + 50f), 
      new PVector(200f, 75f))
      .setText("Main Menu")
      .setNormalC(color(200))
      .setHighlightC(color(150))
      .setTextC(color(0));
    
    //get the score from the main menu
    score = game.getScore();
  }
  
  //show the game over screen
  public void show()
  {
    background(255);
    //show the buttons
    closeButton.show();
    menuButton.show();
    //draw the score onto the screen
    pushStyle();
    fill(0);
    noStroke();
    textAlign(CENTER);
    textSize(64);
    text("Score: " + score, width/2f, 200f);
    popStyle();
  }
  
  //button callback
  public void onButtonClick(String id)
  {
    if (id == closeButtonID) {
      //if the close button has been pressed, close the application
      exit();
    } else if (id == menuButtonID) {
      //if the menu button has been pressed, reset the game
      reset();
    }
  }
  
  //is the menu ButtonEnabled
  //see MainMenu for more explanation (same functions)
  //is the menu enabled
  boolean isEnabled = true;
  //set if the menu is enabled
  public void setEnabled(boolean newState)
  {
    isEnabled = newState;
  }
  //check if the menu enabled
  public boolean isEnabled() { 
    return isEnabled;
  }
}
