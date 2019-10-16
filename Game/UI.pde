public class GameUI
{
  PFont font;
  int maxHealth = 5;
  int health = 5;
  public GameUI()
  {
    font = loadFont("Bahnschrift-128.vlw");
    textFont(font);
    textSize(32);
  }
  
  public void show()
  {
    text("fps: " + round(frameRate), 0, 32);
    drawHealth();
  }
  
  float spacing = 60f;
  float r = 20f;
  
  void drawHealth()
  {
    if(health > maxHealth) health = maxHealth;
    
    pushStyle();
    fill(255,0,0);
    stroke(255,0,0);
    strokeWeight(5);
    for(int i = 0; i < health; i++)
    {
      float x = width - spacing / 2f - spacing * i;
      circle(x, height - spacing / 2f, r * 2);
    }
    noFill();
    for(int i = 0; i < maxHealth - health; i ++)
    {
      float x = width - spacing / 2f - spacing * health - spacing * i;
      circle(x, height - spacing / 2f, r * 2);
    }
    popStyle();
  }
}
