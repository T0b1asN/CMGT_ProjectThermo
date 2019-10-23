

public class HighscoreHandler
{
  final static String fileName = "highscores.txt";
  
  ArrayList<Highscore> highscores;
  
  class Highscore
  {
    public String name;
    public int score;
    
    public Highscore(String name, int score)
    {
      this.name = name;
      this.score = score;
    }
    
    public Highscore(String entry)
    {
      String[] split = entry.split("#");
      if(split.length > 2) println("making highscore from too many arguments");
      if(split.length < 2) 
      {
        println("Error: too little arguments for highscore");
        return;
      }
      this.name = split[0];
      this.score = Integer.parseInt(split[1]);
    }
    
    public String toString()
    {
      return name + "#" + score;
    }
  }
  
  public HighscoreHandler()
  {
    highscores = new ArrayList<Highscore>();
  }
  
  void readHighscores()
  {
    String[] lines = loadStrings(fileName);
    for(int i = 0; i < lines.length; i++)
    {
      //println(lines[i]);
      highscores.add(new Highscore(lines[i]));
    }
  }
  
  void writeHighscores()
  {
    String[] scores = new String[highscores.size()];
    int i = 0;
    for(Highscore h : highscores)
    {
      scores[i] = h.toString();
      i++;
    }
    saveStrings(fileName, scores);
  }
}
