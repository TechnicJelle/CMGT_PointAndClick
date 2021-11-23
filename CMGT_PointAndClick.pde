import java.util.Date;
import java.text.SimpleDateFormat;

PGraphics canvas;
boolean fullHD;
PImage finalFrame; //Improves fps (Only needed when screen resolution != gamewindow size)
int gwidth = 1920;
int gheight = 1080;

boolean debugMode = false;
boolean analytics = false;
Table table;

PVector mouse;

SceneManager sceneManager;
InventoryManager inventoryManager;

TaskTracker taskTracker;

PFont bothways;
int fontSize = 48;

int cursorInt;

void settings() {
  size(1600, 900, P2D);
  //size(1920, 1080, P2D);
  //fullScreen(P2D);
  //smooth(1);
  //noSmooth();
}

void setup() {
  if (analytics) {
    table = new Table();

    table.addColumn("millis");
    table.addColumn("action");
    table.addColumn("mouse.x");
    table.addColumn("mouse.y");
  }

  cursorInt = ARROW;

  sceneManager = new SceneManager();
  inventoryManager = new InventoryManager();
  taskTracker = new TaskTracker();

  canvas = createGraphics(gwidth, gheight, P2D);
  canvas.beginDraw();

  bothways = createFont("fonts/BothWays.ttf", fontSize, true);
  changeFontSize(fontSize);

  fullHD = width == gwidth && height == gheight;

  //Main menu
  Scene mainMenu = new Scene("MainMenu", "Mainmenu.png", null);

  MoveToSceneObject StartGame = new MoveToSceneObject("StartObject", 703.2, 136.8, "bk2beds");
  StartGame.setQuad(703.2, 136.8, 1219.2, 133.2, 1219.2, 949.2, 703.2, 949.2);
  mainMenu.addGameObject(StartGame);


  //bedroom kids 2: beds -->
  Scene bk2beds = new Scene("bk2beds", "rooms/bedroomKids/BedroomBeds.png", "ui/minimap/Bedroom_Kids_1.png");

  MoveToSceneObject bk1deskArrow = new MoveToSceneObject("goTobk1desk", gwidth/2, gheight - 100, "ui/arrowDown.png", "bk1desk");
  MoveToSceneObject foldingTask = new MoveToSceneObject("goToFoldingTask", 0, 0, "tasks/folding/pileOfClothes.png", "TaskFolding");

  TaskFolding taskFolding = new TaskFolding("TaskFolding", "tasks/sweep/taskSweepBackground.png", foldingTask, null, "Fold the clothes", new PVector(86, 218));

  bk2beds.addGameObject(bk1deskArrow);
  bk2beds.addGameObject(foldingTask);

  TrashObject trash2 = new TrashObject("trash2", 690, 900, "trash/Cup4.png");
  bk2beds.addTrash(trash2);

  TrashObject trash3 = new TrashObject("trash3", 1223, 575, "trash/Sock1.png");
  bk2beds.addTrash(trash3);

  TrashObject trash4 = new TrashObject("trash4", 1270, 770, "trash/RCan1.png");
  bk2beds.addTrash(trash4);

  TrashObject trash5 = new TrashObject("trash5", 782, 612, "trash/Sock2.png");
  bk2beds.addTrash(trash5);
  //<-- bedroom kids 2: beds


  //bedroom kids 1: desk -->
  Scene bk1desk = new Scene("bk1desk", "rooms/bedroomKids/BedroomDesk.png", "ui/minimap/Bedroom_Kids_2.png");

  MoveToSceneObject bk2bedsBackArrow = new MoveToSceneObject("goBackTobk2beds", gwidth/2, gheight - 100, "ui/arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, gheight/2 - 100, "hallway");
  hwArrow.setQuad(59, 30.0, 393.6, 97.2, 494, 792.0, 280.8, 1026.0);

  bk1desk.addGameObject(bk2bedsBackArrow);
  bk1desk.addGameObject(hwArrow);


  TrashObject trash6 = new TrashObject("trash6", 954.75, 600.25, "trash/Magazine.png");
  bk1desk.addTrash(trash6);

  TrashObject trash7 = new TrashObject("trash7", 850, 530, "trash/Pizza.png");
  bk1desk.addTrash(trash7);

  TrashObject trash8 = new TrashObject("trash8", 600, 840, "trash/Bottle.png");
  bk1desk.addTrash(trash8);

  TrashObject trash9 = new TrashObject("trash9", 1290, 612, "trash/Clothes.png");
  bk1desk.addTrash(trash9);
  //<-- bedroom kids 1: desk

  //cupboard -->
  Scene cupBoard = new Scene("cupBoard", "rooms/cupBoard/cb.png", "ui/minimap/Closet.png");

  Collectable broom = new Collectable("broom", "collectables/Broom.png");
  CollectableObject broomco = new CollectableObject("broomco", 471, 37, "rooms/cupBoard/cbBroom.png", broom);

  Collectable vacuum = new Collectable("vacuum", "collectables/Vacuum.png");
  CollectableObject vacuumco = new CollectableObject("vacuumco", 743, 200, "rooms/cupBoard/cbVacuum.png", vacuum);
  //broomco.generateHoverImage();
  //broomco.setHoverImage("rooms/cupBoard/cbBroom2outline.png");

  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", gwidth/2, gheight- 100, "ui/arrowDown.png", true);

  cupBoard.addGameObject(broomco);
  cupBoard.addGameObject(vacuumco);
  cupBoard.addGameObject(hallwayBackArrow);
  //<-- cupboard

  //hallway -->
  Scene hallway = new Scene("hallway", "rooms/hallWay/Hallway.png", "ui/minimap/Hallway.png");

  MoveToSceneObject bk1deskBackArrow = new MoveToSceneObject("goBackTobk1desk", gwidth/2, gheight-100, "ui/arrowDown.png", true);

  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", gwidth/2 - 100, gheight- 500, "cupBoard");
  cupBoardArrow.setQuad(1265.0, 128.0, 1634.0, -86, 1331.0, 1370, 1192.0, 910.0);

  MoveToSceneObject br1showerArrow = new MoveToSceneObject("goTobr1shower", gwidth/3, gheight/2, "bathroom");
  br1showerArrow.setQuad(1102.0, 222.0, 1133.0, 205.0, 1111.0, 644.0, 1088.5, 569.0);

  MoveToSceneObject livingRoomArrow = new MoveToSceneObject("goToLivingRoomReading", gwidth - 500, gheight/2, "livingRoomReading");
  livingRoomArrow.setQuad(814.0, 182.0, 865.0, 208.0, 886.0, 627.0, 848.0, 728.0);

  Quad sweepQuad = new Quad(930.0, 492.0, 1064.4, 492.0, 1240.8, 1080, 730.8, 1080);
  MoveToSceneObject startSweepArrow = new MoveToSceneObject("goToSweepTask", 732.5, 493.2, "rooms/hallWay/trashClick.png", "taskSweep");
  startSweepArrow.setQuad(sweepQuad);
  RequireObject startSweep = new RequireObject("startSweep", 732.5, 493.2, "rooms/hallWay/trash.png", "Use a broom to clean up this mess", broom, (GameObject)startSweepArrow);
  startSweep.setQuad(sweepQuad);

  TaskSweep taskSweep = new TaskSweep("taskSweep", "tasks/sweep/taskSweepBackground.png", startSweepArrow, null, "Sweep the hallway", new PVector(155, 52));

  GameObject doorOutside = new GameObject("doorOutside", 500, 100) {
    public boolean mouseClicked() {
      if (super.mouseClicked()) {
        inventoryManager.emptyTrash();
        popup("Trash bag emptied!", 2500);
        return true;
      }
      return false;
    }
  };
  doorOutside.setQuad(932.4, 238.8, 1062.0, 238.8, 1056.0, 492.0, 939.6, 492.0);

  hallway.addGameObject(doorOutside);
  hallway.addGameObject(livingRoomArrow);
  hallway.addGameObject(br1showerArrow);
  hallway.addGameObject(cupBoardArrow);
  hallway.addGameObject(startSweep);
  hallway.addGameObject(bk1deskBackArrow);
  //<-- hallway

  //bathroom 1: shower -->
  Scene bathroom = new Scene("bathroom", "rooms/bathRoom/br1shower.png", "ui/minimap/Bathroom_1.png");

  MoveToSceneObject hallwayBackArrow_bathroom = new MoveToSceneObject("goBackToHallway_bathroom", gwidth - 100, gheight / 2, true);
  hallwayBackArrow_bathroom.setQuad(1721.0, 157.5, 1920.0, 99.9, 1920.0, 1800, 1584.0, 1069.2);
  MoveToSceneObject br2sinkArrow = new MoveToSceneObject("goTobr2sink", 0, gheight/2, "ui/arrowLeft.png", "bathroomSink");

  bathroom.addGameObject(hallwayBackArrow_bathroom);
  bathroom.addGameObject(br2sinkArrow);
  //<-- bathroom 1: shower

  //bathroom 2: sink -->
  Scene bathroomSink = new Scene("bathroomSink", "rooms/bathRoom/br2sink.png", "ui/minimap/Bathroom_2.png");

  MoveToSceneObject br1showerBackArrow = new MoveToSceneObject("goBackTobr1shower", gwidth-100, gheight/2, "ui/arrowRight.png", true);
  MoveToSceneObject br1showerHallWayArrow = new MoveToSceneObject("goBackToHallway", 0, gheight/2, true);
  br1showerHallWayArrow.setQuad(0, -15, 140.4, 72.0, 296.4, 1080, 0, 1080);
  br1showerHallWayArrow.setBackAmount(2);

  bathroomSink.addGameObject(br1showerBackArrow);
  bathroomSink.addGameObject(br1showerHallWayArrow);

  TrashObject trash1 = new TrashObject("trash1", 808.8, 758.4, "trash/Vomit.png");
  bathroomSink.addTrash(trash1);
  //<-- bathroom 2: sink

  //livingroom 1: reading -->
  Scene livingRoomReading = new Scene("livingRoomReading", "rooms/livingRoom/lr1reading.png", "ui/minimap/Living_Room_1.png");

  MoveToSceneObject hallwaybackArrow_livingroom = new MoveToSceneObject("goBackToHallway_livingroom", gwidth/3, gheight - 300, true);
  hallwaybackArrow_livingroom.setQuad(334.8, 86.4, 770.4, 102.0, 796.8, 818, 428, 878.4);
  MoveToSceneObject kitchenArrow = new MoveToSceneObject("goToKitchen", 0, gheight/2, "ui/arrowLeft.png", "kitchen");
  MoveToSceneObject TVArrow = new MoveToSceneObject("goToTV", gwidth - 100, gheight/2, "ui/arrowRight.png", "LivingRoomTV");

  livingRoomReading.addGameObject(hallwaybackArrow_livingroom);
  livingRoomReading.addGameObject(kitchenArrow);
  livingRoomReading.addGameObject(TVArrow);
  //<-- livingroom 1: reading

  //livingroom 2: kitchen -->
  Scene kitchen = new Scene("kitchen", "rooms/livingRoom/lr2kitchen.png", "ui/minimap/Kitchen_1.png");

  Collectable sponge = new Collectable("sponge", "collectables/Sponge.png");
  CollectableObject spongeco = new CollectableObject("spongeco", 1334, 610, "rooms/livingRoom/Sponge.png", sponge);
  //spongeco.generateHoverImage();

  MoveToSceneObject readingLRBackArrow = new MoveToSceneObject("goBackToLRReading", gwidth - 100, gheight/2, "ui/arrowRight.png", true);
  MoveToSceneObject kitchenGoToTVArrow = new MoveToSceneObject("kitchenGoToTV", 0, gheight/2, "ui/arrowLeft.png", true);
  kitchenGoToTVArrow.setAfterwardsScene("LivingRoomTV");
  MoveToSceneObject startDishArrow = new MoveToSceneObject("goToDishTask", 508, 549, "rooms/livingRoom/counterDirtyStart.png", "taskDish");
  GameObject endDish = new GameObject("goToDishTask", 500, 553, "rooms/livingRoom/counterClean.png");
  endDish.setClickable(false);
  RequireObject startDish = new RequireObject("startDish", 508, 549, "rooms/livingRoom/counterDirty.png", "Wash the disches with a sponge!", sponge, (GameObject)startDishArrow);
  TaskDish taskDish = new TaskDish("taskDish", "tasks/dishes/bg.png", startDishArrow, endDish, "Do the dishes", new PVector(101, 57));

  kitchen.addGameObject(kitchenGoToTVArrow);
  kitchen.addGameObject(readingLRBackArrow);
  kitchen.addGameObject(startDish);
  kitchen.addGameObject(spongeco);
  //<-- livingroom 2: kitchen

  //livingroom 3: tv -->
  Scene livingRoomTV = new Scene("LivingRoomTV", "rooms/livingRoom/lr3tv.png", "ui/minimap/Living_Room_2.png");

  MoveToSceneObject readingLRBackArrow2 = new MoveToSceneObject("goBackToLRReading2", 0, gheight /2, "ui/arrowLeft.png", true);
  MoveToSceneObject bpArrow = new MoveToSceneObject("goTobp", 1300, gheight/2, "bp");
  bpArrow.setQuad(1214.0, 634, 1487.0, 741, 1651.0, 32, 1276.0, 62);


  MoveToSceneObject tvGoToKitchenArrow = new MoveToSceneObject("tvGoToKitchenArrow", gwidth - 100, gheight/2, "ui/arrowRight.png", true);
  tvGoToKitchenArrow.setAfterwardsScene("kitchen");


  Quad vacuumQuad = new Quad(949.2, 530.4, 1309.2, 670.8, 590, 1080, 0, 840);
  MoveToSceneObject startVacuumArrow = new MoveToSceneObject("goToVacuumTask", 117, 531, "rooms/livingRoom/dustStart.png", "taskVacuum");
  startVacuumArrow.setQuad(vacuumQuad);
  RequireObject startVacuum = new RequireObject("startVacuum", 117, 531, "rooms/livingRoom/dust.png", "Use a vacuum to suck up this dust!", vacuum, (GameObject)startVacuumArrow);
  startVacuum.setQuad(vacuumQuad);
  TaskVacuum taskVacuum = new TaskVacuum("taskVacuum", "tasks/vacuum/rug.png", startVacuumArrow, null, "Vacuum the livingroom", new PVector(80, 134));

  livingRoomTV.addGameObject(tvGoToKitchenArrow);
  livingRoomTV.addGameObject(readingLRBackArrow2);
  livingRoomTV.addGameObject(bpArrow);
  livingRoomTV.addGameObject(startVacuum);
  //<-- livingroom 3: tv


  //bedroom parents -->
  Scene bedroomParents = new Scene("bp", "rooms/bedroomParents/bp.png", "ui/minimap/Bedroom_Parents.png");

  MoveToSceneObject TvBackArrow = new MoveToSceneObject("goBackToTv", gwidth/2, gheight - 100, "ui/arrowDown.png", true);

  bedroomParents.addGameObject(TvBackArrow);
  //<-- bedroom parents

  sceneManager.addScene(mainMenu);
  sceneManager.addScene(bk2beds);
  sceneManager.addScene(bk1desk);
  sceneManager.addScene(hallway);
  sceneManager.addScene(cupBoard);
  sceneManager.addScene(bathroom);
  sceneManager.addScene(bathroomSink);
  sceneManager.addScene(livingRoomReading);
  sceneManager.addScene(kitchen);
  sceneManager.addScene(livingRoomTV);
  sceneManager.addScene(bedroomParents);
  sceneManager.addScene(taskSweep);
  sceneManager.addScene(taskDish);
  sceneManager.addScene(taskFolding);
  sceneManager.addScene(taskVacuum);

  mouse = screenScale(new PVector(mouseX, mouseY));

  //try {
  //  sceneManager.goToScene("taskDish");
  //} 
  //catch(Exception e) {
  //  println(e);
  //}
  canvas.endDraw();
}

int millisAtLastLog = 0;
void draw() {
  if (debugMode && millis() - millisAtLastLog > 5000) {
    millisAtLastLog = millis();
    println("fps: " + frameRate);
  }
  if (frameCount % 60 == 0) {
    mouse = screenScale(new PVector(mouseX, mouseY));
    sceneManager.getCurrentScene().mouseMoved();
  }
  canvas.beginDraw();
  sceneManager.getCurrentScene().draw();
  sceneManager.getCurrentScene().updateScene();

  if (!(sceneManager.getCurrentScene() instanceof Task)) {
    inventoryManager.draw();
    taskTracker.draw();
  }

  if (debugMode) {
    canvas.stroke(255, 0, 0);
    canvas.strokeWeight(5);
    canvas.point(mouse.x, mouse.y);
  }

  //canvas.image(loadImage("ui/TrashFull.png"), mouse.x, mouse.y);

  canvas.endDraw();

  if (fullHD) {
    image(canvas, 0, 0);
  } else {
    //Thanks to hamoid at https://discourse.processing.org/t/faster-pimage-resizing/33593/16 for helping make this way faster!
    image(canvas, 0, 0, width, height);
  }
  if (debugMode) text(frameRate, 10, 10);
  if (analytics && frameCount % 30 == 0) analyticRecord("mousePosition");
}

void exit() {
  println("exiting");
  if (analytics) {
    analyticRecord("exit");
    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
    Date now = new Date();
    String strDate = sdfDate.format(now);
    saveTable(table, "analytics/" + strDate + ".csv");
  }
  super.exit();
}

void mouseMoved() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
  inventoryManager.mouseMoved();
  taskTracker.mouseMoved();
}

