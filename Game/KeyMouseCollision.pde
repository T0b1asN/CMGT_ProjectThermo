// ---------------------------------
//         KeyHandler
// ---------------------------------
boolean[] keys;
int keyCount = 4;
void initKeys()
{
  keys = new boolean[keyCount];
  for (int i = 0; i < keyCount; i++) keys[i] = false;
}

void handleKeys()
{
  //movement
  PVector move = new PVector();
  if (keys[KEYS.W.val]) move.y -= 1;
  if (keys[KEYS.A.val]) move.x -= 1;
  if (keys[KEYS.S.val]) move.y += 1;
  if (keys[KEYS.D.val]) move.x += 1;
  move.normalize();
  p.move(move);
}

void keyPressed()
{
  if (key == 'w' || key == 'W') keys[KEYS.W.val] = true;
  if (key == 'a' || key == 'A') keys[KEYS.A.val] = true;
  if (key == 's' || key == 'S') keys[KEYS.S.val] = true;
  if (key == 'd' || key == 'D') keys[KEYS.D.val] = true;
  
  if(key == 'c' || key == 'C') exit();
}

void keyReleased()
{
  if (key == 'w' || key == 'W') keys[KEYS.W.val] = false;
  if (key == 'a' || key == 'A') keys[KEYS.A.val] = false;
  if (key == 's' || key == 'S') keys[KEYS.S.val] = false;
  if (key == 'd' || key == 'D') keys[KEYS.D.val] = false;
}

enum KEYS
{
  W(0), A(1), S(2), D(3);
  
  public int val;
  private KEYS(int value) { this.val = value; }
}

// ---------------------------------------
//     MouseHandler
// ---------------------------------------
boolean mouse = false;

void mousePressed()
{
  p.onMouseDown();
  mouse = true;
}

void mouseReleased()
{
  mouse = false;
}

// ---------------------------------------
//      CollisionHandler
// ---------------------------------------
ArrayList<Collider> coll;

void initCollisions()
{
  coll = new ArrayList<Collider>();
}

void handleCollisions()
{
  for(int i = 0; i < coll.size(); i++)
  {
    for(int j = i+1; j < coll.size(); j++)
    {
      if(((Collider)coll.get(i)).isColliding((Collider)coll.get(j)))
      {
        ((Collider)coll.get(j)).notifyCollision();
      }
    }
    ((Collider)coll.get(i)).checkWall();
  }
}

void addCollider(Collider col)
{
  coll.add(col);
}

void removeCollider(Collider col)
{
  coll.remove(col);
}
