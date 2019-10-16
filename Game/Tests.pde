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

public class PolygonCollTest implements Rigidbody
{
  PVector pos;
  String name;
  PVector[] verts;
  
  PolygonCollider collider;
  
  public PolygonCollTest(PVector pos, String name)
  {
    this.pos = pos;
    this.name = name;
    
    verts = new PVector[8];
    verts[0] = new PVector(500, 100);
    verts[1] = new PVector(550, 50);
    verts[2] = new PVector(600, 100);
    verts[3] = new PVector(650, 150);
    verts[4] = new PVector(600, 200);
    verts[5] = new PVector(550, 250);
    verts[6] = new PVector(500, 200);
    verts[7] = new PVector(450, 150);
    
    collider = new PolygonCollider(this, verts);
  }
  
  public void show()
  {
    pushStyle();
    beginShape();
    for(int i = 0; i < verts.length; i++)
    {
      vertex(verts[i].x, verts[i].y);
    }
    endShape(CLOSE);
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
