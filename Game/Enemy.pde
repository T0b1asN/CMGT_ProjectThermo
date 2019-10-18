

public class Enemy implements Rigidbody
{
  PVector pos, lookDir, shootDir, size;
  float speed = 2f;
  
  int startValue = 60, timer = startValue;
  
  PVector target;
  
  CircleCollider collider;
  
  ArrayList<Bullet> bullets;
  final static String bulletTag = "bulletE";
  
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
    
    bullets = new ArrayList<Bullet>();
    collider.ignoreCollision(bulletTag);
    timer = (int)random(startValue);
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
    
    timer--;
    if(timer <= 0)
    {
      timer = startValue;
      shoot();
    }
  }
  
  void shoot()
  {
    Bullet n = new Bullet(this.pos, this.shootDir, 7f, bulletTag);
    bullets.add(n);
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
  public void onCollision(Collider other)
  {
    if(other.tag == Player.bulletTag) {
      println("enemy was hit by bullet");
      ((Bullet)other.parent).kill();
    } else if(other.tag == Player.collisionTag) {
      println("Player hit enemy");
    }
    //println("enemy was hit by " + other.tag);
  }
  
  public void onWall()
  {
    
  }
  
  public PVector getPos()
  {
    return pos;
  }
}
