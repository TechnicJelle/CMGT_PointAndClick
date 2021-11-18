PGraphics canvas;
boolean fullHD;
PImage finalFrame; //Improves fps (Only needed when screen resolution != gamewindow size)
int gwidth = 1920;
int gheight = 1080;

boolean debugMode = true;

PVector mouse;

final SceneManager sceneManager = new SceneManager();
final InventoryManager inventoryManager = new InventoryManager();

Task currentTask = null;

void settings() {
  size(1600, 900);
  //fullScreen();
}

void setup() {
  canvas = createGraphics(gwidth, gheight);
  canvas.beginDraw();
  canvas.textSize(10);
  //canvas.textFont(createFont("fonts/BothWays.ttf", 64));
  fullHD = width == gwidth && height == gheight;

  Scene bk2beds  = new Scene("bk2beds", "rooms/bedroomKids/bk2beds.png");

  MoveToSceneObject bk1deskArrow = new MoveToSceneObject("goTobk1desk", gwidth/2, gheight - 100, "ui/arrowDown.png", "bk1desk");

  bk2beds.addGameObject(bk1deskArrow);


  Scene bk1desk = new Scene("bk1desk", "rooms/bedroomKids/bk1desk.png");

  MoveToSceneObject bk2bedsBackArrow = new MoveToSceneObject("goBackTobk2beds", gwidth/2, gheight - 100, "ui/arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, gheight/2 - 100, "ui/arrowLeft.png", "hallway");
  hwArrow.setQuad(61.2, 30.0, 393.6, 97.2, 495.6, 792.0, 280.8, 1026.0);

  bk1desk.addGameObject(bk2bedsBackArrow);
  bk1desk.addGameObject(hwArrow);

  Scene cupBoard = new Scene("cupBoard", "rooms/cupBoard/cb.png");

  Collectable broom = new Collectable("broom", "rooms/cupBoard/cbBroomIM.png");
  CollectableObject broomco = new CollectableObject("broomco", 436, 90, "rooms/cupBoard/cbBroom2.png", broom);

  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", gwidth/2, gheight- 100, "ui/arrowDown.png", true);

  cupBoard.addGameObject(broomco);
  cupBoard.addGameObject(hallwayBackArrow);

  TaskSweep taskSweep = new TaskSweep("taskSweep", "tasks/sweep/taskSweepBackground.png");

  Scene hallway = new Scene("hallway", "rooms/hallWay/hw.png");

  MoveToSceneObject bk1deskBackArrow = new MoveToSceneObject("goBackTobk1desk", gwidth/2 + 100, gheight/3, "ui/arrowUp.png", true);
  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", gwidth/2 - 100, gheight- 500, "ui/arrowLeft.png", "cupBoard");
  MoveToSceneObject br1showerArrow = new MoveToSceneObject("goTobr1shower", gwidth/3, gheight/2, "ui/arrowLeft.png", "bathroom");
  MoveToSceneObject livingRoomArrow = new MoveToSceneObject("goToLivingRoomReading", gwidth - 500, gheight/2, "ui/arrowRight.png", "livingRoomReading");
  MoveToSceneObject startSweepArrow = new MoveToSceneObject("goToSweepTask", 1084, 894, "ui/zoomIn.png", "taskSweep");
  RequireObject startSweep = new RequireObject("startSweep", 1084, 894, "ui/arrowDown.png", "You need a broom first!", broom, (GameObject)startSweepArrow);

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

  TaskDish taskDish = new TaskDish("taskDish", "tasks/dishes/bg.png");
  Scene kitchen = new Scene("kitchen", "rooms/livingRoom/lr2kitchen.png");

  MoveToSceneObject readingLRBackArrow = new MoveToSceneObject("goBackToLRReading", gwidth - 200, gheight - 100, "ui/arrowDown.png", true);
  MoveToSceneObject startDishArrow = new MoveToSceneObject("goToDishTask", 1074, 572, "ui/zoomIn.png", "taskDish");




  Collectable sponge = new Collectable("sponge", "rooms/livingRoom/Sponge.png");
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
  //  sceneManager.goToScene("cupBoard");
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

  canvas.stroke(255, 0, 0);
  canvas.strokeWeight(5);
  canvas.point(mouse.x, mouse.y);


  canvas.endDraw();

  if (fullHD) {
    image(canvas, 0, 0);
  } else {
    finalFrame = canvas.get();
    finalFrame.resize(width, height); //<-- fps killer, but I can't think of a better way to handle this simply
    image(finalFrame, 0, 0);
  }
  //image(loadImage("rooms/cupBoard/cbBroom2.png"), mouse.x, mouse.y);
}

void mouseMoved() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
  inventoryManager.mouseMoved();
}

void mouseReleased() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseClicked();
  inventoryManager.mouseClicked();
  if (debugMode) println("new PVector(" + mouse.x + ", " + mouse.y + ");");
}

void keyPressed() {
  inventoryManager.keyPressed();
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
