public abstract class Collider
{
  protected Collider(Rigidbody parent, String tag)
  {
    this.parent = parent;
    this.tag = tag;

    ignoreCollision = new ArrayList<String>();

    addCollider(this);
  }
  private Rigidbody parent;

  private String tag;

  ArrayList<String> ignoreCollision;

  public abstract ColliderType type();
  public abstract boolean isColliding(Collider other);
  public abstract void checkWall();

  public abstract void onDestroy();

  public void ignoreCollision(String tag)
  {
    ignoreCollision.add(tag);
  }

  public void notifyCollision()
  {
    parent.onCollision();
  }

  public PVector pos()
  {
    return parent.getPos();
  }
}

public enum ColliderType
{
  Circle, Rectangle
}

public class CircleCollider extends Collider
{
  float r;

  public CircleCollider(Rigidbody parent, float r) 
  {
    super(parent, "");
    this.r = r;
  }

  public CircleCollider(Rigidbody parent, float r, String tag) 
  {
    super(parent, tag);
    this.r = r;
  }

  public ColliderType type() { 
    return ColliderType.Circle;
  }

  public boolean isColliding(Collider other)
  {
    if (super.ignoreCollision.contains(other.tag)) return false;
    if (other.ignoreCollision.contains(super.tag)) return false;

    boolean ret = false;
    if (other.type() == ColliderType.Circle) {
      ret = collisionWithCircle((CircleCollider)other);
    } else if (other.type() == ColliderType.Rectangle) {
      ret = collisionWithRectangle((RectangleCollider)other);
    }
    if (ret)
    {
      notifyCollision();
    }
    return ret;
  }

  private boolean collisionWithCircle(CircleCollider other)
  {
    if (pos().dist(other.pos()) < r + other.r)
      return true;
    return false;
  }

  private boolean collisionWithRectangle(RectangleCollider other)
  {
    return other.collisionWithCircle(this);
  }

  public void checkWall()
  {
    if (pos().x < r || pos().x > width) super.parent.onWall();
    if (pos().y < r || pos().y > height) super.parent.onWall();
  }

  void onDestroy()
  {
    removeCollider(this);
  }
}

public class RectangleCollider extends Collider
{
  PVector size;

  public RectangleCollider(Rigidbody parent, PVector size)
  {
    super(parent, "");
    this.size = size;
  }

  public RectangleCollider(Rigidbody parent, PVector size, String tag)
  {
    super(parent, tag);
    this.size = size;
  }

  PVector getRealPos()
  {
    return pos();
    //return new PVector(pos().x - size.x / 2f, pos().y - size.y / 2f);
  }

  public ColliderType type() { 
    return ColliderType.Rectangle;
  }

  public boolean isColliding(Collider other)
  {
    if (super.ignoreCollision.contains(other.tag)) return false;
    if (other.ignoreCollision.contains(super.tag)) return false;

    boolean ret = false;
    if (other.type() == ColliderType.Circle) {
      ret = collisionWithCircle((CircleCollider)other);
    } else if (other.type() == ColliderType.Rectangle) {
      ret = collisionWithRectangle((RectangleCollider)other);
    }
    if (ret)
    {
      notifyCollision();
    }
    return ret;
  }

  private boolean collisionWithCircle(CircleCollider other)
  {
    // temporary variables to set edges for testing
    PVector cp = new PVector(other.pos().x, other.pos().y);
    PVector t = new PVector(cp.x, cp.y);

    PVector rp = getRealPos();

    // which edge is closest?
    if (cp.x < rp.x)         t.x = rp.x;      // test left edge
    else if (cp.x > rp.x+size.x) t.x = rp.x+size.x;   // right edge
    if (cp.y < pos().y)         t.y = rp.y;      // top edge
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

  private boolean collisionWithRectangle(RectangleCollider other)
  {
    PVector p1 = getRealPos();
    PVector p2 = other.getRealPos();
    PVector s1 = size;
    PVector s2 = other.size;
    
    if (p1.x + s1.x >= p2.x &&    // r1 right edge past r2 left
      p1.x <= p2.x + s2.x &&    // r1 left edge past r2 right
      p1.y + s1.y >= p2.y &&    // r1 top edge past r2 bottom
      p1.y <= p2.y + s2.y) {    // r1 bottom edge past r2 top
      return true;
    }
    return false;
  }

  public void checkWall()
  {
  }

  public void onDestroy()
  {
  }
}
