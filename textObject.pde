class TextObject extends GameObject {
  private String text;
  private boolean displayText;
  private int millisAtLastShow;
  private int millisToShow = 2000;

  public TextObject(String identifier, float x, float y, String gameObjectImageFile, String text) {
    super(identifier, x, y, gameObjectImageFile);
    this.text = text;

    displayText = false;
    millisAtLastShow = 0;
  }

  public void draw(boolean drawOutline) {
    super.draw(drawOutline);
    if (displayText && millis() - millisAtLastShow >= millisToShow) {
      millisAtLastShow = millis();
      displayText = false;
    }

    if (displayText) {
      drawTextInRect(text, x, y);
    }
  }

  public boolean mouseClicked() {
    displayText = false;
    if (mouseIsHovering) {
      displayText = true;
      millisAtLastShow = millis();
      return true;
    }
    return false;
  }
}
