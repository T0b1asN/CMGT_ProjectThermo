public class Bullet implements Rigidbody
{
  //the position and velocity of the bullet
  PVector pos, v;
  //the Collider of the bullet
  CircleCollider collider;

  //is the bullet dead (should it be deleted)
  boolean isDead = false;

  //the bullets default collision tag
  final String col_tag = "bullet";
  //the bullets collision tag
  String tag;
  //the bullets radius
  final float r = 5f;

  //the bullets color
  color c;

  //collider with parameters for position, direction, speed and collision tag
  public Bullet(PVector pos, PVector dir, float speed, String tag)
  {
    //copy the position
    this.pos = copy(pos);
    //create the velocity out of direction and speed
    this.v = PVector.mult(dir, speed);

    //copy the tag
    this.tag = tag;

    //create a new CircleCollider with the radius and the given tag
    collider = new CircleCollider(this, r, tag);
    //ignore collision with objects of same tag
    collider.ignoreCollision(tag);

    //set color to red
    c = color(255, 0, 0);
  }

  //collider with parameters for position, direction, speed, collision tag and color
  public Bullet(PVector pos, PVector dir, float speed, String tag, color c)
  {
    //copy position
    this.pos = copy(pos);
    //create velocity out of direction and speed;
    this.v = PVector.mult(dir, speed);

    //copy tag
    this.tag = tag;
    //create a new CircleCollider with the radius and the given collision tag
    collider = new CircleCollider(this, r, tag);
    //ignore collision with objects with the same tag
    collider.ignoreCollision(tag);

    //set color to given color
    this.c = c;
  }

  //this should be called ONCE every frame
  void move()
  {
    //move the bullet by adding the velocity to the position
    this.pos.add(v);
  }

  //returns if the bullet should be deleted
  boolean isDead()
  {
    return isDead;
  }

  //draw the bullet, should be called ONCE every frame
  void show()
  {
    pushStyle();
    fill(c);
    noStroke();
    circle(pos.x, pos.y, r*2);
    popStyle();
  }

  //kill the bullet
  void kill()
  {
    isDead = true;
  }

  //Rigidbody
  //see general function descriptions in the interface

  void onCollision(Collider other)
  {
  }

  //specific: bullets gets deleted when it hits a wall
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

//Bullet handler
ArrayList<Bullet> bullets;

void initBulletHandling()
{
  bullets = new ArrayList<Bullet>();
}

void handleBullets()
{
  //Bullets
  //the list of bullets up for deletion
  ArrayList<Bullet> found = new ArrayList<Bullet>();
  for (Bullet b : bullets)
  {
    if (b.isDead()) {
      //if the bullet should be deleted, add it to the deletion list
      found.add(b);
      //call onDestroy() on it
      b.onDestroy();
    } else {
      //if it shouldnt be deleted, move and show the bullet
      b.move();
      b.show();
    }
  }
  //remove all bullets up for deletion
  bullets.removeAll(found);
}

void addBullet(Bullet b)
{
  bullets.add(b);
}

void removeBullet(Bullet b)
{
  bullets.remove(b);
}

void cleanupBulletHandling()
{
  for (Bullet b : bullets)
  {
    b.onDestroy();
  }
}
