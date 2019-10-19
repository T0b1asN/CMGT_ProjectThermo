//list of enemies
ArrayList<Enemy> enemies;
//how big should the enemy be
PVector enemySize;

//spawn timer (two timers for two spawn locations
int timerMax = 360, timer1 = 0, timer2 = timerMax;

//the spawn positions
PVector spawn1 = new PVector(), 
  spawn2 = new PVector(), 
  spawn3 = new PVector(), 
  spawn4 = new PVector();

//intialize the enemy handler
void initEnemyHandler()
{
  //set the timers
  timer1 = timerMax/2; 
  timer2 = timerMax;
  
  //set the spawn positions
  spawn1.set(width/2f, 0);
  spawn2.set(width, height/2f);
  spawn3.set(width/2f, height);
  spawn4.set(0, height/2f);

  //set enemy size and initialize enemy list
  enemySize = new PVector(30, 30);
  enemies = new ArrayList<Enemy>();
  
  //call each spawn variation once, to have enemies on th field
  enemySpawn_Var1();
  enemySpawn_Var2();
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
    timer1 = timerMax;
    enemySpawn_Var1();
  }
  //decrease timer2
  timer2--;
  if (timer2 <= 0)
  {
    //if the timer reached 0, reset it and spawn variation 2
    timer2 = timerMax;
    enemySpawn_Var2();
  }
}

//spawn variation 1
void enemySpawn_Var1()
{
  //spawn an enemy each in spawn point 1 and 3
  enemies.add(new Enemy(spawn1, enemySize, 150f));
  enemies.add(new Enemy(spawn3, enemySize, 150f));
}

//spawn variation 2
void enemySpawn_Var2()
{
  //spawn an enemy each in spawn point 2 and 4
  enemies.add(new Enemy(spawn2, enemySize, 150f));
  enemies.add(new Enemy(spawn4, enemySize, 150f));
}
