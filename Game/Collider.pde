//the Collider base class
public abstract class Collider
{
  //constructs a new Collider with the Rigidbody parent and the collision tag
  protected Collider(Rigidbody parent, String tag)
  {
    //sets parent and tag
    this.parent = parent;
    this.tag = tag;
    
    //instantiate ignoreCollisionList
    ignoreCollision = new ArrayList<String>();

    //add collider to collision handling
    addCollider(this);
  }
  //the colliders parent
  private Rigidbody parent;
  //the colliders collision tag
  private String tag;
  
  //list of collision tags to ignore
  ArrayList<String> ignoreCollision;
  
  //the type of the collider
  public abstract ColliderType type();
  //general: returns true if this collider is colliding with Collider other
  public abstract boolean isColliding(Collider other);
  //general: returns true, when the Collider hits a wall
  public abstract void checkWall();
  
  //general: shows the debug view of the collider (outline)
  //         style is determined by the collision handler
  public abstract void debug_show();
  
  //add a tag to be ignored by this collider
  public void ignoreCollision(String tag)
  {
    ignoreCollision.add(tag);
  }
  
  //notify a collider about a collision
  public void notifyCollision(Collider other)
  {
    parent.onCollision(other);
  }
  
  //get the position of the collider (returns the parents position)
  public PVector pos()
  {
    return parent.getPos();
  }
  
  //called when collider is destroyed (removes itself from collision handling)
  void onDestroy()
  {
    removeCollider(this);
  }
}

//enum for the different types of colliders
public enum ColliderType
{
  Circle, Rectangle
}

//subclass of collider in form of a circle
public class CircleCollider extends Collider
{
  //the origin is the center
  
  //the radius of the collider
  float r;

  //constructor with parameters for the parent and the radius
  public CircleCollider(Rigidbody parent, float r) 
  {
    //call supers constructor with the given parent and an empty collision tag
    super(parent, " ");
    //set r
    this.r = r;
  }
  
  //constructor with parameters for the parent, the radius and the collision tag
  public CircleCollider(Rigidbody parent, float r, String tag) 
  {
    //call supers constructor with the given parent and collision tag
    super(parent, tag);
    //set r
    this.r = r;
  }
  
  //implement the type() function by always returning ColliderType.Circle
  public ColliderType type() { 
    return ColliderType.Circle;
  }
  
  //implementation of the isColliding function
  public boolean isColliding(Collider other)
  {
    //check if collision should be ignored between the colliders    
    if (super.ignoreCollision.contains(other.tag)) return false;
    if (other.ignoreCollision.contains(super.tag)) return false;

    boolean ret = false;
    //depending on the type of the other collider, call the corresponding collision function
    if (other.type() == ColliderType.Circle) {
      ret = collisionWithCircle((CircleCollider)other);
    } else if (other.type() == ColliderType.Rectangle) {
      ret = collisionWithRectangle((RectangleCollider)other);
    }
    return ret;
  }
  
  //does this CircleCollider collide with the CirclecCollider other
  private boolean collisionWithCircle(CircleCollider other)
  {
    //return true, if the distance between the two circles is less than there radii combined
    if (pos().dist(other.pos()) < r + other.r)
      return true;
    return false;
  }

  //does this CircleCollider collide with the RectangleCollider other
  private boolean collisionWithRectangle(RectangleCollider other)
  {
    //return what the collision function for circles of the RectangleCollider returns
    //(saves one implementation  :D);
    return other.collisionWithCircle(this);
  }

  public void checkWall()
  {
    //if the pos is between [r, width-r] and [r, height-r] call the function onWall() by the parent
    //provided by the Rigidbody interface
    if (pos().x < r || pos().x > width-r) super.parent.onWall();
    if (pos().y < r || pos().y > height-r) super.parent.onWall();
  }
  
  public void debug_show()
  {
    //draw a circle at the position with the given radius
    circle(pos().x, pos().y, r*2);
  }
}

//subclass of Collider in form of a rectangle
public class RectangleCollider extends Collider
{
  //the origin is the topleft corner
  
  //the size of the rectangle
  PVector size;

  //constructor with parameters for the parent and the size
  public RectangleCollider(Rigidbody parent, PVector size)
  {
    //call supers constructor with an empty collision tag
    super(parent, " ");
    this.size = size;
  }
  
  //constructor with parameters for the parent, the size and the collision tag
  public RectangleCollider(Rigidbody parent, PVector size, String tag)
  {
    //call supers constructor with the given collision tag
    super(parent, tag);
    this.size = size;
  }

  //return the "real" position of the collider
  //only here for the case that the origin changes
  PVector getRealPos()
  {
    return pos();
    //return new PVector(pos().x - size.x / 2f, pos().y - size.y / 2f);
  }

  //always return ColliderType.Rectangle as the type
  public ColliderType type() { 
    return ColliderType.Rectangle;
  }

  //implementation of the isColliding function
  public boolean isColliding(Collider other)
  {
    //check if the collision should be ignored
    if (super.ignoreCollision.contains(other.tag)) return false;
    if (other.ignoreCollision.contains(super.tag)) return false;

    boolean ret = false;
    //check the other colliders type and call the corresponding collision function
    if (other.type() == ColliderType.Circle) {
      ret = collisionWithCircle((CircleCollider)other);
    } else if (other.type() == ColliderType.Rectangle) {
      ret = collisionWithRectangle((RectangleCollider)other);
    }
    return ret;
  }

  //handle collision with a circle collider
  // ----------------------------------------------------------------
  //   THIS FUNCTION WAS COPIED FROM THE INTERNET (jeffreythompson)
  // ----------------------------------------------------------------
  private boolean collisionWithCircle(CircleCollider other)
  {
    // temporary variables to set edges for testing
    //the circles position
    PVector cp = new PVector(other.pos().x, other.pos().y);
    //the closest edge to the circle
    PVector t = new PVector(cp.x, cp.y);
    
    //the rectangles position
    PVector rp = getRealPos();

    // which edge is closest?
    if (cp.x < rp.x)             t.x = rp.x;          // test left edge
    else if (cp.x > rp.x+size.x) t.x = rp.x+size.x;   // right edge
    if (cp.y < pos().y)          t.y = rp.y;          // top edge
    else if (cp.y > rp.y+size.y) t.y = rp.y+size.y;   // bottom edge

    // get distance from closest edges
    float distX = cp.x-t.x;
    float distY = cp.y-t.y;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    // if the distance is less than the radius, collision!
    if (distance <= other.r) {
      return true;
    }
    return false;
  }

  // ----------------------------------------------------------------
  //   THIS FUNCTION WAS COPIED FROM THE INTERNET (jeffreythompson)
  // ----------------------------------------------------------------
  private boolean collisionWithRectangle(RectangleCollider other)
  {
    //own position
    PVector p1 = getRealPos();
    //other position
    PVector p2 = other.getRealPos();
    //own size
    PVector s1 = size;
    //other size
    PVector s2 = other.size;

    if (p1.x + s1.x >= p2.x &&    // r1 right edge past r2 left
      p1.x <= p2.x + s2.x &&      // r1 left edge past r2 right
      p1.y + s1.y >= p2.y &&      // r1 top edge past r2 bottom
      p1.y <= p2.y + s2.y) {      // r1 bottom edge past r2 top
      return true;
    }
    return false;
  }

  //NOT IMPLEMENTED YET
  //(because not needed yet)
  public void checkWall()
  {
  }
  
  public void debug_show()
  {
    //just draw a rectangle with size and position
    rect(pos().x, pos().y, size.x, size.y);
  }
}
