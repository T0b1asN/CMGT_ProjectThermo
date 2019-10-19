//the Rigidbody interface
//this interface needs to be implemented, if the class wants to use a collider
//it provides functions needed by the Collider class and subclasses
interface Rigidbody
{
  //function that is called, if the Collider of the Rigidbody had a collision
  //it provides the other Collider for more information
  public void onCollision(Collider other);
  //function that is called, if the Collider of the Rigidbody had a collision
  //for now only works with CircleCollider
  public void onWall();
  
  //function that should be called on the Rigidbody, when it is up to be destroyed
  public void onDestroy();
  
  //returns the position of the Rigidbody
  public PVector getPos();
}
