import java.util.Date;
import java.text.SimpleDateFormat;

PGraphics canvas;
boolean fullHD;
PImage finalFrame; //Improves fps (Only needed when screen resolution != gamewindow size)
int gwidth = 1920;
int gheight = 1080;

boolean debugMode = true;
boolean analytics = false;
Table table;

PVector mouse;

final SceneManager sceneManager = new SceneManager();
final InventoryManager inventoryManager = new InventoryManager();

Task currentTask = null;

void settings() {
  size(1600, 900);
  //size(1920, 1080);
  //fullScreen();
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

  canvas = createGraphics(gwidth, gheight);
  canvas.beginDraw();
  canvas.textSize(10);
  //canvas.textFont(createFont("fonts/BothWays.ttf", 64));
  fullHD = width == gwidth && height == gheight;

  Scene bk2beds = new Scene("bk2beds", "rooms/bedroomKids/BedroomBeds.png");

  MoveToSceneObject bk1deskArrow = new MoveToSceneObject("goTobk1desk", gwidth/2, gheight - 100, "ui/arrowDown.png", "bk1desk");

  bk2beds.addGameObject(bk1deskArrow);


  Scene bk1desk = new Scene("bk1desk", "rooms/bedroomKids/BedroomDesk.png");

  MoveToSceneObject bk2bedsBackArrow = new MoveToSceneObject("goBackTobk2beds", gwidth/2, gheight - 100, "ui/arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, gheight/2 - 100, "hallway");
  hwArrow.setQuad(61.2, 30.0, 393.6, 97.2, 495.6, 792.0, 280.8, 1026.0);

  bk1desk.addGameObject(bk2bedsBackArrow);
  bk1desk.addGameObject(hwArrow);

  Scene cupBoard = new Scene("cupBoard", "rooms/cupBoard/cb.png");

  Collectable broom = new Collectable("broom", "collectables/Broom.png");
  CollectableObject broomco = new CollectableObject("broomco", 436, 90, "rooms/cupBoard/cbBroom2.png", broom);

  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", gwidth/2, gheight- 100, "ui/arrowDown.png", true);

  cupBoard.addGameObject(broomco);
  cupBoard.addGameObject(hallwayBackArrow);


  Scene hallway = new Scene("hallway", "rooms/hallWay/Hallway.png");

  MoveToSceneObject bk1deskBackArrow = new MoveToSceneObject("goBackTobk1desk", gwidth/2, gheight-100, "ui/arrowDown.png", true);

  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", gwidth/2 - 100, gheight- 500, "cupBoard");
  cupBoardArrow.setQuad(1263.0, 128.0, 1630.0, -85, 1330.0, 1370, 1192.0, 910.0);

  MoveToSceneObject br1showerArrow = new MoveToSceneObject("goTobr1shower", gwidth/3, gheight/2, "bathroom");
  br1showerArrow.setQuad(1102.0, 222.0, 1133.0, 205.0, 1111.0, 644.0, 1087.0, 569.0);

  MoveToSceneObject livingRoomArrow = new MoveToSceneObject("goToLivingRoomReading", gwidth - 500, gheight/2, "livingRoomReading");
  livingRoomArrow.setQuad(814.0, 182.0, 865.0, 208.0, 886.0, 627.0, 848.0, 728.0);



  Quad sweepQuad = new Quad(931.2, 496.8, 1062.0, 496.8, 1233.6, 1072.8, 738.0, 1074.0);
  MoveToSceneObject startSweepArrow = new MoveToSceneObject("goToSweepTask", 732.5, 493.2, "rooms/hallWay/trashClick.png", "taskSweep");
  startSweepArrow.setQuad(sweepQuad);
  RequireObject startSweep = new RequireObject("startSweep", 732.5, 493.2, "rooms/hallWay/trash.png", "You need a broom first!", broom, (GameObject)startSweepArrow);
  startSweep.setQuad(sweepQuad);

  TaskSweep taskSweep = new TaskSweep("taskSweep", "tasks/sweep/BroomBackground.png", startSweepArrow);

  hallway.addGameObject(bk1deskBackArrow);
  hallway.addGameObject(cupBoardArrow);
  hallway.addGameObject(br1showerArrow);
  hallway.addGameObject(livingRoomArrow);
  hallway.addGameObject(startSweep);

  Scene bathroom = new Scene("bathroom", "rooms/bathRoom/br1shower.png");

  MoveToSceneObject hallwayBackArrow_bathroom = new MoveToSceneObject("goBackToHallway_bathroom", gwidth - 100, gheight / 2, "ui/arrowRight.png", true);
  MoveToSceneObject br2sinkArrow = new MoveToSceneObject("goTobr2sink", gwidth/2, gheight - 100, "ui/arrowDown.png", "bathroomSink");

  bathroom.addGameObject(hallwayBackArrow_bathroom);
  bathroom.addGameObject(br2sinkArrow);

  Scene bathroomSink = new Scene("bathroomSink", "rooms/bathRoom/br2sink.png");

  MoveToSceneObject br1showerBackArrow = new MoveToSceneObject("goBackTobr1shower", gwidth/2, gheight - 100, "ui/arrowDown.png", true);

  bathroomSink.addGameObject(br1showerBackArrow);


  Scene livingRoomReading = new Scene("livingRoomReading", "rooms/livingRoom/lr1reading.png");

  MoveToSceneObject hallwaybackArrow_livingroom = new MoveToSceneObject("goBackToHallway_livingroom", gwidth/3, gheight - 300, "ui/arrowUp.png", true);
  MoveToSceneObject kitchenArrow = new MoveToSceneObject("goToKitchen", 0, gheight/2, "ui/arrowLeft.png", "kitchen");
  MoveToSceneObject TVArrow = new MoveToSceneObject("goToTV", gwidth - 100, gheight/2, "ui/arrowRight.png", "LivingRoomTV");

  livingRoomReading.addGameObject(hallwaybackArrow_livingroom);
  livingRoomReading.addGameObject(kitchenArrow);
  livingRoomReading.addGameObject(TVArrow);


  Scene kitchen = new Scene("kitchen", "rooms/livingRoom/lr2kitchen.png");

  MoveToSceneObject readingLRBackArrow = new MoveToSceneObject("goBackToLRReading", gwidth - 200, gheight - 100, "ui/arrowDown.png", true);
  MoveToSceneObject startDishArrow = new MoveToSceneObject("goToDishTask", 1074, 572, "ui/zoomIn.png", "taskDish");
  TaskDish taskDish = new TaskDish("taskDish", "tasks/dishes/bg.png", startDishArrow);




  Collectable sponge = new Collectable("sponge", "collectables/Sponge.png");
  CollectableObject spongeco = new CollectableObject("spongeco", 1334, 610, "rooms/livingRoom/Sponge.png", sponge);

  RequireObject startDish = new RequireObject("startDish", 1074, 572, "ui/arrowUp.png", "You need a sponge first!", sponge, (GameObject)startDishArrow);

  kitchen.addGameObject(readingLRBackArrow);
  kitchen.addGameObject(spongeco);
  kitchen.addGameObject(startDish);


  Scene livingRoomTV = new Scene("LivingRoomTV", "rooms/livingRoom/lr3tv.png");

  MoveToSceneObject readingLRBackArrow2 = new MoveToSceneObject("goBackToLRReading2", 0, gheight /2, "ui/arrowLeft.png", true);
  MoveToSceneObject bpArrow = new MoveToSceneObject("goTobp", 1300, gheight/2, "ui/arrowUp.png", "bp");

  livingRoomTV.addGameObject(readingLRBackArrow2);
  livingRoomTV.addGameObject(bpArrow);


  Scene bedroomParents = new Scene("bp", "rooms/bedroomParents/bp.png");

  MoveToSceneObject TvBackArrow = new MoveToSceneObject("goBackToTv", gwidth/2, gheight - 100, "ui/arrowDown.png", true);

  bedroomParents.addGameObject(TvBackArrow);

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

  mouse = screenScale(new PVector(mouseX, mouseY));

  //try {
  //  sceneManager.goToScene("taskDish");
  //} 
  //catch(Exception e) {
  //  println(e);
  //}
  canvas.endDraw();
}

void draw()
{  
  canvas.beginDraw();
  sceneManager.getCurrentScene().draw();
  sceneManager.getCurrentScene().updateScene();

  if (!(sceneManager.getCurrentScene() instanceof Task))
    inventoryManager.draw();

  if (debugMode) {
    canvas.stroke(255, 0, 0);
    canvas.strokeWeight(5);
    canvas.point(mouse.x, mouse.y);
  }


  canvas.endDraw();

  if (fullHD) {
    image(canvas, 0, 0);
  } else {
    finalFrame = canvas.get();
    finalFrame.resize(width, height); //<-- fps killer, but I can't think of a better way to handle this simply
    image(finalFrame, 0, 0);
  }
  if (debugMode) text(frameRate, 10, 10);
  //image(loadImage("rooms/cupBoard/cbBroom2.png"), mouse.x, mouse.y);
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
}

void mouseDragged() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
  inventoryManager.mouseMoved();
}

void mouseReleased() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  if (debugMode) println("new PVector(" + mouse.x + ", " + mouse.y + ");");
  sceneManager.getCurrentScene().mouseClicked();
  inventoryManager.mouseClicked();
  if (analytics) analyticRecord("mouseReleased");
}

void keyPressed() {
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

boolean sameSide(PVector p1, PVector p2, PVector a, PVector b) {
  PVector cp1 = PVector.sub(b, a).cross(PVector.sub(p1, a));
  PVector cp2 = PVector.sub(b, a).cross(PVector.sub(p2, a));
  if (cp1.dot(cp2) >= 0)
    return true;
  else
    return false;
}

boolean pointInTriangle(PVector p, PVector a, PVector b, PVector c) {
  return sameSide(p, a, b, c) && sameSide(p, b, a, c) && sameSide(p, c, a, b);
}

boolean pointInQuad(PVector p, PVector a, PVector b, PVector c, PVector d) {
  return pointInTriangle(p, a, b, c) || pointInTriangle(p, a, c, d);
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
