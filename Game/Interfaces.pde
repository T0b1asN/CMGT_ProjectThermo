interface Rigidbody
{
  public void onCollision(Collider other);
  public void onWall();
  
  public PVector getPos();
}