void mouseDragged() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
  inventoryManager.mouseMoved();
  taskTracker.mouseMoved();
}

void mouseReleased() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  if (debugMode) println("new PVector(" + mouse.x + ", " + mouse.y + ");");
  sceneManager.getCurrentScene().mouseMoved();
  sceneManager.getCurrentScene().mouseClicked();
  sceneManager.getCurrentScene().mouseMoved();
  inventoryManager.mouseClicked();
  taskTracker.mouseClicked();
  if (analytics) analyticRecord("mouseReleased");
}

void keyPressed() {
  if (key == 'd') debugMode = !debugMode;
  if (debugMode) {
    if (key == 'c') taskTracker.tasks.get(0).completed = !taskTracker.tasks.get(0).completed;
    if (key == 't') {
      try {
        inventoryManager.increaseTrash();
      }
      catch(Exception e) {
        println(e);
      }
    }
    if (key == 'T') inventoryManager.emptyTrash();
  }
  inventoryManager.keyPressed();
  if (analytics) analyticRecord(String.valueOf(key));
}

void analyticRecord(String action) {
  TableRow newRow = table.addRow();
  newRow.setInt("millis", millis());
  newRow.setString("action", action);
  newRow.setFloat("mouse.x", mouse.x);
  newRow.setFloat("mouse.y", mouse.y);
}

