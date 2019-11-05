//the Player class, which implements the Rigidbody interface, because it needs a Collider
public class Player implements Rigidbody, MouseEnabled
{
  //the position of the player
  PVector pos;
  //the direction the player shoots in
  PVector dir;
  //the direction the player moves in
  //dont mistake this with the move vector from keyboard handling
  //this is used to determine the rotation, the player should look in
  PVector moveDir;
  
  //the speed of the player
  float speed = 7f;
  
  //the list of bullets
  ArrayList<Bullet> bullets;
  //the collision tag for the bullets
  public static final String bulletTag = "bulletP";
  
  //the players collision tag
  public static final String collisionTag = "player";
  //the players radius
  final float r = 30f;
  
  //the players collider
  CircleCollider collider;
  
  //the players health
  int maxHealth = 60, health = maxHealth;
  
  //default constructor for the player
  public Player()
  {
    //set the position to the center of the screen
    pos = new PVector(width/2f, height/2f);
    //initialize shoot direction and move direction
    dir = new PVector();
    moveDir = new PVector();
    
    //initialize the list of bullets
    bullets = new ArrayList<Bullet>();
    
    //create a new CircleCollider with the radius and the collision tag
    collider = new CircleCollider(this, r, collisionTag);
    //ignore collision with the players bullets
    collider.ignoreCollision(bulletTag);
    
    addMouseEnabled(this);
  }

  //the constructor with a parameter for position
  public Player(PVector pos)
  {
    //copy the position
    this.pos = copy(pos);
    //initialize shoot direction and move direction
    dir = new PVector();
    moveDir = new PVector();
    
    //initialize bullet list
    bullets = new ArrayList<Bullet>();
    
    //create a new circle collider with the radius and collision tag
    collider = new CircleCollider(this, r, collisionTag);
    //ignore collision with the players bullets
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
    
    //this creates flicker on the wall after diagonal movement
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
    
    drawBody();
    drawTower();
  }
  
  void drawBody()
  {
    pushMatrix();
    //translate to the position
    translate(pos.x, pos.y);
    //rotate to look in the move direction
    rotate(-atan2(moveDir.x, moveDir.y));
    //draw a triangle
    
    //tracks
    pushStyle();
    fill(80);
    rect(-r*.95f, -r*.95f, r*.6f, r*1.9f, 4);
    rect(r*.95f-r*.6f, -r*.95f, r*.6f, r*1.9f, 4);
    popStyle();
    
    //body
    pushStyle();
    fill(83, 107, 30);
    beginShape();
    
    vertex(-r*.25f, -r*.9f);
    vertex(-r*.3f, -r);
    vertex(-r*.8f, -r);
    vertex(-r, -r*.5f);
    vertex(-r, 0);
    vertex(-r*.75f, r);
    vertex(-r*.55f, r);
    vertex(-r*.4f, r*.35f);
    
    vertex(0, r*.15f);
    
    vertex(r*.4f, r*.35f);
    vertex(r*.55f, r);
    vertex(r*.75f, r);
    vertex(r, 0);
    vertex(r, -r*.5f);
    vertex(r*.8f, -r);
    vertex(r*.3f, -r);
    vertex(r*.25f, -r*.9f);
    
    endShape(CLOSE);
    //triangle(-r, -r, 0, r, r, -r);
    //circle(pos.x, pos.y, r*2);
    popStyle();
    popMatrix();
  }
  
  void drawTower()
  {
    pushStyle();
    fill(107, 133, 52);
    pushMatrix();
    
    translate(pos.x,pos.y);
    rotate(-atan2(dir.x, dir.y));
    arc(0,0,r,r,PI,TWO_PI);
    
    beginShape();
    vertex(-r*.5f,0);
    vertex(-r*.1f, r);
    vertex(r*.1f, r);
    vertex(r*.5f,0);
    endShape();
    
    popMatrix();
    popStyle();
  }
  
  //called when the mouse is pressed down
  void onMouseClick()
  {
    //shoot by instantiating a new bullet
    Bullet n = new Bullet(this.pos, this.dir, 9f, bulletTag, color(255));
    //bullets.add(n);
    addBullet(n);
  }
  
  public boolean isDead()
  {
    return health <= 0;
  }
  
  //Rigidbody
  public void onCollision(Collider other)
  {
    if(other.tag == Enemy.bulletTag) {
      //if the player is hit by and enemy bullet, decrease own health by two and kill the bullet
      health -= 2;
      ((Bullet)other.parent).kill();
    } else if(other.tag == Enemy.tag) {
      //if the player was hit by an enemy, decrease the health by 2
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
