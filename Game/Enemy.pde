

public class Enemy implements Rigidbody
{
  PVector pos, dir, size;
  float speed = 2f;
  
  CircleCollider collider;
  
  public Enemy(PVector pos, PVector size)
  {
    this.pos = pos;
    this.size = size;
    collider = new CircleCollider(this, size.mag()/2f, "enemy");
    dir = PVector.sub(pos,p.getPos());
    dir.normalize();
  }
  
  public void show()
  {
    dir = PVector.lerp(PVector.sub(p.getPos(), pos), dir, 0.995f);
    dir.normalize();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-atan2(dir.x, dir.y));
    
    pushStyle();
    fill(200,200,150);
    rect(-size.x/2f, -size.y/2f, size.x, size.y);
    popStyle();
    popMatrix();
  }
  
  void move()
  {
    pos.add(PVector.mult(dir, speed));
  }
  
  //Rigidbody
  public void onCollision()
  {
    println("enemy was hit");
  }
  
  public void onWall()
  {
    
  }
  
  public PVector getPos()
  {
    return pos;
  }
}
