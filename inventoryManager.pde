class InventoryManager {
  private ArrayList<Collectable> collectables;
  private ArrayList<Collectable> markedForDeathCollectables;
  
  public InventoryManager() {
     collectables = new ArrayList<Collectable>();
     markedForDeathCollectables = new ArrayList<Collectable>();
  }
  
  public void addCollectable(Collectable collectable) {
    collectables.add(collectable);
  }
  
  public void removeCollectable(Collectable collectable) {
    markedForDeathCollectables.add(collectable);
  }
  
  public boolean containsCollectable(Collectable collectable) {
    return collectables.contains(collectable);
  }
  
  public void clearMarkedForDeathCollectables() {
    if(markedForDeathCollectables.size() > 0) {
      for(Collectable collectable : markedForDeathCollectables) {
        collectables.remove(collectable);
      }
      markedForDeathCollectables  = new ArrayList<Collectable>();
    }
  }
}
