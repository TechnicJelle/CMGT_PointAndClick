class Task extends Scene {
  protected MoveToSceneObject sceneStarter;
  protected GameObject replaceWith;
  protected String description;
  public boolean completed;

  Task(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc) {
    super(sceneName, backgroundImageFile, null);
    this.sceneStarter = sceneStarter;
    this.replaceWith = replaceWith;
    description = desc;
    completed = false;
  }

  void setup() {
  }

  void draw() {
  }

  void done() {
    cursor(ARROW);
    sceneManager.goToPreviousScene();
    sceneManager.getCurrentScene().removeGameObject(sceneStarter);
    if (replaceWith != null)
      sceneManager.getCurrentScene().addGameObject(replaceWith);
    completed = true;
  }

  void mouseMoved() {
  }

  void mouseClicked() {
  }
}
