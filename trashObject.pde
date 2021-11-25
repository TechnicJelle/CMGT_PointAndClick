class TrashObject extends CollectableObject {
  private int scoreAdd;

  TrashObject(String identifier, float x, float y, String image, SoundFile sf, int sa) {
    super(identifier, x, y, image, sf, null);
    scoreAdd = sa;
    scoreMax += scoreAdd;
  }

  public void onCollect() throws Exception {
    inventoryManager.increaseTrash();
    inventoryManager.scoreInBag += scoreAdd;
  }
}
