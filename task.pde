class Task extends Scene {
  protected MoveToSceneObject sceneStarter;
  protected GameObject replaceWith;
  protected String description;
  public boolean completed;
  protected PVector minimapLocation;
  protected PImage minimapIcon;

  private int scoreAdd;

  Task(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc, PVector minimapLocation, PImage minimapIcon, int sa) {
    super(sceneName, backgroundImageFile, null);
    this.sceneStarter = sceneStarter;
    this.replaceWith = replaceWith;
    description = desc;
    completed = false;
    taskTracker.addTask(this);
    this.minimapLocation = minimapLocation;
    this.minimapIcon = minimapIcon;
    scoreAdd = sa;
    scoreMax += scoreAdd;
  }

  void setup() {
  }

  void draw() {
  }

  void done() {
    sceneManager.goToPreviousScene();
    sceneManager.getCurrentScene().removeGameObject(sceneStarter);
    if (replaceWith != null)
      sceneManager.getCurrentScene().addGameObject(replaceWith);
    completed = true;
    score += scoreAdd;
  }

  void mouseMoved() {
  }

  void mouseClicked() {
  }
}
