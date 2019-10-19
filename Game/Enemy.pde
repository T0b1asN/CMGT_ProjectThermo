//The Enemy class, which implements the Rigidbody interface, because it needs collision
public class Enemy implements Rigidbody
{
  //the enemy position
  PVector pos;
  //the position the enemy moves in (points to target)
  PVector moveDir;
  //the position the enemy shoots in (points to player)
  PVector shootDir;
  //the size of the enemy
  PVector size;
  //the speed of the enemy
  float speed = 1f;
  
  //max health and health of the enemy
  int maxHealth = 4, health = maxHealth;
  
  //shooting timer
  int startValue = 240, timer = startValue;
  
  //target the enemy wants to reach
  PVector target;
  //the distance the enemy wants to keep to the enemy
  float targetDist = 150f;
  
  //the collider
  CircleCollider collider;
  
  //the list of bullets
  ArrayList<Bullet> bullets;
  
  //the collision tag for the bullets
  final static String bulletTag = "bulletE";
  //the collision tag for itself
  final static String tag = "enemy";
  
  //should the enemy be deleted
  boolean isDead = false;
  
  //the position of the health bar (anchor is left) relative to the enemy position
  PVector healthPos;
  
  //constructor with parameters for position, size and distance to player
  public Enemy(PVector pos, PVector size, float targetDist)
  {
    //copy size and position
    this.pos = copy(pos);
    this.size = copy(size);
    
    //copy target distance
    this.targetDist = targetDist;
    
    //instantiate the collider
    collider = new CircleCollider(this, size.mag()/2f, tag);
    
    //calculate initial move direction (points to player) and normalize it
    moveDir = PVector.sub(pos,p.getPos());
    moveDir.normalize();
    
    //calculate initial shoot direction (points to player) and normalize it
    shootDir = PVector.sub(pos, p.getPos());
    shootDir.normalize();
    
    //initialize target
    target = new PVector();
    
    //initialize bullet container
    bullets = new ArrayList<Bullet>();
    
    //ignore collision with its own bullets
    collider.ignoreCollision(bulletTag);
    
    //start the shooting timer with a random start value
    timer = (int)random(startValue);
    
    //calculate the health offset
    healthPos = new PVector(-size.x/2f, -((size.y/2f)*1.5f));
  }
  
  //show the enemy
  public void show()
  {
    //calculate the target
    calcTarget();
    
    //calculate the move direction (points to target)
    moveDir = PVector.sub(target, pos);
    moveDir.normalize();
    
    //calculate the shoot direction (points to player)
    shootDir = PVector.sub(p.getPos(), pos);
    shootDir.normalize();
    
    pushMatrix();
    //translate to the position
    translate(pos.x, pos.y);
    //rotate to shootDir
    rotate(-atan2(shootDir.x, shootDir.y));
    
    pushStyle();
    fill(200,200,150);
    //rect(-size.x/2f, -size.y/2f, size.x, size.y);
    
    //draw a triangle
    triangle(0, size.y/2f, size.x/2f, -size.y/2f, -size.x/2f, -size.y/2f);
    popStyle();
    popMatrix();
    
    //handle the bullets
    //create a new ArrayList with bullets to remove
    ArrayList<Bullet> found = new ArrayList<Bullet>();
    for(Bullet b : bullets)
    {
      if(b.isDead()) {
        // if the bullet should be deleted, add it to the list for that and call its function onDestroy()
        found.add(b);
        b.onDestroy();
      } else {
        // id it shouldnt be deleted, move it and draw it
        b.move();
        b.show();
      }
    }
    //remove all the bullets that should be removed
    bullets.removeAll(found);
    
    //handle timer
    timer--;
    if(timer <= 0)
    {
      //if the timer reaches 0, reset it and shoot
      timer = startValue;
      shoot();
    }
  }
  
  //return, if the enemy should be deleted
  public boolean isDead() { return isDead; }
  
  //shoot a bullet
  void shoot()
  {
    //instantiate a new bullet at this position in the shoot direction, with a speed of 7f and the bullet collision tag
    Bullet n = new Bullet(this.pos, this.shootDir, 7f, bulletTag);
    bullets.add(n);
  }
  
  //move the enemy
  void move()
  {
    //if the distance to the target is less then the speed*2 (prevents constant back and forth/is a deadzone)
    //add the move direction multiplied by the speed to the position
    if(pos.dist(target) > speed*2f)
      pos.add(PVector.mult(moveDir, speed));
  }
  
  //calculate the target
  void calcTarget()
  {
    //get the vector between the players position and the enemys position
    PVector ret = PVector.sub(p.getPos(), pos);
    //get the distance between the player and the enemy and save it
    float mag = ret.mag();
    //normalize the vector between player and enemy, giving the vector between them
    ret.normalize();
    //multiply that vector by the previously saved distance minus the desired distance
    ret.mult(mag-targetDist);
    //get the target position by adding the enemys position and the previously calculated vector
    target = PVector.add(pos, ret);
    
    //if desired (debug mode) draw a circle at the target position
    if(debug) circle(target.x, target.y, 25f);
  }
  
  void onDestroy()
  {
    collider.onDestroy();
    //TODO: maybe handle differently
    for(Bullet b : bullets)
    {
      b.onDestroy();
    }
  }
  
  void showHealthBar()
  {
    pushStyle();
    stroke(255,0,0);
    strokeWeight(5);
    noFill();
    //calculate the health percentage
    float perc = (float)health/(float)maxHealth;
    //draw a line from the healthbar position to size.x*percentage on the x axis
    line(healthPos.x+pos.x, healthPos.y+pos.y, healthPos.x+pos.x+(size.x*perc), healthPos.y+pos.y); 
    popStyle();
  }
  
  //Rigidbody
  public void onCollision(Collider other)
  {
    if(other.tag == Player.bulletTag) {
      //if the other collider belongs to a bullet from the player, kill that bullet and subtract health
      ((Bullet)other.parent).kill();
      health--;
      //check if enemy should be dead
      if(health <= 0) isDead = true;
    } else if(other.tag == Player.collisionTag) {
      //if the other collider belongs to the player, kill the enemy
      isDead = true;
    }
  }
  
  public void onWall()
  {
    
  }
  
  public PVector getPos()
  {
    return pos;
  }
}
