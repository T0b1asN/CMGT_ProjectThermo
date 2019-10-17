

public class Enemy implements Rigidbody
{
  PVector pos, lookDir, shootDir, size;
  float speed = 2f;
  
  PVector target;
  
  CircleCollider collider;
  
  public Enemy(PVector pos, PVector size)
  {
    this.pos = pos;
    this.size = size;
    collider = new CircleCollider(this, size.mag()/2f, "enemy");
    lookDir = PVector.sub(pos,p.getPos());
    lookDir.normalize();
    
    shootDir = PVector.sub(pos, p.getPos());
    shootDir.normalize();
    
    target = new PVector();
  }
  
  public void show()
  {
    calcTarget();
    
    lookDir = PVector.sub(target, pos);
    lookDir.normalize();
    
    shootDir = PVector.sub(p.getPos(), pos);
    shootDir.normalize();
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-atan2(shootDir.x, shootDir.y));
    
    pushStyle();
    fill(200,200,150);
    //rect(-size.x/2f, -size.y/2f, size.x, size.y);
    triangle(0, size.y/2f, size.x/2f, -size.y/2f, -size.x/2f, -size.y/2f);
    popStyle();
    popMatrix();
  }
  
  void move()
  {
    if(pos.dist(target) > speed*2f)
      pos.add(PVector.mult(lookDir, speed));
  }
  
  void calcTarget()
  {
    PVector ret = PVector.sub(p.getPos(), pos);
    float mag = ret.mag();
    ret.normalize();
    
    target = PVector.add(pos, ret.mult(mag-250));
    circle(target.x, target.y, 25f);
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
