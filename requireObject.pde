class RequireObject extends TextObject {
  private Collectable collectable;
  private GameObject replaceWith;

  public RequireObject(String identifier, float x, float y, String gameObjectImageFile, String text, Collectable collectable, GameObject replaceWith) {
    super(identifier, x, y, gameObjectImageFile, text);
    this.collectable = collectable;
    this.replaceWith = replaceWith;
  }

  @Override
    public boolean mouseClicked() {
    if (mouseIsHovering) {
      if (inventoryManager.containsCollectable(collectable) && inventoryManager.isSelected(collectable)) {
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
      return true;
    }
    return false;
  }
}
