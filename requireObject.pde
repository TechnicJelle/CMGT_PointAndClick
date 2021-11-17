class RequireObject extends TextObject {
  private Collectable collectable;
  private GameObject replaceWith;

  public RequireObject(String identifier, int x, int y, String gameObjectImageFile, String text, Collectable collectable, GameObject replaceWith) {
    super(identifier, x, y, gameObjectImageFile, text);
    this.collectable = collectable;
    this.replaceWith = replaceWith;
  }

  @Override
    public void mouseClicked() {
    if (mouseIsHovering && inventoryManager.containsCollectable(collectable) && inventoryManager.isSelected(collectable)) { //TODO: and has the correct item actually selected
      try {
        inventoryManager.removeCollectable(collectable);
      }
      catch(Exception e) {
        println(e);
      }
      sceneManager.getCurrentScene().removeGameObject(this);
      sceneManager.getCurrentScene().addGameObject(replaceWith);
    } else {
      super.mouseClicked();
    }
  }
}
