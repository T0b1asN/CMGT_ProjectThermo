public class Bullet implements Rigidbody
{
  PVector pos, v;
  CircleCollider collider;
  
  boolean isDead = false;
  int id;
  
  final String col_tag = "bullet";
  String tag;
  final float r = 5f;
  
  public Bullet(PVector pos, PVector dir, float speed, int id)
  {
    this.pos = new PVector(pos.x, pos.y);
    this.v = PVector.mult(dir, speed);
    
    tag = col_tag;
    collider = new CircleCollider(this, r, tag);
    collider.ignoreCollision(tag);
    this.id = id;
  }
  
  public Bullet(PVector pos, PVector dir, float speed, String tag)
  {
    this.pos = new PVector(pos.x, pos.y);
    this.v = PVector.mult(dir, speed);
    
    this.tag = tag;
    collider = new CircleCollider(this, r, tag);
    collider.ignoreCollision(tag);
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
  
  void onCollision(String tag)
  {
    //println(id + " bullet has collided with something");
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
