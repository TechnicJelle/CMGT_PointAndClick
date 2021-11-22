class Scene {
  private String sceneName;
  protected PImage backgroundImage;
  protected PImage minimapImage;
  private ArrayList<GameObject> gameObjects;

  private ArrayList<GameObject> recentlyAddedGameObjects;
  private ArrayList<GameObject> markedForDeathGameObjects;

  public Scene(String sceneName, String backgroundImageFile, String minimapImageFile) {
    this.sceneName = sceneName;
    this.backgroundImage = loadImage(backgroundImageFile);
    if (minimapImageFile != null) this.minimapImage = loadImage(minimapImageFile);
    gameObjects = new ArrayList<GameObject>();
    markedForDeathGameObjects = new ArrayList<GameObject>();
    recentlyAddedGameObjects = new ArrayList<GameObject>();
  }

  public void addGameObject(GameObject object) {
    recentlyAddedGameObjects.add(object);
  }

  public void removeGameObject(GameObject object) {
    markedForDeathGameObjects.add(object);
  }

  public void addTrash(GameObject object) {
    recentlyAddedGameObjects.add(object);
  }

  public void updateScene() {
    if (markedForDeathGameObjects.size() > 0) {
      for (GameObject object : markedForDeathGameObjects) {
        gameObjects.remove(object);
      }
      markedForDeathGameObjects  = new ArrayList<GameObject>();
    }
    if (recentlyAddedGameObjects.size() > 0) {
      for (GameObject object : recentlyAddedGameObjects) {
        gameObjects.add(object);
      }
      recentlyAddedGameObjects  = new ArrayList<GameObject>();
    }
  }

  public void draw() {
    canvas.image(backgroundImage, 0, 0);
    for (GameObject object : gameObjects) {
      object.draw();
    }
  }

  public void mouseMoved() {
    boolean hand = false;
    for (GameObject object : gameObjects) {
      if (object.mouseMoved()) {
        hand = true;
        //return;
      }
    }
    if (hand)
      setCursor(HAND);
    else
      setCursor(ARROW);
  }

  public void mouseClicked() {
    for (int i = gameObjects.size()-1; i >= 0; i--) {
      GameObject object = gameObjects.get(i);
      if (object.mouseClicked()) {
        if (debugMode) println("C: " + object.identifier);
        return;
      } else {
        if (debugMode) println("L: " + object.identifier);
      }
    }
  }

  public String getSceneName() {
    return this.sceneName;
  }
}
