class MoveToSceneObject extends GameObject {

  private String nextSceneIdentifier;
  private boolean moveBack;

  public MoveToSceneObject(String identifier, float x, float y, boolean moveBack) {
    this(identifier, x, y, "", moveBack);
  }

  public MoveToSceneObject(String identifier, float x, float y, String gameObjectImageFile, boolean moveBack) {
    super(identifier, x, y, gameObjectImageFile);
    this.moveBack = moveBack;
  }

  public MoveToSceneObject(String identifier, float x, float y, String nextSceneIdentifier) {
    this(identifier, x, y, "", nextSceneIdentifier);
  }

  public MoveToSceneObject(String identifier, float x, float y, String gameObjectImageFile, String nextSceneIdentifier) {
    super(identifier, x, y, gameObjectImageFile);
    this.nextSceneIdentifier = nextSceneIdentifier;
    this.moveBack = false;
  }

  @Override
    public boolean mouseClicked() {
    if (mouseIsHovering) {
      if (moveBack) {
        sceneManager.goToPreviousScene();
      } else {
        try {
          sceneManager.goToScene(nextSceneIdentifier);
        } 
        catch(Exception e) { 
          println(e.getMessage());
        }
      }
      return true;
    }
    return false;
  }
}
