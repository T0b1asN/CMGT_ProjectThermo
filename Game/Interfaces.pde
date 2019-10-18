interface Rigidbody
{
  public void onCollision(Collider other);
  public void onWall();
  
  public void onDestroy();
  
  public PVector getPos();
}
