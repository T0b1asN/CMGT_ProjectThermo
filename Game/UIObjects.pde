public class Button implements MouseEnabled
{
  PVector pos;
  PVector size;
  
  String text;
  int textSize = 32;
  
  String buttonID;
  
  color normalColor = color(255);
  color highlightColor = color(200);
  
  ButtonEnabled parent;
  
  public Button(ButtonEnabled parent, String buttonID, PVector pos, PVector size)
  {
    this.parent = parent;
    this.buttonID = buttonID;
    this.text = "Button";
    this.pos = copy(pos);
    this.size = copy(size);
    
    addMouseEnabled(this);
  }
  
  public void resetMouseEnabled()
  {
    addMouseEnabled(this);
  }
  
  Button setNormalC(color c)
  {
    normalColor = c;
    return this;
  }
  
  Button setHighlightC(color c)
  {
    highlightColor = c;
    return this;
  }
  
  Button setText(String text)
  {
    this.text = text;
    return this;
  }
  
  Button setTextSize(int textSize)
  {
    this.textSize = textSize;
    return this;
  }
  
  public void onMouseClick()
  {
    if(parent.isEnabled() && mouseInRect(pos, size))
    {
      parent.onButtonClick(buttonID);
    }
  }
  
  public void show()
  {
    pushStyle();
    if(mouseInRect(pos, size))
      fill(highlightColor);
    else
      fill(normalColor);
    noStroke();
    rect(pos.x, pos.y, size.x, size.y);
    
    //text
    textAlign(CENTER);
    textSize(textSize);
    fill(0);
    text(text, pos.x + size.x/2f, pos.y + size.y/2f + textSize/2f);
    popStyle();
  }
}