boolean pointInRect(float px, float py, float x, float y, float w, float h) {
  return px >= x && px <= x + w && py >= y && py <= y + h;
}

PVector screenScale(PVector p) {
  if (fullHD)
    return p;
  p = elemmult(p, new PVector(gwidth, gheight));
  p = elemdiv(p, new PVector(width, height));
  return p;
}

PVector elemmult(PVector a, PVector b) {
  return new PVector(a.x * b.x, a.y * b.y);
}

PVector elemdiv(PVector a, PVector b) {
  float x = 0;
  float y = 0;
  if (a.x != 0.0f && b.x != 0.0f)
    x = a.x / b.x;
  if (a.y != 0.0f && b.y != 0.0f)
    y = a.y / b.y;
  return new PVector(x, y);
}

void changeFontSize(int fs) {
  fontSize = fs;
  canvas.textFont(bothways);
  canvas.textSize(fontSize);
  canvas.textAlign(LEFT, TOP);
  canvas.textLeading(fontSize);
}

void drawText(String someString, float x, float y) {
  canvas.textFont(bothways);
  canvas.textSize(fontSize);
  canvas.textAlign(LEFT, TOP);
  canvas.fill(0);
  canvas.textLeading(fontSize);
  canvas.text(someString, x, y);
}

void drawTextInRect(String someString, float x, float y) {
  float m = 8;
  canvas.fill(255);
  canvas.stroke(0);
  canvas.strokeWeight(1);
  canvas.rect(x-m, y-m, canvas.textWidth(someString)+m*2, textHeight(someString, int(canvas.textWidth(someString)), fontSize) + m*2, fontSize/4);
  drawText(someString, x, y);
}

