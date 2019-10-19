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

      int drawCircles = round(p.health / 10f);
      int maxCircles = round(p.maxHealth / 10f);
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
      float perc = (float)p.health/(float)p.maxHealth;
      float actWidth = perc * healthWidth;
      
      //TODO: no rounded edges for the line
      pushStyle();
      strokeWeight(healthHeight);
      stroke(255, 0, 0);
      line(healthRight.x-healthWidth, healthRight.y, healthRight.x, healthRight.y);
      if (perc > 0f)
      {
        stroke(0, 255, 0);
        line(healthRight.x - actWidth, healthRight.y, healthRight.x, healthRight.y);
      }
      popStyle();
    }
  }
}
