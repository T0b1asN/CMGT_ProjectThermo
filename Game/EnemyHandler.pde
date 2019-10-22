//list of enemies
ArrayList<Enemy> enemies;
//how big should the enemy be
PVector enemySize;

//spawn timer (two timers for two spawn locations
float timerStart = 90, timer1 = 0, timerMinStart = 30;

//intialize the enemy handler
void initEnemyHandler()
{
  //set the timers
  timer1 = timerStart;

  //set enemy size and initialize enemy list
  enemySize = new PVector(30, 30);
  enemies = new ArrayList<Enemy>();
  
  //spawn some random enemies in the beginning
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
    //if the timer reached 0, reset it and spawn a random enemy
    timer1 = timerStart;
    enemySpawn_random();
  }
  //if the timer max value is not to low, decrease it to spawn more enemies as the game progresses
  if(timerStart > timerMinStart)
    timerStart -= 0.01f;
}

//clean up all the enemies, so that the game can safely be restarted
void cleanupEnemies()
{
  //call on destroy for every enemy, so that it can safely be destroyed
  for(Enemy e : enemies)
  {
    e.onDestroy();
  }
  //clear the enemies array list
  enemies.clear();
}

//info about the enemy handler
String debug_getEnemyHandlerInfo()
{
  String info = "";
  info += "Enemy count: " + enemies.size();
  return info;
}

//spawn an enemy at a random position on the edge of the screen
void enemySpawn_random()
{
  int r = (int)(random(1) * 4);
  PVector spawnPos = new PVector(0,0);
  //choose a random edge of the screen and create a new point somewhere randomly on there
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
  //instantiate a new enemy on the new found point
  enemies.add(new Enemy(spawnPos, enemySize, 150f));
}
