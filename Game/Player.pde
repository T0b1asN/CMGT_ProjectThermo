

public class Player implements Rigidbody
{
  PVector pos, dir;
  float speed = 5f;
  
  ArrayList<Bullet> bullets;
  
  int count = 0;
  
  public static final String collisionTag = "player";
  final float r = 25f;
  
  CircleCollider collider;
  
  public Player()
  {
    pos = new PVector(width/2f, height/2f);
    dir = new PVector();
    
    bullets = new ArrayList<Bullet>();
    
    collider = new CircleCollider(this, r, collisionTag);
  }

  public Player(PVector pos)
  {
    this.pos = pos;
    dir = new PVector();
    
    bullets = new ArrayList<Bullet>();
  }

  void move(PVector v)
  {
    //v is normalized so multiply it by the speed
    v.mult(speed);
    
    //the positions the player would have after applying the velocity
    float newX = pos.x + v.x;
    float newY = pos.y + v.y;
    
    //if the new position is outside the border check how far the player can still move
    if (newX < r) v.x -= newX - r;
    if (newX > width-r) v.x -= newX - (float)width + r;
    if (newY > height-r) v.y -= newY - (float)height + r;
    if (newY < r) v.y -= newY - r;
    
    //if(v.x == 0f || v.y == 0f) v.setMag(speed);
    
    //add the new velocity
    pos.add(v);
  }

  void show()
  {
    //calculate the new rotation, looking at the mouse position
    dir = new PVector(mouseX, mouseY).sub(pos);
    dir.normalize();
    
    //draw everything
    pushStyle();
    fill(255);
    circle(pos.x, pos.y, r*2);
    PVector dir_temp = new PVector(dir.x, dir.y);
    stroke(255);
    strokeWeight(5);
    dir_temp.setMag(100);
    dir_temp.add(pos);
    line(pos.x, pos.y, dir_temp.x, dir_temp.y);
    popStyle();
    
    //Bullets
    ArrayList<Bullet> found = new ArrayList<Bullet>();
    for(Bullet b : bullets)
    {
      if(b.isDead()) {
        found.add(b);
        b.onDestroy();
      }
      else {
        b.move();
        b.show();
      }
    }
    bullets.removeAll(found);
  }
  
  void onMouseDown()
  {
    //shoot
    Bullet n = new Bullet(this.pos, this.dir, 7f, count);
    bullets.add(n);
    count++;
  }
  
  //Rigidbody
  public void onCollision()
  {
    
  }
  
  public void onWall()
  {
    
  }
  
  public PVector getPos()
  {
    return pos;
  }
}
