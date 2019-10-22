public class Button implements MouseEnabled
{
  //button position
  PVector pos;
  //button size
  PVector size;
  
  //text on the button
  String text;
  //size for text on button
  int textSize = 32;
  
  //the id of the button
  String buttonID;
  
  //color if no hover
  color normalColor = color(255);
  //color if hover
  color highlightColor = color(200);
  //color for text on button
  color textColor = color(0);
  
  //the parent for callbacks
  ButtonEnabled parent;
  
  //consrtuctor with parent, id, position and size
  public Button(ButtonEnabled parent, String buttonID, PVector pos, PVector size)
  {
    //set all the given values (text gets default value)
    this.parent = parent;
    this.buttonID = buttonID;
    this.text = "Button";
    this.pos = copy(pos);
    this.size = copy(size);
    //add itself to mouse callback list
    addMouseEnabled(this);
  }
  
  //readd itself to mouse callback list (no error checking, dont do twice without removing)
  public void resetMouseEnabled()
  {
    addMouseEnabled(this);
  }
  
  //most functions here return the Button instance so you can chain function calls
  
  //set the color for no hover
  Button setNormalC(color c)
  {
    normalColor = c;
    return this;
  }
  
  //set color for hover
  Button setHighlightC(color c)
  {
    highlightColor = c;
    return this;
  }
  
  //set text on the button
  Button setText(String text)
  {
    this.text = text;
    return this;
  }
  
  //set size of text on the button
  Button setTextSize(int textSize)
  {
    this.textSize = textSize;
    return this;
  }
  
  //set color of text on the button
  Button setTextC(color c)
  {
    this.textColor = c;
    return this;
  }
  
  //mouse click callback
  public void onMouseClick()
  {
    if(parent.isEnabled() && mouseInRect(pos, size))
    {
      //if the parent accepts button clicked callbacks and the mouse is over the button
      //  call the parents onButtonClick function with the correct id
      parent.onButtonClick(buttonID);
    }
  }
  
  //show the button
  public void show()
  {
    pushStyle();
    //check if the mouse hovers over the button and choose the correct color
    if(mouseInRect(pos, size))
      fill(highlightColor);
    else
      fill(normalColor);
    noStroke();
    //draw a rect
    rect(pos.x, pos.y, size.x, size.y);
    
    //draw the text in the correct color and size
    textAlign(CENTER);
    textSize(textSize);
    fill(textColor);
    text(text, pos.x + size.x/2f, pos.y + size.y/2f + textSize/2f);
    popStyle();
  }
}
