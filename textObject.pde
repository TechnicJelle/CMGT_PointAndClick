class TextObject extends GameObject {
  private String text;
  private boolean displayText;
  private int millisAtLastShow;
  private int millisToShow;
  private boolean singleUse;

  public TextObject(String identifier, float x, float y, String gameObjectImageFile, String text, int millisToShow) {
    super(identifier, x, y, gameObjectImageFile);
    this.text = text;

    displayText = false;
    millisAtLastShow = 0;
    this.millisToShow = millisToShow;
    singleUse = false;
  }

  public void draw() {
    super.draw();
    if (displayText && millis() - millisAtLastShow >= millisToShow) {
      hide();
      if (singleUse) {
        sceneManager.getCurrentScene().removeGameObject(this);
      }
    }

    if (displayText) {
      changeFontSize(48);
      drawTextInRect(text, x, y);
    }
  }

  public void show() {
    millisAtLastShow = millis();
    displayText = true;
  }

  public void hide() {
    displayText = false;
  }

  public void markForDeletion() {
    singleUse = true;
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
