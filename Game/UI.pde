public class GameUI
{
  PFont font;
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
    int drawCircles = round(p.health / 10f);
    int maxCircles = round(p.maxHealth / 10f);
    if(drawCircles < 0) drawCircles = 0;
    
    pushStyle();
    fill(255,0,0);
    stroke(255,0,0);
    strokeWeight(5);
    for(int i = 0; i < drawCircles; i++)
    {
      float x = width - spacing / 2f - spacing * i;
      circle(x, height - spacing / 2f, r * 2);
    }
    noFill();
    for(int i = 0; i < maxCircles - drawCircles; i ++)
    {
      float x = width - spacing / 2f - spacing * drawCircles - spacing * i;
      circle(x, height - spacing / 2f, r * 2);
    }
    popStyle();
  }
}
