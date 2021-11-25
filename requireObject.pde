class RequireObject extends TextObject {
  private Collectable[] collectables;
  private int collected;
  private GameObject replaceWith;

  PImage[] states;

  public RequireObject(String identifier, float x, float y, String gameObjectImageFile, String text, Collectable collectable, GameObject replaceWith) {
    super(identifier, x, y, gameObjectImageFile, text, 2000);
    try {
      init(new String[] {gameObjectImageFile, gameObjectImageFile}, new Collectable[] {collectable}, replaceWith);
    } 
    catch (Exception e) {
      println(e);
    }
  }

  public RequireObject(String identifier, float x, float y, String[] gameObjectImageFiles, String text, Collectable[] collectables, GameObject replaceWith) {
    super(identifier, x, y, gameObjectImageFiles[0], text, 2000);
    try {
      init(gameObjectImageFiles, collectables, replaceWith);
    } 
    catch (Exception e) {
      println(e);
    }
  }

  private void init(String[] gameObjectImageFiles, Collectable[] collectables, GameObject replaceWith) throws Exception {
    if ((gameObjectImageFiles.length) != (collectables.length+1)) {
      throw new Exception("gameObjectImageFiles.length is not the right length!");
    }

    states = new PImage[gameObjectImageFiles.length];
    collected = 0;
    for (int i = 0; i < states.length; i++) {
      states[i] = loadImage(gameObjectImageFiles[i]);
    }

    this.collectables = collectables;
    this.replaceWith = replaceWith;
  }

  @Override
    public boolean mouseClicked() {
    if (super.mouseClicked()) {
      if (collected < collectables.length) {
        for (int i = 0; i < collectables.length; i++) {
          Collectable collectable = collectables[i];

          if (inventoryManager.containsCollectable(collectable) && inventoryManager.isSelected(collectable)) {
            try {
              inventoryManager.removeCollectable(collectable);
            }
            catch(Exception e) {
              println(e); //couldn't remove collectable; should never happen
            }
            collected++;
            gameObjectImage = states[collected];
            if (debugMode) println("Collected: " + collected + "/" + collectables.length);
          }
        }
      } 
      if (collected == collectables.length) {
        sceneManager.getCurrentScene().addGameObject(replaceWith);
        sceneManager.getCurrentScene().removeGameObject(this);
      }
      if (collected == 0) {
        super.mouseClicked(); //show popup
      }
      return true;
    }
    return false;
  }
}
