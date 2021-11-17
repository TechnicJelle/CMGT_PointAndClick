class CollectableObject extends GameObject { 
  private Collectable collectable;
  private GameObject replaceWith;
  private boolean willReplaceByAnotherGameObject;

  public CollectableObject(String identifier, int x, int y, String image, Collectable collectable) {
    this(identifier, x, y, image, collectable, null);
  }

  public CollectableObject(String identifier, int x, int y, String image, Collectable collectable, GameObject replaceWith) {
    super(identifier, x, y, image);
    this.collectable = collectable;
    if (replaceWith != null) {
      this.replaceWith = replaceWith;
      this.willReplaceByAnotherGameObject = true;
    } else {
      this.willReplaceByAnotherGameObject = false;
    }
  }

  @Override
    public void draw() {
    super.draw();
  }

  @Override
    public void mouseClicked() {
    if (mouseIsHovering) {
      try {
        inventoryManager.addCollectable(collectable);
      }
      catch (Exception e) {
        println(e);
        return;
      }
      sceneManager.getCurrentScene().removeGameObject(this);
      if (willReplaceByAnotherGameObject) {
        sceneManager.getCurrentScene().addGameObject(replaceWith);
      }
    }
  }
}
