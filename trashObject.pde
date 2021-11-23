class TrashObject extends CollectableObject {
  private int scoreAdd;

  TrashObject(String identifier, float x, float y, String image, int sa) {
    super(identifier, x, y, image, null);
    scoreAdd = sa;
    scoreMax += scoreAdd;
  }

  public void onCollect() throws Exception {
    inventoryManager.increaseTrash();
    inventoryManager.scoreInBag += scoreAdd;
  }
}
