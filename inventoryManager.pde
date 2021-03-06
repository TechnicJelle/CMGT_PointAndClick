class InventoryManager {
  private Collectable[] collectables;
  private PVector[] slotPositions;
  private int slotW = 100;
  private int slotH = 100;

  public int selected = -1;

  private int hovered = -1;
  private boolean hoverOptim = true; //ignore this; it's only for a small optimization

  private int slots = 4;


  private PImage[] trashBagStates;
  private int trashBagState;
  private int trashBagSlots = 1+5; //The number after the 1+ is the amount of trash you can pick up. Change that if you want to change the number of pieces of trash you can pick of.

  private int scoreInBag = 0;

  public InventoryManager() {
    collectables = new Collectable[slots];
    slotPositions = new PVector[slots];

    int x = gwidth - slotW - 6;
    int beginY = gheight - slots * slotH - 24;
    for (int i = 0; i < slots; i++) {
      collectables[i] = null;
      slotPositions[i] = new PVector(x, beginY + i*(slotH+6));
    }

    PImage trashBagFull = loadImage("ui/TrashFull.png");
    PImage trashBagEmpty = loadImage("ui/TrashEmpty.png");
    this.trashBagState = 0;
    trashBagStates = new PImage[trashBagSlots];
    int ih = trashBagEmpty.height / (trashBagSlots-1);
    for (int i = 0; i < trashBagSlots; i++) {
      trashBagStates[i] = createImage(trashBagFull.width, trashBagFull.height, ARGB);
      trashBagStates[i] = trashBagEmpty.copy();
      trashBagStates[i].copy(trashBagFull, 
        0, trashBagFull.height - i*ih, trashBagFull.width, i*ih, 
        0, trashBagFull.height - i*ih, trashBagFull.width, i*ih);
    }
  }

  public void addCollectable(Collectable collectable) throws Exception {
    for (int i = 0; i < slots; i++) {
      if (collectables[i] == null) {
        collectables[i] = collectable;
        return;
      }
    }
    String t = "Couldn't fit item into the inventory anymore!";
    popup(t, 3500);
    throw new Exception(t);
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

  public void increaseTrash() throws Exception {
    if (trashBagState < trashBagSlots-1)
      trashBagState++;
    else {
      String t = "Couldn't fit trash into the bag anymore!\nYou should empty it outside";
      popup(t, 3500);
      throw new Exception(t);
    }
  }

  public void emptyTrash() {
    trashBagState = 0;
    score += scoreInBag;
    scoreInBag = 0;
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
      canvas.image(collectables[selected].image, mouse.x-collectables[selected].image.width/2, mouse.y-collectables[selected].image.height/2);
    }

    canvas.image(trashBagStates[trashBagState], 1631, 871);
  }

  public void mouseClicked() {
    for (int i = 0; i < slots; i++) {
      if (pointInRect(mouse.x, mouse.y, slotPositions[i].x, slotPositions[i].y, slotW, slotH)) {
        selected = i;
        return;
      }
    }
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
