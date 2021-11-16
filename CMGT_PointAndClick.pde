PGraphics canvas;
boolean fullHD;
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

  MoveToSceneObject bk1deskArrow = new MoveToSceneObject("goTobk1desk", gwidth/2, gheight - 100, 100, 100, "arrowDown.png", "bk1desk");

  bk2beds.addGameObject(bk1deskArrow);


  Scene bk1desk = new Scene("bk1desk", "bk1desk.png");

  MoveToSceneObject bk2bedsBackArrow = new MoveToSceneObject("goBackTobk2beds", gwidth/2, gheight - 100, 100, 100, "arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, gheight/2 - 100, 100, 100, "arrowLeft.png", "hallway");

  bk1desk.addGameObject(bk2bedsBackArrow);
  bk1desk.addGameObject(hwArrow);

  Scene hallway = new Scene("hallway", "hw.png");

  MoveToSceneObject bk1deskBackArrow = new MoveToSceneObject("goBackTobk1desk", gwidth/2 + 100, gheight/3, 100, 100, "arrowUp.png", true);
  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", gwidth/2 - 100, gheight/3*2, 100, 100, "arrowLeft.png", "cupBoard");

  hallway.addGameObject(bk1deskBackArrow); 
  hallway.addGameObject(cupBoardArrow);

  Scene cupBoard = new Scene("cupBoard", "cb.png");

  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", gwidth/2, gheight- 100, 100, 100, "arrowDown.png", true);

  cupBoard.addGameObject(hallwayBackArrow);

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

  mouse = screenScale(new PVector(mouseX, mouseY));
}

void draw()
{  
  canvas.beginDraw();
  sceneManager.getCurrentScene().draw(gwidth, gheight);
  sceneManager.getCurrentScene().updateScene();
  inventoryManager.clearMarkedForDeathCollectables();
  inventoryManager.update();


  canvas.stroke(255, 0, 0);
  canvas.strokeWeight(5);
  canvas.point(mouse.x, mouse.y);


  canvas.endDraw();

  if (fullHD) {
    image(canvas, 0, 0);
  } else {
    PImage finalFrame = canvas.get();
    finalFrame.resize(width, height);
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
