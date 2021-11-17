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


  public void draw() {
    for (int i = 0; i < 4; i++) {
      canvas.fill(128, 50);
      canvas.rect(gwidth - x, (gheight - y) - y * i, x, y);
    }
    if (collectables.size() > 0) {
      for (int j = 0; j < collectables.size(); j++) {
        if(j != keyPressed())
        {
        canvas.image(collectables.get(j).image, gwidth - x, (gheight - y) - y * j, x, y);
        }
        else
        {
        canvas.image(collectables.get(j).image, mouse.x, mouse.y, x, y);
        }
      }
    }
  }
  
  public int keyPressed()
  {
    int a = -1;
    if(key == '1')
    a = 0;
    if(key == '2')
    a = 1;
    if(key == '3')
    a = 2;
    if(key == '4')
    a = 3;
    return a;
  }
}
