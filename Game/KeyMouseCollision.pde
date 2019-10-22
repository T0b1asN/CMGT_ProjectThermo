// ---------------------------------
//         KeyHandler
// ---------------------------------
//the array of keys used in the program
boolean[] keys;
//the amount of keys used
int keyCount = 4;
//initialize the keyhandling
void initKeys()
{
  //initialize the keys array
  keys = new boolean[keyCount];
  //set all values of the keys array to false, since no key has been pressed yet
  for (int i = 0; i < keyCount; i++) keys[i] = false;
}

//handle the keyboard input, that has been saved in the keys array
void handleKeys()
{
  //movement
  //create a new movement vector
  PVector move = new PVector();
  //if the W key has been pressed, the player should move up and y should decrease
  if (keys[KEYS.W.val]) move.y -= 1;
  //if the A key has been pressed, the player should move left and x should decrease
  if (keys[KEYS.A.val]) move.x -= 1;
  //if the S key has been pressed, the player should move down and y should increase
  if (keys[KEYS.S.val]) move.y += 1;
  //if the D key has beed pressed, the player should move right and x should increase
  if (keys[KEYS.D.val]) move.x += 1;
  //normalize the movement, so that the player can't move faster diagonally
  move.normalize();
  //call the players move function with the calculated movement
  game.getP().move(move);
}

//called for every key pressed
void keyPressed()
{
  //ckeck if a specific key has been pressed, if yes set the
  //corresponding element in the keys array to true
  if (key == 'w' || key == 'W') keys[KEYS.W.val] = true;
  if (key == 'a' || key == 'A') keys[KEYS.A.val] = true;
  if (key == 's' || key == 'S') keys[KEYS.S.val] = true;
  if (key == 'd' || key == 'D') keys[KEYS.D.val] = true;
  //if the c key has been pressed, exit the application
  if(key == 'c' || key == 'C') exit();
}

void keyReleased()
{
  //ckeck if a specific key has been released, if yes set the
  //corresponding element in the keys array to true
  if (key == 'w' || key == 'W') keys[KEYS.W.val] = false;
  if (key == 'a' || key == 'A') keys[KEYS.A.val] = false;
  if (key == 's' || key == 'S') keys[KEYS.S.val] = false;
  if (key == 'd' || key == 'D') keys[KEYS.D.val] = false;
}

//the enum to interact with the keys array
//this can be used to avoid hard coded values
enum KEYS
{
  W(0), A(1), S(2), D(3);
  
  public int val;
  private KEYS(int value) { this.val = value; }
}

// ---------------------------------------
//     MouseHandler
// ---------------------------------------
//is the mouse button currently pressed down
boolean mouse = false;
//mouseX and mouseY as a vector to avoid unnecessary creation of vectors
//when calculating stuff with the mouse position
PVector mouseVec;

//the list of MouseEnabled objects wanting a callback, when the mouse is pressed
ArrayList<MouseEnabled> mEnabled;

//initialize mouse handling by creating mouseVec and initializing the mEnabled list
void initMouse()
{
  mouseVec = new PVector(mouseX, mouseY);
  mEnabled = new ArrayList<MouseEnabled>();
}

//handle mouse input by setting the mouseVec to mouseX and mouseY
void handleMouse()
{
  mouseVec.set(mouseX, mouseY);
}

//called when the mouse is pressed down
void mousePressed()
{
  //notify the player
  for(MouseEnabled m : mEnabled) m.onMouseClick();
  //p.onMouseClick();
  //set mouse to true
  mouse = true;
}

//add a MouseEnabled object to the mEnabled list
void addMouseEnabled(MouseEnabled m)
{
  mEnabled.add(m);
}

//remove a MouseEnabled object from the mEnabled list
void removeMouseEnabled(MouseEnabled m)
{
  mEnabled.remove(m);
}

//called when the mouse is released
void mouseReleased()
{
  //set mouse to false
  mouse = false;
}

// ---------------------------------------
//      CollisionHandler
// ---------------------------------------
//the list of all colliders that want to take part in collision handling
ArrayList<Collider> col;

//should the debug view of colliders be drawn
boolean debug_showHitboxes = false;

//initialize collision handling
void initCollisions()
{
  //initialize the list of colliders
  col = new ArrayList<Collider>();
}

//handle all of the collisions
void handleCollisions()
{
  //iterate through all colliders
  for(int i = 0; i < col.size(); i++)
  {
    //iterate through all colliders after the iterator of the outer loop
    for(int j = i+1; j < col.size(); j++)
    {
      //check if the two colliders at the two iterator positions are colliding
      if(((Collider)col.get(i)).isColliding((Collider)col.get(j)))
      {
        //get the two colliders taking part in the collision
        Collider left = (Collider)col.get(i);
        Collider right = (Collider)col.get(j);
        //notify the two colliders of the collision
        left.notifyCollision(right);
        right.notifyCollision(left);
      }
    }
    //for each collider check the wall
    ((Collider)col.get(i)).checkWall();
  }
}

//debug view of the colliders
void debugCollisions()
{
  //if the game is not in debug mode, return
  if(!debug_showHitboxes) return;
  
  //if the game is in debug mode, set the style for the collider display
  pushStyle();
  noFill();
  stroke(255,0,0);
  strokeWeight(5);
  for(Collider c : col)
  {
    //call the function to draw debug view from every collider
    c.debug_show();
  }
  popStyle();
}

//add a collider to collision handling
void addCollider(Collider col)
{
  this.col.add(col);
}

//remove a collider from collision handling
void removeCollider(Collider col)
{
  this.col.remove(col);
}

//info about the collision handler
String debug_getCollisionHandlingInfo()
{
  String info = "";
  info += "Active collider: " + col.size();
  return info;
}
