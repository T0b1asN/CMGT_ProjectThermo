

public class Bomb implements Rigidbody
{
  PVector pos;
  PVector size;
  
  float healthYOffset = 25f;
  float healthYSize = 15f;
  
  int maxHealth = 10, health = maxHealth;
  
  RectangleCollider collider;
  public static final String collisionTag = "bomb";
  
  public Bomb()
  {
    size = new PVector(125f, 62.5f);
    pos = new PVector(width/2f-size.x/2f, height/2f-size.y/2f);
    
    collider = new RectangleCollider(this, size, collisionTag);
  }
  
  public void show()
  {
    pushStyle();
    ellipseMode(CORNER);
    noStroke();
    fill(255);
    ellipse(pos.x, pos.y, size.x * .75f, size.y);
    rect(pos.x + size.x * 0.75f, pos.y, size.x * .25f, size.y);
    popStyle();
  }
  
  public void showHealth()
  {
    float perc = (float)health/(float)maxHealth;
    pushStyle();
    noStroke();
    fill(255, 0, 0);
    rect(pos.x, pos.y - healthYOffset - healthYSize, size.x, healthYSize);
    fill(0, 255, 0);
    rect(pos.x, pos.y - healthYOffset - healthYSize, size.x*perc, healthYSize);
    popStyle();
  }
  
  public boolean isDead() { return health <= 0; }
  
  //Rigidbody
  public void onCollision(Collider other)
  {
    if(other.tag == Enemy.tag) {
      health-=10;
    }
  }
  
  public void onWall()
  {
    
  }
  
  public PVector getPos()
  {
    return pos;
  }
  
  public void onDestroy()
  {
    
  }
}
