class GameObject {
  protected int x;
  protected int y;
  //protected int owidth;
  //protected int oheight;
  private String identifier;
  private boolean hasImage;
  private boolean hasHoverImage;
  private PImage gameObjectImage;
  private PImage gameObjectImageHover;
  protected boolean mouseIsHovering;
  
  public GameObject(String identifier, int x, int y) {
    this(identifier, x, y, "");
  }
  
  public GameObject(String identifier, int x, int y, String gameObjectImageFile) {
    this.identifier = identifier;
    this.x = x;
    this.y = y;
    //this.owidth = owidth;
    //this.oheight = oheight;
    this.hasImage = !gameObjectImageFile.equals(""); 
    if(this.hasImage) {
       this.gameObjectImage = loadImage(gameObjectImageFile);
    }
    hasHoverImage = false;
    mouseIsHovering = false;
  }
  
  public void setHoverImage(String gameObjectImageHoverFile) {
    this.gameObjectImageHover = loadImage(gameObjectImageHoverFile);
    hasHoverImage = true;
  }
  
  public void draw() {
    if(hasImage) {
      if(mouseIsHovering && hasHoverImage) {
        //imageMode(CENTER); I will not question, the buttons weren t working without it and now they do
        canvas.image(gameObjectImageHover, x, y);
      } else {
        canvas.image(gameObjectImage, x, y);
      }
    }
  }
  
  public void mouseMoved() {
    mouseIsHovering = false;
    if(dist(mouse.x, mouse.y, x, y ) < 100) {
        mouseIsHovering = true;
     }
  }
  
  public void mouseClicked() { }
  
  public String getIdentifier() {
    return this.identifier;
  }
  
  @Override 
  public boolean equals(Object obj) { 
    if (obj == this) { return true; } 
    if (obj == null || obj.getClass() != this.getClass()) { return false; } 
    GameObject otherGameObject = (GameObject) obj; 
    return otherGameObject.getIdentifier().equals(this.identifier);
  } 

  @Override 
  public int hashCode() { 
    final int prime = 11;
    return prime * this.identifier.hashCode();
  }
}
