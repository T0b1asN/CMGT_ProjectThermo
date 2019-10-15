public class RectCollTest implements Rigidbody
{
  PVector pos;
  String name;
  PVector size;
  
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
    popStyle();
  }
  
  public void onCollision()
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
}