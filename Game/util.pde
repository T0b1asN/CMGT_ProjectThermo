//utility function, to copy a vector
PVector copy(PVector original)
{
  return new PVector(original.x, original.y);
}

//check if the mouse is in a rectangle with the given position and size
boolean mouseInRect(PVector rectPos, PVector rectSize)
{
  return (mouseX > rectPos.x &&
    mouseX < rectPos.x + rectSize.x &&
    mouseY > rectPos.y &&
    mouseY < rectPos.y + rectSize.y);
}