int textHeight(String str, int specificWidth, int leading) {
  //source: https://forum.processing.org/one/topic/finding-text-height-from-a-text-area.html
  // split by new lines first
  String[] paragraphs = split(str, "\n");
  int numberEmptyLines = -1;
  int numTextLines = 0;
  for (int i=0; i < paragraphs.length; i++) {
    // anything with length 0 ignore and increment empty line count
    if (paragraphs[i].length() == 0) {
      numberEmptyLines++;
    } else {      
      numTextLines++;
      // word wrap
      String[] wordsArray = split(paragraphs[i], " ");
      String tempString = "";
      for (int k=0; k < wordsArray.length; k++) {
        if (canvas.textWidth(tempString + wordsArray[k]) < specificWidth) {
          tempString += wordsArray[k] + " ";
        } else {
          tempString = wordsArray[k] + " ";
          numTextLines++;
        }
      }
    }
  }

  float totalLines = numTextLines + numberEmptyLines;
  return round(totalLines * leading);
}

void popup(String t, int millis) {
  TextObject popup = new TextObject("popup", mouse.x + random(-100, 100), mouse.y + random(-100, 100), "", t, millis);
  sceneManager.getCurrentScene().addGameObject(popup);
  popup.show();
  popup.markForDeletion();
}

void setCursor(int c) {
  if (c != cursorInt) {
    cursor(c);
    println("Changed cursor to:", cursorInt = c);
  }
}

void setCursor(PImage p) {
  cursor(p);
}
