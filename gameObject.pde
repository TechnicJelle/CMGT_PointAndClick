class GameObject {
  protected float x;
  protected float y;
  protected int owidth;
  protected int oheight;
  private String identifier;
  private boolean hasImage;
  private boolean hasHoverImage;
  private boolean isQuad;
  private PImage gameObjectImage;
  private PImage gameObjectImageHover;
  private Quad quad;
  protected boolean mouseIsHovering;
  private color debugCol;

  public GameObject(String identifier, float x, float y) {
    this(identifier, x, y, "");
  }

  private void init(String identifier, String gameObjectImageFile) {
    this.identifier = identifier;
    this.hasImage = !gameObjectImageFile.equals(""); 
    if (this.hasImage) {
      this.gameObjectImage = loadImage(gameObjectImageFile);
      this.owidth = gameObjectImage.width;
      this.oheight = gameObjectImage.height;
    }
    this.debugCol = color(random(100, 255), random(100, 255), random(100, 255));
    hasHoverImage = false;
    isQuad = false;
    mouseIsHovering = false;
  }

  public GameObject(String identifier, float x, float y, String gameObjectImageFile, boolean center) {
    init(identifier, gameObjectImageFile);
    if (center) {
      this.x = x - gameObjectImage.width/2;
      this.y = y - gameObjectImage.height/2;
    }
  }

  public GameObject(String identifier, float x, float y, String gameObjectImageFile) {
    init(identifier, gameObjectImageFile);
    this.x = x;
    this.y = y;
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

  public void setQuad(Quad q) {
    quad = q;
    isQuad = true;
  }

  public void setQuad(float ax, float ay, float bx, float by, float cx, float cy, float dx, float dy) {
    PVector a = new PVector(ax, ay);
    PVector b = new PVector(bx, by);
    PVector c = new PVector(cx, cy);
    PVector d = new PVector(dx, dy);
    Quad q = new Quad(a, b, c, d);
    this.setQuad(q);
  }

  public void draw() {
    if (hasImage) {
      if (mouseIsHovering && hasHoverImage) {
        canvas.image(gameObjectImageHover, x, y);
      } else {
        canvas.image(gameObjectImage, x, y);
      }
    }
    if (debugMode) {
      canvas.stroke(mouseIsHovering ? 255 : debugCol);
      canvas.strokeWeight(1);
      canvas.noFill();
      if (isQuad) {
        quad.drawDebug();
      } else {
        canvas.rect(x, y, owidth, oheight);
      }
    }
  }

  public void mouseMoved() {
    mouseIsHovering = pointInGameObject(mouse);
  }

  public boolean pointInGameObject(PVector point) {
    if (isQuad) {
      return quad.pointCheck(point);
    } else {
      return pointInRect(point.x, point.y, x, y, owidth, oheight);
    }
  }

  public boolean mouseClicked() {
    return mouseIsHovering;
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
