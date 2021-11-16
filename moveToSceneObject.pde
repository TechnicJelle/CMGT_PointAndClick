class MoveToSceneObject extends GameObject {
  
  private String nextSceneIdentifier;
  private boolean moveBack;
  
  public MoveToSceneObject(String identifier, int x, int y, boolean moveBack) {
    this(identifier, x, y, "", moveBack);
  }
  
  public MoveToSceneObject(String identifier, int x, int y, String gameObjectImageFile, boolean moveBack) {
    super(identifier, x, y, gameObjectImageFile);
    this.moveBack = moveBack;
  }
  
  public MoveToSceneObject(String identifier, int x, int y, String nextSceneIdentifier) {
    this(identifier, x, y, "", nextSceneIdentifier);
  }
  
  public MoveToSceneObject(String identifier, int x, int y, String gameObjectImageFile, String nextSceneIdentifier) {
    super(identifier, x, y, gameObjectImageFile);
    this.nextSceneIdentifier = nextSceneIdentifier;
    this.moveBack = false;
  }
  
  @Override
  public void mouseClicked() {
    if(mouseIsHovering) {
      if(moveBack) {
        sceneManager.goToPreviousScene();
      } else {
        try {
          sceneManager.goToScene(nextSceneIdentifier);
        } catch(Exception e) { 
          println(e.getMessage());
        }
      }
    }
  }
}
