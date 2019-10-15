public class Bullet implements Rigidbody
{
  PVector pos, v;
  CircleCollider collider;
  
  boolean isDead = false;
  int id;
  
  final String col_tag = "bullet";
  final float r = 5f;
  
  public Bullet(PVector pos, PVector dir, float speed, int id)
  {
    this.pos = new PVector(pos.x, pos.y);
    this.v = PVector.mult(dir, speed);
    
    collider = new CircleCollider(this, r, col_tag);
    collider.ignoreCollision(col_tag);
    collider.ignoreCollision(Player.collisionTag);
    this.id = id;
  }
  
  void move()
  {
    this.pos.add(v);
  }
  
  boolean isDead()
  {
    return isDead;
  }
  
  void show()
  {
    pushStyle();
    fill(255,0,0);
    noStroke();
    circle(pos.x, pos.y, r*2);
    popStyle();
  }
  
  void onCollision()
  {
    println(id + " bullet has collided with something");
  }
  
  void onWall()
  {
    isDead = true;
  }
  
  PVector getPos()
  {
    return pos;
  }
  
  void onDestroy()
  {
    collider.onDestroy();
  }
}
