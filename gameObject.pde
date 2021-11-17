class GameObject {
  protected int x;
  protected int y;
  protected int owidth;
  protected int oheight;
  private String identifier;
  private boolean hasImage;
  private boolean hasHoverImage;
  private PImage gameObjectImage;
  private PImage gameObjectImageHover;
  protected boolean mouseIsHovering;
  private color debugCol;

  public GameObject(String identifier, int x, int y) {
    this(identifier, x, y, "");
  }

  public GameObject(String identifier, int x, int y, String gameObjectImageFile) {
    this.identifier = identifier;
    this.x = x;
    this.y = y;
    this.hasImage = !gameObjectImageFile.equals(""); 
    if (this.hasImage) {
      this.gameObjectImage = loadImage(gameObjectImageFile);
      this.owidth = gameObjectImage.width;
      this.oheight = gameObjectImage.height;
      this.debugCol = color(random(100, 255), random(100, 255), random(100, 255));
    }
    hasHoverImage = false;
    mouseIsHovering = false;
  }

  public void setHoverImage(String gameObjectImageHoverFile) throws Exception {
    PImage newHoverImage = loadImage(gameObjectImageHoverFile);
    if (newHoverImage.width == gameObjectImage.width && newHoverImage.height == gameObjectImage.height) {
      this.gameObjectImageHover = newHoverImage;
      hasHoverImage = true;
    } else {
      throw new Exception("Images were not the same size!");
    }
  }

  public void draw() {
    if (hasImage) {
      if (mouseIsHovering && hasHoverImage) {
        canvas.image(gameObjectImageHover, x, y);
      } else {
        canvas.image(gameObjectImage, x, y);
        if (debugMode) {
          canvas.stroke(debugCol);
          canvas.strokeWeight(1);
          canvas.noFill();
          canvas.rect(x, y, owidth, oheight);
        }
      }
    }
  }

  public void mouseMoved() {
    mouseIsHovering = pointInRect(mouse.x, mouse.y, x, y, owidth, oheight);
  }

  public void mouseClicked() {
  }

  public String getIdentifier() {
    return this.identifier;
  }

  @Override 
    public boolean equals(Object obj) { 
    if (obj == this) { 
      return true;
    } 
    if (obj == null || obj.getClass() != this.getClass()) { 
      return false;
    } 
    GameObject otherGameObject = (GameObject) obj; 
    return otherGameObject.getIdentifier().equals(this.identifier);
  } 

  @Override 
    public int hashCode() { 
    final int prime = 11;
    return prime * this.identifier.hashCode();
  }
}
