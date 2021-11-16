PGraphics canvas;
boolean fullHD;
PImage finalFrame; //Improves fps (Only needed when screen resolution != gamewindow size)
int gwidth = 1920;
int gheight = 1080;

PVector mouse;

final SceneManager sceneManager = new SceneManager();
final InventoryManager inventoryManager = new InventoryManager();

void settings()
{
  //size(gwidth, gheight);
  fullScreen();
}

void setup()
{
  canvas = createGraphics(gwidth, gheight);
  fullHD = width == gwidth && height == gheight;

  Scene bk2beds  = new Scene("bk2beds", "bk2beds.png");

  MoveToSceneObject bk1deskArrow = new MoveToSceneObject("goTobk1desk", gwidth/2, gheight - 100, "arrowDown.png", "bk1desk");

  bk2beds.addGameObject(bk1deskArrow);


  Scene bk1desk = new Scene("bk1desk", "bk1desk.png");

  MoveToSceneObject bk2bedsBackArrow = new MoveToSceneObject("goBackTobk2beds", gwidth/2, gheight - 100, "arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, gheight/2 - 100, "arrowLeft.png", "hallway");

  bk1desk.addGameObject(bk2bedsBackArrow);
  bk1desk.addGameObject(hwArrow);

  Scene hallway = new Scene("hallway", "hw.png");

  MoveToSceneObject bk1deskBackArrow = new MoveToSceneObject("goBackTobk1desk", gwidth/2 + 100, gheight/3, "arrowUp.png", true);
  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", gwidth/2 - 100, gheight- 500, "arrowLeft.png", "cupBoard");
  MoveToSceneObject br1showerArrow = new MoveToSceneObject("goTobr1shower", gwidth/3, gheight/2, "arrowLeft.png", "bathroom");
  MoveToSceneObject livingRoomArrow = new MoveToSceneObject("goToLivingRoomReading", gwidth - 500, gheight/2, "arrowRight.png", "livingRoomReading");

  hallway.addGameObject(bk1deskBackArrow); 
  hallway.addGameObject(cupBoardArrow);
  hallway.addGameObject(br1showerArrow);
  hallway.addGameObject(livingRoomArrow);

  Scene cupBoard = new Scene("cupBoard", "cb.png");

  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", gwidth/2, gheight- 100, "arrowDown.png", true);

  cupBoard.addGameObject(hallwayBackArrow);

  Scene bathroom = new Scene("bathroom", "br1shower.png");

  MoveToSceneObject hallwayBackArrow_bathroom = new MoveToSceneObject("goBackToHallway_bathroom", gwidth - 100, gheight / 2, "arrowRight.png", true);
  MoveToSceneObject br2sinkArrow = new MoveToSceneObject("goTobr2sink", gwidth/2, gheight - 100, "arrowDown.png", "bathroomSink");

  bathroom.addGameObject(hallwayBackArrow_bathroom);
  bathroom.addGameObject(br2sinkArrow);

  Scene bathroomSink = new Scene("bathroomSink", "br2sink.png");

  MoveToSceneObject br1showerBackArrow = new MoveToSceneObject("goBackTobr1shower", gwidth/2, gheight - 100, "arrowDown.png", true);

  bathroomSink.addGameObject(br1showerBackArrow);


  Scene livingRoomReading = new Scene("livingRoomReading", "lr1reading.png");

  MoveToSceneObject hallwaybackArrow_livingroom = new MoveToSceneObject("goBackToHallway_livingroom", gwidth/3, gheight - 300, "arrowUp.png", true);
  MoveToSceneObject kitchenArrow = new MoveToSceneObject("goToKitchen", 0, gheight/2, "arrowLeft.png", "kitchen");
  MoveToSceneObject TVArrow = new MoveToSceneObject("goToTV", gwidth - 100, gheight/2, "arrowRight.png", "LivingRoomTV");

  livingRoomReading.addGameObject(hallwaybackArrow_livingroom);
  livingRoomReading.addGameObject(kitchenArrow);
  livingRoomReading.addGameObject(TVArrow);

  Scene kitchen = new Scene("kitchen", "lr2kitchen.png");

  MoveToSceneObject readingLRBackArrow = new MoveToSceneObject("goBackToLRReading", gwidth - 200, gheight - 100, "arrowDown.png", true);

  kitchen.addGameObject(readingLRBackArrow);

  Scene livingRoomTV = new Scene("LivingRoomTV", "lr3tv.png");

  MoveToSceneObject readingLRBackArrow2 = new MoveToSceneObject("goBackToLRReading2", 0, gheight /2, "arrowLeft.png", true);
  MoveToSceneObject bpArrow = new MoveToSceneObject("goTobp", 1300, gheight/2, "arrowUp.png", "bp");

  livingRoomTV.addGameObject(readingLRBackArrow2);
  livingRoomTV.addGameObject(bpArrow);


  Scene bedroomParents = new Scene("bp", "bp.png");

  MoveToSceneObject TvBackArrow = new MoveToSceneObject("goBackToTv", gwidth/2, gheight - 100, "arrowDown.png", true);

  bedroomParents.addGameObject(TvBackArrow);


  /* Collectable apple = new Collectable("apple", "back04_apple.png");
  MoveToSceneObject object7 = new MoveToSceneObject("goToScene04_scene01", 206, 461, 50, 50, "arrowUp.png", "scene04");
  
  Scene scene01 = new Scene("scene01", "back01.png");
  RequireObject loupe01 = new RequireObject("requiresApple_scene01", 206, 461, 50, 50, "zoom.png", "You need an Apple before getting here!", apple, object7);
  loupe01.setHoverImage("zoomIn.png");
  scene01.addGameObject(loupe01);
  TextObject loupe02 = new TextObject("smallText_scene01", 541, 445, 50, 50, "zoom.png", "This object has a text!");
  loupe02.setHoverImage("zoomIn.png");
  scene01.addGameObject(loupe02);
  TextObject loupe03 = new TextObject("largeText_scene01", 46, 687, 50, 50, "zoom.png", "This object has a way longer text. It shows that the windows can be of varied size according to the text.");
  loupe03.setHoverImage("zoomIn.png");
  
 
  scene01.addGameObject(loupe03);
  
  MoveToSceneObject object2 = new MoveToSceneObject("goToScene02_scene01", 708, 445, 50, 50, "arrowRight.png", "scene02");
  
  scene01.addGameObject(object2);
  MoveToSceneObject restaurantSceneMoveTo = new MoveToSceneObject("goToScene06_scene01", 388, 440, 50, 50, "arrowUp.png", "scene05");
  scene01.addGameObject(restaurantSceneMoveTo);
  
  Scene scene02 = new Scene("scene02", "back02.png");
  MoveToSceneObject object3 = new MoveToSceneObject("goBack_scene02", 350, 700, 50, 50, "arrowDown.png", true);
  scene02.addGameObject(object3);
  MoveToSceneObject object4 = new MoveToSceneObject("goToScene03_scene02", 441, 494, 50, 50, "arrowUp.png", "scene03");
  scene02.addGameObject(object4);
  
  Scene scene03 = new Scene("scene03", "back04.png");
  MoveToSceneObject object5 = new MoveToSceneObject("goBack_scene03", 203, 673, 300, 300, "arrowDown.png", true);
  scene03.addGameObject(object5);
  CollectableObject object6 = new CollectableObject("apple_scene03", 325, 366, 123, 101, apple);
  scene03.addGameObject(object6);
  
  Scene scene04 = new Scene("scene04", "back03.png");
  TextObject endGame = new TextObject("smallText_scene04", 430, 590, 50, 50, "medal1.png", "Congratulations. You finished the game!");
  scene04.addGameObject(endGame);
  
  //Scene scene05 = ...
  */
  
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

  mouse = screenScale(new PVector(mouseX, mouseY));
}

void draw()
{  
  canvas.beginDraw();
  sceneManager.getCurrentScene().draw();
  sceneManager.getCurrentScene().updateScene();
  inventoryManager.clearMarkedForDeathCollectables();
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
}

void mouseMoved() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
}

void mouseClicked() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseClicked();
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
