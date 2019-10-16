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

  void onDestroy()
  {
    removeCollider(this);
  }
}

public enum ColliderType
{
  Circle, Rectangle, Polygon
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
}

public class PolygonCollider extends Collider
{
  PVector[] points;

  public PolygonCollider(Rigidbody parent, PVector[] points) 
  {
    super(parent, "");
    this.points = points;
  }

  public PolygonCollider(Rigidbody parent, PVector[] points, String tag) 
  {
    super(parent, tag);
    this.points = points;
  }

  public ColliderType type() { 
    return ColliderType.Polygon;
  }

  public boolean isColliding(Collider other)
  {
    if(other.type() == ColliderType.Circle) return collisionWithCircle((CircleCollider)other);
    return false;
  }

  boolean collisionWithCircle(CircleCollider other)
  {
    // go through each of the vertices, plus
    // the next vertex in the list
    int next = 0;
    for (int current=0; current<points.length; current++) {

      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == points.length) next = 0;

      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = PVector.add(pos(), points[current]);    // c for "current"
      PVector vn = PVector.add(pos(), points[next]);       // n for "next"

      // check for collision between the circle and
      // a line formed between the two vertices
      boolean collision = lineCircle(vc.x, vc.y, vn.x, vn.y, other.pos().x, other.pos().y, other.r);
      if (collision) return true;
    }

    // the above algorithm only checks if the circle
    // is touching the edges of the polygon – in most
    // cases this is enough, but you can un-comment the
    // following code to also test if the center of the
    // circle is inside the polygon

    // boolean centerInside = polygonPoint(vertices, cx,cy);
    // if (centerInside) return true;

    // otherwise, after all that, return false
    return false;
  }

  public void checkWall()
  {
  }
}
//-----------------------
//      helper
//-----------------------

boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

  // get distance from the point to the two ends of the line
  float d1 = dist(px, py, x1, y1);
  float d2 = dist(px, py, x2, y2);

  // get the length of the line
  float lineLen = dist(x1, y1, x2, y2);

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  float buffer = 0.1;    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range, rather
  // than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}

boolean lineCircle(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

  // is either end INSIDE the circle?
  // if so, return true immediately
  boolean inside1 = pointCircle(x1, y1, cx, cy, r);
  boolean inside2 = pointCircle(x2, y2, cx, cy, r);
  if (inside1 || inside2) return true;

  // get length of the line
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // get dot product of the line and circle
  float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len, 2);

  // find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
  if (!onSegment) return false;

  // optionally, draw a circle at the closest point
  // on the line
  fill(255, 0, 0);
  noStroke();
  ellipse(closestX, closestY, 20, 20);

  // get distance to closest point
  distX = closestX - cx;
  distY = closestY - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // is the circle on the line?
  if (distance <= r) {
    return true;
  }
  return false;
}

// POINT/CIRCLE
boolean pointCircle(float px, float py, float cx, float cy, float r) {

  // get distance between the point and circle's center
  // using the Pythagorean Theorem
  float distX = px - cx;
  float distY = py - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // if the distance is less than the circle's 
  // radius the point is inside!
  if (distance <= r) {
    return true;
  }
  return false;
}


// POLYGON/POINT
// only needed if you're going to check if the circle
// is INSIDE the polygon
boolean polygonPoint(PVector[] vertices, float px, float py) {
  boolean collision = false;

  // go through each of the vertices, plus the next
  // vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = vertices[current];    // c for "current"
    PVector vn = vertices[next];       // n for "next"

    // compare position, flip 'collision' variable
    // back and forth
    if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
      (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
      collision = !collision;
    }
  }
  return collision;
}
