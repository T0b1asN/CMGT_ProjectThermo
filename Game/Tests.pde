// only for tests, so no comments


public class RectCollTest implements Rigidbody
{
  PVector pos;
  String name;
  PVector size;
  float speed = 5f;
  
  RectangleCollider collider;
  
  public RectCollTest(PVector pos, PVector size, String name)
  {
    this.pos = pos;
    this.size = size;
    this.name = name;
    
    collider = new RectangleCollider(this, size);
  }
  
  public void show()
  {
    pushStyle();
    rect(pos.x, pos.y, size.x, size.y);
    pos.x += speed;
    popStyle();
    if(pos.x > width||pos.x < 0) speed = -speed;
  }
  
  public void onCollision(Collider other)
  {
    println(name+" had collision");
  }
  
  public void onWall()
  {
    
  }
  
  public PVector getPos()
  {
    return pos;
  }
  
  void onDestroy()
  {
    collider.onDestroy();
  }
}
