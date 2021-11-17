class TextObject extends GameObject {
  private String text;
  private boolean displayText;
  private float textWidth;
  private float textHeight;

  public TextObject(String identifier, int x, int y, String gameObjectImageFile, String text) {
    super(identifier, x, y, gameObjectImageFile);
    this.text = text;
    displayText = false;
    calculateTextArea(); //Automatically calculates the area 
    //necessary to display the entire text.
  }
  @Override
    public void draw() {
    super.draw();
    if (displayText) {
      canvas.fill(255);
      canvas.rect(this.x, this.y, textWidth + 30, textHeight, 8);
      canvas.fill(0);
      canvas.text(text, this.x + 15, this.y + 15, textWidth, textHeight);
    }
  }
  @Override
    public void mouseClicked() {
    displayText = false;
    if (mouseIsHovering) { 
      displayText = true;
    }
  }

  public void calculateTextArea() {
    textWidth = textWidth(text);
    float remaining = textWidth - 300;
    textWidth = (textWidth > 300) ? 300 : textWidth;
    textHeight = 50;
    while (remaining > 300)
    {
      textHeight += 30;
      remaining -= 300;
    }
  }
}
