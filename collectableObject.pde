class CollectableObject extends GameObject { 
  private Collectable collectable;
  private GameObject replaceWith;
  private boolean willReplaceByAnotherGameObject;
  private SoundFile soundOnCollect;

  public CollectableObject(String identifier, float x, float y, String image, SoundFile sf, Collectable collectable) {
    this(identifier, x, y, image, sf, collectable, null);
  }

  public CollectableObject(String identifier, float x, float y, String image, SoundFile sf, Collectable collectable, GameObject replaceWith) {
    super(identifier, x, y, image);
    this.collectable = collectable;
    if (replaceWith != null) {
      this.replaceWith = replaceWith;
      this.willReplaceByAnotherGameObject = true;
    } else {
      this.willReplaceByAnotherGameObject = false;
    }
    this.soundOnCollect = sf;
  }

  @Override
    public void draw() {
    super.draw();
  }

  @Override
    public boolean mouseClicked() {
    if (mouseIsHovering) {
      try {
        onCollect();
      }
      catch (Exception e) {
        println(e);
        return true;
      }
      sceneManager.getCurrentScene().removeGameObject(this);
      soundOnCollect.play();
      if (willReplaceByAnotherGameObject) {
        sceneManager.getCurrentScene().addGameObject(replaceWith);
      }
      return true;
    }
    return false;
  }

  public void onCollect() throws Exception {
    inventoryManager.addCollectable(collectable);
  }
}
