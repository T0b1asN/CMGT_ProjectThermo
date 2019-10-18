ArrayList<Enemy> enemies;
PVector enemySize;

int timerMax = 360, timer1 = 0, timer2 = timerMax;

PVector spawn1 = new PVector(), 
  spawn2 = new PVector(), 
  spawn3 = new PVector(), 
  spawn4 = new PVector();

void initEnemyHandler()
{
  timer1 = timerMax/2; 
  timer2 = timerMax;
  spawn1.set(width/2f, 0);
  spawn2.set(width, height/2f);
  spawn3.set(width/2f, height);
  spawn4.set(0, height/2f);

  enemySize = new PVector(30, 30);
  enemies = new ArrayList<Enemy>();

  enemySpawn_Var1();
  enemySpawn_Var2();
}

void handleEnemies()
{
  for (Enemy e : enemies)
  {
    e.move();
    e.show();
  }
  
  for (Enemy e : enemies)
  {
    e.showHealthBar();
  }

  ArrayList<Enemy> found = new ArrayList<Enemy>();
  for (Enemy e : enemies)
  {
    if (e.isDead()) {
      found.add(e);
      e.onDestroy();
    } else {
      e.move();
      e.show();
    }
  }
  enemies.removeAll(found);

  enemyTimer();
}

void enemyTimer()
{
  timer1--;
  if (timer1 <= 0)
  {
    timer1 = timerMax;
    enemySpawn_Var1();
  }
  timer2--;
  if (timer2 <= 0)
  {
    timer2 = timerMax;
    enemySpawn_Var2();
  }
}

void enemySpawn_Var1()
{
  enemies.add(new Enemy(spawn1, enemySize, 150f));
  enemies.add(new Enemy(spawn3, enemySize, 150f));
}

void enemySpawn_Var2()
{
  enemies.add(new Enemy(spawn2, enemySize, 150f));
  enemies.add(new Enemy(spawn4, enemySize, 150f));
}
