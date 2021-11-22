class TrashObject extends CollectableObject {

  TrashObject(String identifier, float x, float y, String image) {
    super(identifier, x, y, image, null);
  }


  public void onCollect() throws Exception {
    inventoryManager.increaseTrash();
  }
}
