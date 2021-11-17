class InventoryManager {
  private Collectable[] collectables;
  private PVector[] slotPositions;
  private int slotW = 100;
  private int slotH = 100;

  public int selected = -1;

  private int hovered = -1;
  private boolean hoverOptim = true; //ignore this; it's only for a small optimization


  private int slots = 4;

  public InventoryManager() {
    collectables = new Collectable[slots];
    slotPositions = new PVector[slots];

    int x = gwidth - slotW - 6;
    int beginY = gheight - slots * slotH - 24;
    for (int i = 0; i < slots; i++) {
      collectables[i] = null;
      slotPositions[i] = new PVector(x, beginY + i*(slotH+6));
    }
  }

  public void addCollectable(Collectable collectable) throws Exception {
    for (int i = 0; i < slots; i++) {
      if (collectables[i] == null) {
        collectables[i] = collectable;
        return;
      }
    }
    throw new Exception("Couldn't fit item into the inventory anymore!");
  }
  public boolean containsCollectable(Collectable collectable) {
    for (int i = 0; i < slots; i++) {
      if (collectables[i] == collectable) 
        return true;
    }
    return false;
  }

  public boolean isSelected(Collectable collectable) {
    if (selected == -1) return false;
    return collectables[selected] == collectable;
  }

  public void removeCollectable(Collectable collectable) throws Exception {
    for (int i = 0; i < slots; i++) {
      if (collectables[i] == collectable) {
        collectables[i] = null;
        return;
      }
    }
    throw new Exception("Item couldn't be found and wasn't removed");
  }

  public void draw() {
    hoverOptim = true;
    for (int i = 0; i < slots; i++) {
      canvas.stroke(0);
      if (i == selected) {
        canvas.strokeWeight(4);
      } else if (i == hovered) {
        canvas.strokeWeight(3);
      } else {
        canvas.strokeWeight(2);
      }
      canvas.fill(128, 50);
      canvas.rect(slotPositions[i].x, slotPositions[i].y, slotW, slotH, 12);
      if (collectables[i] != null) {
        canvas.image(collectables[i].image, slotPositions[i].x, slotPositions[i].y, slotW, slotH);
      }
    }

    if (selected != -1 && collectables[selected] != null) {
      canvas.image(collectables[selected].image, mouse.x-collectables[selected].image.width, mouse.y-collectables[selected].image.height);
    }
  }

  public void mouseClicked() {
    for (int i = 0; i < slots; i++) {
      if (pointInRect(mouse.x, mouse.y, slotPositions[i].x, slotPositions[i].y, slotW, slotH)) {
        selected = i;
        return;
      }
    }
    //Something was selected and was used to click on something else.
    //That must be handled appropriately.
    //For now, just deselect:
    selected = -1;
  }

  public void mouseMoved() {
    if (hoverOptim) {
      hoverOptim = false;
      for (int i = 0; i < slots; i++) {
        if (pointInRect(mouse.x, mouse.y, slotPositions[i].x, slotPositions[i].y, slotW, slotH)) {
          hovered = i;
          return;
        }
      }
      hovered = -1;
    }
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
