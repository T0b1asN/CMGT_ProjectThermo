

public class Player implements Rigidbody
{
  PVector pos, dir, moveDir;
  float speed = 7f;
  
  ArrayList<Bullet> bullets;
  public static final String bulletTag = "bulletP";
  
  int count = 0;
  
  public static final String collisionTag = "player";
  final float r = 25f;
  
  CircleCollider collider;
  
  int maxHealth = 60, health = maxHealth;
  
  public Player()
  {
    pos = new PVector(width/2f, height/2f);
    dir = new PVector();
    moveDir = new PVector();
    
    bullets = new ArrayList<Bullet>();
    
    collider = new CircleCollider(this, r, collisionTag);
    collider.ignoreCollision(bulletTag);
  }

  public Player(PVector pos)
  {
    this.pos = copy(pos);
    dir = new PVector();
    moveDir = new PVector();
    
    bullets = new ArrayList<Bullet>();
    
    collider = new CircleCollider(this, r, collisionTag);
    collider.ignoreCollision(bulletTag);
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
    if(v.x > 0f || v.y > 0f || v.x < 0f || v.y < 0f)
      moveDir.set(v.x, v.y).normalize();
  }

  void show()
  {
    //calculate the new rotation, looking at the mouse position
    dir = new PVector(mouseX, mouseY).sub(pos);
    dir.normalize();
    
    //draw everything
    pushStyle();
    fill(255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-atan2(moveDir.x, moveDir.y));
    triangle(-r, -r, 0, r, r, -r);
    //circle(pos.x, pos.y, r*2);
    
    popMatrix();
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
    Bullet n = new Bullet(this.pos, this.dir, 9f, bulletTag, color(0,0,255));
    bullets.add(n);
    count++;
  }
  
  //Rigidbody
  public void onCollision(Collider other)
  {
    if(other.tag == Enemy.bulletTag) {
      health -= 2;
      ((Bullet)other.parent).kill();
    } else if(other.tag == Enemy.tag) {
      health -= 10;
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
    collider.onDestroy();
  }
}
