class InventoryManager {
  private ArrayList<Collectable> collectables;
  private ArrayList<Collectable> markedForDeathCollectables;

  public int selected = -1;

  private int w = 100;
  private int h = 100;

  private int slots = 4;

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
    canvas.pushMatrix();
    canvas.translate(gwidth-w - 6, gheight-slots*h - 24);
    for (int i = 0; i < slots; i++) {
      canvas.stroke(0);
      if (selected == i) {
        canvas.strokeWeight(4);
        //if (collectables.get(i) != null) {
        //  canvas.image(collectables.get(i).image, mouse.x, mouse.y);
        //}
      } else {
        canvas.strokeWeight(2);
      }
      canvas.fill(128, 50);
      canvas.rect(0, (h+6) * i, w, h, 12);
    }
    if (collectables.size() > 0) {
      for (int i = 0; i < collectables.size(); i++) {
        canvas.image(collectables.get(i).image, 0, (h+6) * i, w, h);
      }
    }
    canvas.popMatrix();
  }

  public void keyPressed() {
    switch(key) {
    case '1':
      selected = 0;
      break;
    case '2':
      selected = 1;
      break;
    case '3':
      selected = 2;
      break;
    case '4':
      selected = 3;
      break;
    default:
      selected = -1;
      break;
    }
  }
}
