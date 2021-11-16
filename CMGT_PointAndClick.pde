int wwidth = 1920;
int wheight = 1080;

final SceneManager sceneManager = new SceneManager();
final InventoryManager inventoryManager = new InventoryManager();

void settings()
{
 //size(wwidth, wheight);
 fullScreen();
}

void setup()
{
  
  Scene bk2beds  = new Scene("bk2beds", "bk2beds.png");
  
  MoveToSceneObject bk1deskArrow = new MoveToSceneObject("goTobk1desk", width/2, height - 100, 100, 100, "arrowDown.png", "bk1desk");
  
  bk2beds.addGameObject(bk1deskArrow);
  
  
  Scene bk1desk = new Scene("bk1desk", "bk1desk.png");
  
  MoveToSceneObject bk2bedsBackArrow = new MoveToSceneObject("goBackTobk2beds", width/2, height - 100, 100, 100, "arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, height/2 - 100, 100, 100, "arrowLeft.png", "hallway");
  
  bk1desk.addGameObject(bk2bedsBackArrow);
  bk1desk.addGameObject(hwArrow);
  
  Scene hallway = new Scene("hallway", "hw.png");
  
  MoveToSceneObject bk1deskBackArrow = new MoveToSceneObject("goBackTobk1desk", width/2 + 100, height/3, 100, 100, "arrowUp.png", true);
  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", width/2 - 100, height/3*2, 100 , 100, "arrowLeft.png", "cupBoard");
  
  hallway.addGameObject(bk1deskBackArrow); 
  hallway.addGameObject(cupBoardArrow);
  
  Scene cupBoard = new Scene("cupBoard", "cb.png");
  
  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", width/2, height- 100, 100, 100, "arrowDown.png", true);
  
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
  
}

void draw()
{
  sceneManager.getCurrentScene().draw(wwidth, wheight);
  sceneManager.getCurrentScene().updateScene();
  inventoryManager.clearMarkedForDeathCollectables();
  inventoryManager.update();
}

void mouseMoved() {
  sceneManager.getCurrentScene().mouseMoved();
}

void mouseClicked() {
  sceneManager.getCurrentScene().mouseClicked();
}
