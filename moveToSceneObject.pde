class MoveToSceneObject extends GameObject {

  private String nextSceneIdentifier;
  private boolean moveBack;
  private int backAmount = -1;
  private String afterWardsGoToScene = ""; 

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
  public void setBackAmount(int n) {
    backAmount = n;
  }

  public void setAfterwardsScene(String afws) {
    afterWardsGoToScene = afws;
  }

  @Override
    public boolean mouseClicked() {
    if (super.mouseClicked()) {
      if (moveBack) {
        if (backAmount != -1) sceneManager.goToPreviousScene(backAmount);
        else sceneManager.goToPreviousScene();
      } else {
        try {
          sceneManager.goToScene(nextSceneIdentifier);
        } 
        catch(Exception e) { 
          println(e.getMessage());
        }
      }
      if (!afterWardsGoToScene.equals("")) {
        try {
          sceneManager.goToScene(afterWardsGoToScene);
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
