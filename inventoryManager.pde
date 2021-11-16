class InventoryManager {
  private ArrayList<Collectable> collectables;
  private ArrayList<Collectable> markedForDeathCollectables;


  private int x = 100;
  private int y = 100;

  public InventoryManager() {
    collectables = new ArrayList<Collectable>();
    markedForDeathCollectables = new ArrayList<Collectable>();
  }

  public void addCollectable(Collectable collectable) {
    collectables.add(collectable);

    // for(int i = 0; i < collectables.size(); i++)
    // {
    //   objectsInInventory.add(collectables.get(i).getName(),width - x, (height - y) - y * i, x, y);
    //  }
  }

  public void removeCollectable(Collectable collectable) {
    markedForDeathCollectables.add(collectable);
  }

  public boolean containsCollectable(Collectable collectable) {
    return collectables.contains(collectable);
  }

  public void clearMarkedForDeathCollectables() {
    if (markedForDeathCollectables.size() > 0) {
      for (Collectable collectable : markedForDeathCollectables) {
        collectables.remove(collectable);
      }
      markedForDeathCollectables  = new ArrayList<Collectable>();
    }
  }


  public void update() //to show the invetory
  {
    for (int i = 0; i < 4; i++)
    {
      fill(128, 50);
      rect(width - x, (height - y) - y * i, x, y);
    }
    if (collectables.size() >0)
    {
      for (int j = 0; j < collectables.size(); j++)
      {
        image(collectables.get(j).image, width - x, (height - y) - y * j, x, y);
      }
    }
  }
}
