//the Games UI
public class GameUI
{
  //the font used in the game
  PFont font;

  //should the health be displayed as circles
  boolean healthDisplayIsCircles = false;
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
    text("fps: " + round(frameRate), 0, 32);
    //draw the health
    drawHealth();
  }

  float spacing = 60f;
  float r = 20f;

  void drawHealth()
  {
    if (healthDisplayIsCircles) {
      //draw circles in the bottom right corner
      //amount of circles is representation of maxHealth of the player
      //amount of these circles filled in, is the amount of health, the player has left

      int drawCircles = round(game.getP().health / 10f);
      int maxCircles = round(game.getP().maxHealth / 10f);
      if (drawCircles < 0) drawCircles = 0;

      pushStyle();
      fill(255, 0, 0);
      stroke(255, 0, 0);
      strokeWeight(5);
      for (int i = 0; i < drawCircles; i++)
      {
        float x = width - spacing / 2f - spacing * i;
        circle(x, height - spacing / 2f, r * 2);
      }
      noFill();
      for (int i = 0; i < maxCircles - drawCircles; i ++)
      {
        float x = width - spacing / 2f - spacing * drawCircles - spacing * i;
        circle(x, height - spacing / 2f, r * 2);
      }
      popStyle();
    } else {
      float perc = (float)game.getP().health/(float)game.getP().maxHealth;
      float actWidth = perc * healthWidth;
      
      //TODO: no rounded edges for the line
      pushStyle();
      //strokeWeight(healthHeight);
      fill(255, 0, 0);
      noStroke();
      rect(healthRight.x-healthWidth, healthRight.y-healthHeight/2f, healthWidth, healthHeight);
      if (perc > 0f)
      {
        fill(0, 255, 0);
        rect(healthRight.x - actWidth, healthRight.y-healthHeight/2f, actWidth, healthHeight);
      }
      popStyle();
    }
  }
}

public class MainMenu implements ButtonEnabled
{
  static final String startButtonID = "start";
  Button startButton;
  
  boolean startGame = false;
  
  public MainMenu()
  {
    startButton = new Button(this, startButtonID,
      new PVector(width/2f-100f, height/2f-50f),
      new PVector(200f, 100f))
      .setText("Start Game");
  }
  
  boolean isEnabled = true;
  
  public void setEnabled(boolean newState)
  {
    isEnabled = newState;
  }
  
  public boolean isEnabled() { return isEnabled; }
  
  public boolean run()
  {
    background(0);
    startButton.show();
    return !startGame;
  }
  
  public void onButtonClick(String buttonID)
  {
    if(buttonID == startButtonID) {
      println("start game");
      startGame = true;
    }
  }
  
  public void reset()
  {
    isEnabled = true;
    startGame = false;
    startButton.resetMouseEnabled();
  }
}

public class DeathMenu implements ButtonEnabled
{
  Button closeButton;
  private static final String closeButtonID = "close";
  
  Button menuButton;
  private static final String menuButtonID = "restart";
  
  public DeathMenu()
  {
    closeButton = new Button(this, closeButtonID, 
      new PVector(width/2f - 150f, height/2f - 100f),
      new PVector(300f, 100f))
      .setText("Close");
    menuButton = new Button(this, menuButtonID, 
      new PVector(width/2f - 100f, height/2f + 150f),
      new PVector(200f, 100f))
      .setText("Main Menu");
  }
  
  public void show()
  {
    background(0);
    closeButton.show();
    menuButton.show();
  }
  
  public void onButtonClick(String id)
  {
    if(id == closeButtonID) {
      exit();
    } else if(id == menuButtonID) {
      reset();
    }
  }
  
  boolean isEnabled = true;
  public void setEnabled(boolean newState)
  {
    isEnabled = newState;
  }
  
  public boolean isEnabled() { return isEnabled; }
}
