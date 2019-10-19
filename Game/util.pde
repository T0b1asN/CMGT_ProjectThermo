//utility function, to copy a vector
PVector copy(PVector original)
{
  return new PVector(original.x, original.y);
}

boolean mouseInRect(PVector rectPos, PVector rectSize)
{
  return (mouseX > rectPos.x &&
    mouseX < rectPos.x + rectSize.x &&
    mouseY > rectPos.y &&
    mouseY < rectPos.y + rectSize.y);
}
