//list of enemies
ArrayList<Enemy> enemies;
//how big should the enemy be
PVector enemySize;

//spawn timer (two timers for two spawn locations
float timerStart = 90, timer1 = 0, timerMinStart = 30;

//the spawn positions
PVector spawn1 = new PVector(), 
  spawn2 = new PVector(), 
  spawn3 = new PVector(), 
  spawn4 = new PVector();

//intialize the enemy handler
void initEnemyHandler()
{
  //set the timers
  timer1 = timerStart;
  
  //set the spawn positions
  spawn1.set(width/2f, 0);
  spawn2.set(width, height/2f);
  spawn3.set(width/2f, height);
  spawn4.set(0, height/2f);

  //set enemy size and initialize enemy list
  enemySize = new PVector(30, 30);
  enemies = new ArrayList<Enemy>();
  
  //call each spawn variation once, to have enemies on th field
  for(int i = 0; i < 4; i++) enemySpawn_random();
}

//handle the enemies
void handleEnemies()
{
  //move and show every enemy
  for (Enemy e : enemies)
  {
    e.move();
    e.show();
  }
  
  //show the healthbar of every enemy
  for (Enemy e : enemies)
  {
    e.showHealthBar();
  }
  
  //list of enemies that should be removed
  ArrayList<Enemy> found = new ArrayList<Enemy>();
  //iterate through all the enemies
  for (Enemy e : enemies)
  {
    if (e.isDead()) {
      //if the enemy should be deleted, delete it and call its onDestroy() function
      found.add(e);
      e.onDestroy();
    }
  }
  //remove all enemies up for deletion
  enemies.removeAll(found);

  //call the enemy timer
  enemyTimer();
}

void enemyTimer()
{
  //decrease timer1
  timer1--;
  if (timer1 <= 0)
  {
    //if the timer reached 0, reset it and spawn variation 1
    timer1 = timerStart;
    enemySpawn_random();
  }
  if(timerStart > timerMinStart)
    timerStart -= 0.01f;
}

void cleanupEnemies()
{
  for(Enemy e : enemies)
  {
    e.onDestroy();
  }
  enemies.clear();
}

String debug_getEnemyHandlerInfo()
{
  String info = "";
  info += "Enemy count: " + enemies.size();
  return info;
}

void enemySpawn_random()
{
  int r = (int)(random(1) * 4);
  PVector spawnPos = new PVector(0,0);
  if(r == 0) {
    spawnPos.x = random(-100f,width + 100f);
    spawnPos.y = -100f;
  } else if(r == 1) {
    spawnPos.x = width + 100f;
    spawnPos.y = random(-100f,height + 100f);
  } else if(r == 2) {
    spawnPos.y = height + 100f;
    spawnPos.x = random(-100f,width + 100f);
  } else if(r == 3) {
    spawnPos.x = -100f;
    spawnPos.y = random(-100f,height + 100f);
  } else {
    println("got value that was not expexted");
    return;
  }
  enemies.add(new Enemy(spawnPos, enemySize, 150f));
}
