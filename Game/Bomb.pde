//the Bomb class
public class Bomb implements Rigidbody
{
  //the bombs position
  PVector pos;
  //the bombs size
  PVector size;
  
  //the y offset from the position to the bottom of the health display
  float healthYOffset = 25f;
  //the y size of the health display
  float healthYSize = 15f;
  
  //the bombs max health and current health
  int maxHealth = 100, health = maxHealth;
  
  //the bombs collider and collision tag
  RectangleCollider collider;
  public static final String collisionTag = "bomb";
  
  //the bombs default constructor
  public Bomb()
  {
    //set the size
    size = new PVector(125f, 62.5f);
    //calculate the position with the screen center and the size
    pos = new PVector(width/2f-size.x/2f, height/2f-size.y/2f);
    
    //instantiate the RectangleCollider with the size and the collision tag
    collider = new RectangleCollider(this, size, collisionTag);
  }
  
  //show the bomb
  public void show()
  {
    pushStyle();
    //set the ellipse mode to CORNER (needed for some drawing)
    //goes away after popStyle();
    ellipseMode(CORNER);
    noStroke();
    fill(255);
    //the bomb is made up of an ellipse and a rectangle, draw them
    ellipse(pos.x, pos.y, size.x * .75f, size.y);
    rect(pos.x + size.x * 0.75f, pos.y, size.x * .25f, size.y);
    popStyle();
  }
  
  //show the health bar
  public void showHealth()
  {
    //calculate the percentage of health the bomb has left
    float perc = (float)health/(float)maxHealth;
    pushStyle();
    noStroke();
    fill(255, 0, 0);
    //draw the underlying bar spanning the whole horizontal size of the bomb
    rect(pos.x, pos.y - healthYOffset - healthYSize, size.x, healthYSize);
    fill(0, 255, 0);
    //draw the actual health display on top with a horizontal size relative to the health left
    rect(pos.x, pos.y - healthYOffset - healthYSize, size.x*perc, healthYSize);
    popStyle();
  }
  
  //is the bomb dead (is its health less than or equal to 0)
  public boolean isDead() { return health <= 0; }
  
  //Rigidbody
  public void onCollision(Collider other)
  {
    //if it was hit by an enemy, subtract some health
    if(other.tag == Enemy.tag) {
      health-=10;
    }
  }
  
  public void onWall()
  {
    
  }
  
  //return the bombs position (viewpoint collider)
  public PVector getPos()
  {
    return pos;
  }
  
  //get the bombs center
  public PVector getCenter()
  {
    return new PVector(pos.x + .5f * size.x, pos.y + .5f * size.y);
  }
  
  public void onDestroy()
  {
    
  }
}
