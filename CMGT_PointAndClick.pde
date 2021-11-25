import processing.sound.*;

import processing.video.*;

import java.util.Date;
import java.text.SimpleDateFormat;

PGraphics canvas;
boolean fullHD;
PImage finalFrame; //Improves fps (Only needed when screen resolution != gamewindow size)
int gwidth = 1920;
int gheight = 1080;

boolean debugMode = false;
boolean analytics = false;
Table analyticsTable;

PVector mouse;

SceneManager sceneManager;
InventoryManager inventoryManager;

TaskTracker taskTracker;

PFont bothways;
int fontSize = 128;

int cursorInt;

int score;
int scoreMax;

Movie introVideo;
boolean mediaLoaded;

int millisAtGameStart;
int millisLeft;

SoundFile sndTheme1;
SoundFile sndTheme2;
SoundFile sndTheme3;

SoundFile sfxBroom1;
SoundFile sfxBroom2;
SoundFile sfxClosingCloset;
SoundFile sfxDoorOpen1;
SoundFile sfxDoorOpen2;
SoundFile sfxPing;
SoundFile sfxFolding1;
SoundFile sfxFolding2;
SoundFile sfxOpenCloset;
SoundFile sfxSponge1;
SoundFile sfxSponge2;
SoundFile sfxTrash1;
SoundFile sfxTrash2;
SoundFile sfxTrash3;
SoundFile sfxTrash4;
SoundFile sfxUnlockPhone;
SoundFile sfxVacuumRunning;
SoundFile sfxVacuumStart;
SoundFile sfxVacuumStop;
SoundFile sfxWakeUp;

Table highscores;

void settings() {
  //size(1600, 900, P2D);
  //size(1920, 1080, P2D);
  fullScreen(P2D);
  //smooth(1);
  //noSmooth();
}

void loadMedia() {
  introVideo = new Movie(this, "menus/main/introVideo.mp4");
  sndTheme1 = new SoundFile(this, "sound/music/theme1.wav");
  sndTheme3 = new SoundFile(this, "sound/music/theme3.wav");

  sfxBroom1 = new SoundFile(this, "sound/sfx/Broom_1.wav");
  sfxBroom2 = new SoundFile(this, "sound/sfx/Broom_2.wav");
  sfxClosingCloset = new SoundFile(this, "sound/sfx/Closing_Closet.wav");
  sfxDoorOpen1 = new SoundFile(this, "sound/sfx/Door_Opens_1.wav");
  sfxDoorOpen2 = new SoundFile(this, "sound/sfx/Door_Opens_2.wav");
  sfxPing = new SoundFile(this, "sound/sfx/facebook_new_message_pop_ding.wav");
  sfxFolding1 = new SoundFile(this, "sound/sfx/Folding_1.wav");
  sfxFolding2 = new SoundFile(this, "sound/sfx/Folding_2.wav");
  sfxOpenCloset = new SoundFile(this, "sound/sfx/Opening_Closet.wav");
  sfxSponge1 = new SoundFile(this, "sound/sfx/Sponge_1.wav");
  sfxSponge2 = new SoundFile(this, "sound/sfx/Sponge_2.wav");
  sfxTrash1 = new SoundFile(this, "sound/sfx/Trash_1.wav");
  sfxTrash2 = new SoundFile(this, "sound/sfx/Trash_2.wav");
  sfxTrash3 = new SoundFile(this, "sound/sfx/Trash_3.wav");
  sfxTrash4 = new SoundFile(this, "sound/sfx/Trash_4.wav");
  sfxUnlockPhone = new SoundFile(this, "sound/sfx/Unlocked_Phone.wav");
  sfxVacuumRunning = new SoundFile(this, "sound/sfx/Vacuum_Running.wav");
  sfxVacuumStart = new SoundFile(this, "sound/sfx/Vacuum_Start.wav");
  sfxVacuumStop = new SoundFile(this, "sound/sfx/Vacuum_Stop.wav");
  sfxWakeUp = new SoundFile(this, "sound/sfx/Waking_Up_1.wav");
  mediaLoaded = true;
}

void setup() {
  //highscores = new Table();
  //highscores.addColumn("name");
  //highscores.addColumn("time");
  //highscores.addColumn("score");
  highscores = loadTable("data/highscores.csv", "header");
  highscores.setColumnType("score", Table.INT);
  highscores.trim();
  highscores.sortReverse("score");

  if (analytics) {
    analyticsTable = new Table();

    analyticsTable.addColumn("millis");
    analyticsTable.addColumn("action");
    analyticsTable.addColumn("mouse.x");
    analyticsTable.addColumn("mouse.y");
  }

  mediaLoaded = false;
  sndTheme2 = new SoundFile(this, "sound/music/theme2.wav");
  sndTheme2.loop();
  loadMedia();
  //thread("loadMedia"); //<-- doesn't load in sounds in time for the CollectableObjects

  cursorInt = ARROW;

  score = 0;
  scoreMax = 0;

  sceneManager = new SceneManager();
  inventoryManager = new InventoryManager();
  taskTracker = new TaskTracker();

  canvas = createGraphics(gwidth, gheight, P2D);
  canvas.beginDraw();

  bothways = createFont("fonts/BothWays.ttf", fontSize, true);
  changeFontSize(fontSize);
  changeFontSize(48);

  fullHD = width == gwidth && height == gheight;

  //Main menu
  MainMenu mainMenu = new MainMenu("MainMenu", "menus/main/phone.png");

  GameObject logo = new GameObject("logo", gwidth/2, 210, "menus/main/Official_Title.png", true);
  logo.setClickable(false);

  MoveToSceneObject StartGame = new MoveToSceneObject("StartObject", 0, 0, "data/menus/main/btn_play.png", "introVideoScene");
  StartGame.setXY(gwidth/2, 400, true);
  StartGame.setHoverImage("data/menus/main/btn_playH.png");

  GameObject HighScoreButton = new GameObject("HighScoreButton", 0, 0, "data/menus/main/btn_high.png") {
    public boolean mouseClicked() {
      if (super.mouseClicked()) {
        MainMenu mm = (MainMenu)sceneManager.getCurrentScene();
        mm.highscoreScreen = true;
        setCursor(ARROW);
        return true;
      }
      return false;
    }
  };
  HighScoreButton.setXY(gwidth/2, 600, true);
  HighScoreButton.setHoverImage("data/menus/main/btn_highH.png");

  GameObject ExitButton = new GameObject("ExitButton", 0, 0, "data/menus/main/btn_exit.png") {
    public boolean mouseClicked() {
      if (super.mouseClicked()) {
        exit();
        return true;
      }
      return false;
    }
  };
  ExitButton.setXY(gwidth/2, 800, true);
  ExitButton.setHoverImage("data/menus/main/btn_exitH.png");

  //StartGame.setQuad(703.2, 136.8, 1219.2, 133.2, 1219.2, 949.2, 703.2, 949.2);
  mainMenu.addGameObject(logo);
  mainMenu.addGameObject(StartGame);
  mainMenu.addGameObject(HighScoreButton);
  mainMenu.addGameObject(ExitButton);

  //Intro video
  IntroVideoScene introVideoScene = new IntroVideoScene("introVideoScene", "menus/main/phone.png");


  //bedroom kids 1: beds -->
  Scene bk1beds = new Scene("bk1beds", "rooms/bedroomKids/bk1beds.png", "ui/minimap/Bedroom_Kids_1.png");

  MoveToSceneObject bk2deskArrow = new MoveToSceneObject("goTobk2desk", gwidth/2, gheight - 105, "ui/arrowDown.png", "bk2desk");
  bk1beds.addGameObject(bk2deskArrow);

  TrashObject trash2 = new TrashObject("trash2", 690, 900, "trash/Cup4.png", sfxTrash4, 20000);
  bk1beds.addTrash(trash2);

  TrashObject trash3 = new TrashObject("trash3", 1223, 575, "trash/Sock1.png", sfxFolding1, 10000);
  bk1beds.addTrash(trash3);

  TrashObject trash4 = new TrashObject("trash4", 1270, 770, "trash/RCan1.png", sfxTrash4, 20500);
  bk1beds.addTrash(trash4);

  TrashObject trash5 = new TrashObject("trash5", 782, 612, "trash/Sock2.png", sfxFolding2, 10000);
  bk1beds.addTrash(trash5);
  //<-- bedroom kids 1: beds


  //bedroom kids 2: desk -->
  Scene bk2desk = new Scene("bk2desk", "rooms/bedroomKids/bk2desk.png", "ui/minimap/Bedroom_Kids_2.png");

  MoveToSceneObject bk1bedsBackArrow = new MoveToSceneObject("goBackTobk1beds", gwidth/2, gheight - 105, "ui/arrowDown.png", true);
  MoveToSceneObject hwArrow = new MoveToSceneObject("goToHallway", 150, gheight/2 - 105, "hallway");
  hwArrow.setQuad(59, 30.0, 393.6, 97.2, 494, 792.0, 280.8, 1026.0);

  bk2desk.addGameObject(bk1bedsBackArrow);
  bk2desk.addGameObject(hwArrow);

  Collectable plate2 = new Collectable("plate2", "collectables/PlateDirty2.png");
  CollectableObject plate2co = new CollectableObject("plate2co", 875, 591, "rooms/bedroomKids/PlateDirty2.png", sfxTrash1, plate2);
  bk2desk.addGameObject(plate2co);

  TrashObject trash6 = new TrashObject("trash6", 954.75, 600.25, "trash/Magazine.png", sfxTrash2, 20500);
  bk2desk.addTrash(trash6);

  TrashObject trash7 = new TrashObject("trash7", 865, 580, "trash/Pizzasmall.png", sfxTrash4, 10050);
  bk2desk.addTrash(trash7);

  TrashObject trash8 = new TrashObject("trash8", 600, 840, "trash/Bottle.png", sfxTrash1, 11000);
  bk2desk.addTrash(trash8);

  Collectable clothes1 = new Collectable("clothes1", "collectables/Clothes.png");
  CollectableObject clothes1co = new CollectableObject("clothes1", 1290, 612, "rooms/bedroomKids/Clothes.png", sfxFolding2, clothes1);
  bk2desk.addGameObject(clothes1co);
  //<-- bedroom kids 2: desk

  //cupboard -->
  Scene cupBoard = new Scene("cupBoard", "rooms/cupBoard/cb.png", "ui/minimap/Closet.png");

  Collectable broom = new Collectable("broom", "collectables/Broom.png");
  CollectableObject broomco = new CollectableObject("broomco", 471, 37, "rooms/cupBoard/cbBroom.png", sfxFolding2, broom);

  Collectable vacuum = new Collectable("vacuum", "collectables/Vacuum.png");
  CollectableObject vacuumco = new CollectableObject("vacuumco", 743, 200, "rooms/cupBoard/cbVacuum.png", sfxFolding1, vacuum);
  //broomco.generateHoverImage();
  //broomco.setHoverImage("rooms/cupBoard/cbBroom2outline.png");

  MoveToSceneObject hallwayBackArrow = new MoveToSceneObject("goBackToHallway", gwidth/2, gheight- 105, "ui/arrowDown.png", true);

  cupBoard.addGameObject(broomco);
  cupBoard.addGameObject(vacuumco);
  cupBoard.addGameObject(hallwayBackArrow);

  Collectable plate4 = new Collectable("plate4", "collectables/PlateDirty4.png");
  CollectableObject plate4co = new CollectableObject("plate4co", 1209, 723, "rooms/cupBoard/PlateDirty4.png", sfxTrash1, plate4);
  cupBoard.addGameObject(plate4co);

  TrashObject trash10 = new TrashObject("trash10", 1300, 125.0, "trash/AlcBottle.png", sfxTrash1, 50000);
  TrashObject trash11 = new TrashObject("trash11", 1000, 800, "trash/BCan1.png", sfxTrash4, 11500);
  cupBoard.addTrash(trash10);
  cupBoard.addTrash(trash11);
  //<-- cupboard

  //hallway -->
  Scene hallway = new Scene("hallway", "rooms/hallWay/Hallway.png", "ui/minimap/Hallway.png");

  MoveToSceneObject bk2deskBackArrow = new MoveToSceneObject("goBackTobk2desk", gwidth/2, gheight-105, "ui/arrowDown.png", true);

  MoveToSceneObject cupBoardArrow = new MoveToSceneObject("goToCupBoard", gwidth/2 - 105, gheight- 500, "cupBoard");
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

  TaskSweep taskSweep = new TaskSweep("taskSweep", "tasks/sweep/taskSweepBackground.png", startSweepArrow, null, "Sweep the hallway", new PVector(155, 52), 175000);

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
  hallway.addGameObject(bk2deskBackArrow);
  //<-- hallway

  //bathroom 1: shower -->
  Scene bathroom = new Scene("bathroom", "rooms/bathRoom/br1shower.png", "ui/minimap/Bathroom_1.png");

  MoveToSceneObject hallwayBackArrow_bathroom = new MoveToSceneObject("goBackToHallway_bathroom", gwidth - 105, gheight / 2, true);
  hallwayBackArrow_bathroom.setQuad(1721.0, 157.5, 1920.0, 99.9, 1920.0, 1800, 1584.0, 1069.2);
  MoveToSceneObject br2sinkArrow = new MoveToSceneObject("goTobr2sink", -5, gheight/2, "ui/arrowLeft.png", "bathroomSink");

  bathroom.addGameObject(hallwayBackArrow_bathroom);
  bathroom.addGameObject(br2sinkArrow);

  TrashObject trash12 = new TrashObject("trash12", 1392.0, 871, "trash/BCan2.png", sfxTrash4, 13500);
  bathroom.addTrash(trash12);

  TrashObject trash13 = new TrashObject("trash13", 652.8, 969.6, "trash/Cup5(Slightly_edited).png", sfxTrash4, 15000);
  bathroom.addTrash(trash13);

  TrashObject trash14 = new TrashObject("trash14", 808.4, 726.4, "trash/ConfettiMed.png", sfxTrash3, 30000);
  bathroom.addTrash(trash14);
  //<-- bathroom 1: shower

  //bathroom 2: sink -->
  Scene bathroomSink = new Scene("bathroomSink", "rooms/bathRoom/br2sink.png", "ui/minimap/Bathroom_2.png");

  MoveToSceneObject br1showerBackArrow = new MoveToSceneObject("goBackTobr1shower", gwidth-105, gheight/2, "ui/arrowRight.png", true);
  MoveToSceneObject br1showerHallWayArrow = new MoveToSceneObject("goBackToHallway", 0, gheight/2, true);
  br1showerHallWayArrow.setQuad(0, -15, 140.4, 72.0, 296.4, 1080, 0, 1080);
  br1showerHallWayArrow.setBackAmount(2);

  bathroomSink.addGameObject(br1showerBackArrow);
  bathroomSink.addGameObject(br1showerHallWayArrow);

  Collectable plate1 = new Collectable("plate1", "collectables/PlateDirty1.png");
  CollectableObject plate1co = new CollectableObject("plate1co", 1015, 465, "rooms/bathRoom/PlateDirty1.png", sfxTrash1, plate1);
  bathroomSink.addGameObject(plate1co);

  TrashObject trash1 = new TrashObject("trash1", 808.8, 758.4, "trash/Vomit.png", sfxTrash4, 50000);
  bathroomSink.addTrash(trash1);

  TrashObject trash15 = new TrashObject("trash15", 527.2, 670.0, "trash/Partyhat1.png", sfxTrash2, 45000);
  bathroomSink.addTrash(trash15);

  TrashObject trash16 = new TrashObject("trash16", 1236.0, 950.4, "trash/PaperBall.png", sfxTrash3, 12000);
  bathroomSink.addTrash(trash16);
  //<-- bathroom 2: sink

  //livingroom 1: reading -->
  Scene livingRoomReading = new Scene("livingRoomReading", "rooms/livingRoom/lr1reading.png", "ui/minimap/Living_Room_1.png");

  MoveToSceneObject hallwaybackArrow_livingroom = new MoveToSceneObject("goBackToHallway_livingroom", gwidth/3, gheight - 300, true);
  hallwaybackArrow_livingroom.setQuad(334.8, 86.4, 770.4, 102.0, 796.8, 818, 428, 878.4);
  MoveToSceneObject kitchenArrow = new MoveToSceneObject("goToKitchen", -5, gheight/2, "ui/arrowLeft.png", "kitchen");
  MoveToSceneObject TVArrow = new MoveToSceneObject("goToTV", gwidth - 105, gheight/2, "ui/arrowRight.png", "LivingRoomTV");

  livingRoomReading.addGameObject(hallwaybackArrow_livingroom);
  livingRoomReading.addGameObject(kitchenArrow);
  livingRoomReading.addGameObject(TVArrow);

  TrashObject trash17 = new TrashObject("trash17", 510.8, 850.6, "trash/ConfettyBig.png", sfxTrash3, 27500);
  livingRoomReading.addTrash(trash17);

  TrashObject trash18 = new TrashObject("trash18", 1015.2, 58.4, "trash/Cup4.png", sfxTrash4, 14000);
  livingRoomReading.addTrash(trash18);

  TrashObject trash19 = new TrashObject("trash19", 1540.8, 668.4, "trash/ChipsBag.png", sfxTrash3, 10000);
  livingRoomReading.addTrash(trash19);

  TrashObject trash20 = new TrashObject("trash20", 1050.4, 800.0, "trash/Partyhat2.png", sfxTrash2, 35000);
  livingRoomReading.addTrash(trash20);
  //<-- livingroom 1: reading

  //livingroom 2: kitchen -->
  Scene kitchen = new Scene("kitchen", "rooms/livingRoom/lr2kitchen.png", "ui/minimap/Kitchen_1.png");

  Collectable sponge = new Collectable("sponge", "collectables/Sponge.png");
  CollectableObject spongeco = new CollectableObject("spongeco", 1334, 610, "rooms/livingRoom/Sponge.png", sfxFolding1, sponge);
  //spongeco.generateHoverImage();

  MoveToSceneObject readingLRBackArrow = new MoveToSceneObject("goBackToLRReading", gwidth - 105, gheight/2, "ui/arrowRight.png", true);
  MoveToSceneObject kitchenGoToTVArrow = new MoveToSceneObject("kitchenGoToTV", -5, gheight/2, "ui/arrowLeft.png", true);
  kitchenGoToTVArrow.setAfterwardsScene("LivingRoomTV");

  Collectable plate5 = new Collectable("plate5", "collectables/PlateDirty5.png");
  CollectableObject plate5co = new CollectableObject("plate5co", 1740, 694, "rooms/livingRoom/PlateDirty5.png", sfxTrash1, plate5);
  kitchen.addGameObject(plate5co);

  //bedroomparents->
  Scene bedroomParents = new Scene("bp", "rooms/bedroomParents/bp.png", "ui/minimap/Bedroom_Parents.png");
  Collectable plate3 = new Collectable("plate3", "collectables/PlateDirty3.png");
  CollectableObject plate3co = new CollectableObject("plate3co", 766, 426, "rooms/bedroomParents/PlateDirty3.png", sfxTrash1, plate3);
  bedroomParents.addGameObject(plate3co);
  //<-bedroomparents

  //folding task
  Collectable[] dishesCollectables = new Collectable[] { plate1, plate2, plate3, plate4, plate5 };
  String[] dishesPileStates = new String[] {
    "piles/dishes/state0empty.png", 
    "piles/dishes/state1.png", 
    "piles/dishes/state2.png", 
    "piles/dishes/state3.png", 
    "piles/dishes/state4.png", 
    "piles/dishes/state5.png"};
  MoveToSceneObject startDishArrow = new MoveToSceneObject("startDishArrow", 508, 549, "rooms/livingRoom/counterDirtyStart.png", "taskDish");
  RequireObject requireSponge = new RequireObject("requireSponge", 508, 549, "rooms/livingRoom/counterDirty.png", "Wash the dishes with a sponge!", sponge, (GameObject)startDishArrow);
  RequireObject requirePlates = new RequireObject("requirePlates", 1152.0, 571.2, dishesPileStates, "Bring all dirty plates here", dishesCollectables, (GameObject)requireSponge);

  GameObject endDish = new GameObject("endDish", 516, 560, "rooms/livingRoom/inRackClean.png");
  endDish.setClickable(false);
  TaskDish taskDish = new TaskDish("taskDish", "tasks/dishes/bg.png", startDishArrow, endDish, "Do the dishes", new PVector(101, 57), 100000);

  kitchen.addGameObject(kitchenGoToTVArrow);
  kitchen.addGameObject(readingLRBackArrow);
  kitchen.addGameObject(requirePlates);
  kitchen.addGameObject(spongeco);

  TrashObject trash21 = new TrashObject("trash21", 807.6, 900.0, "trash/Pizza.png", sfxTrash4, 12500);
  kitchen.addTrash(trash21);

  TrashObject trash22 = new TrashObject("trash22", 264.0, 260.6, "trash/egg.png", sfxTrash2, 13000);
  kitchen.addTrash(trash22);

  Collectable clothes2 = new Collectable("clothes2", "collectables/StoolShirt.png");
  CollectableObject clothes2co = new CollectableObject("clothes2co", 942.4, 643.4, "rooms/livingRoom/StoolShirt.png", sfxFolding2, clothes2);
  kitchen.addGameObject(clothes2co);

  TrashObject trash24 = new TrashObject("trash24", 1472.4, 966.0, "trash/Cup5(Slightly_edited).png", sfxTrash4, 15000);
  kitchen.addTrash(trash24);

  Collectable clothes3 = new Collectable("clothes3", "collectables/Cap.png");
  CollectableObject clothes3co = new CollectableObject("clothes3co", 600, 631, "rooms/livingRoom/CapR.png", sfxFolding2, clothes3);
  kitchen.addGameObject(clothes3co);
  //<-- livingroom 2: kitchen

  //livingroom 3: tv -->
  Scene livingRoomTV = new Scene("LivingRoomTV", "rooms/livingRoom/lr3tv.png", "ui/minimap/Living_Room_2.png");

  MoveToSceneObject readingLRBackArrow2 = new MoveToSceneObject("goBackToLRReading2", -5, gheight /2, "ui/arrowLeft.png", true);
  MoveToSceneObject bpArrow = new MoveToSceneObject("goTobp", 1300, gheight/2, "bp");
  bpArrow.setQuad(1214.0, 634, 1487.0, 741, 1651.0, 32, 1276.0, 62);


  MoveToSceneObject tvGoToKitchenArrow = new MoveToSceneObject("tvGoToKitchenArrow", gwidth - 105, gheight/2, "ui/arrowRight.png", true);
  tvGoToKitchenArrow.setAfterwardsScene("kitchen");


  Quad vacuumQuad = new Quad(949.2, 530.4, 1309.2, 670.8, 590, 1080, 0, 840);
  MoveToSceneObject startVacuumArrow = new MoveToSceneObject("goToVacuumTask", 117, 531, "rooms/livingRoom/dustStart.png", "taskVacuum");
  startVacuumArrow.setQuad(vacuumQuad);
  RequireObject startVacuum = new RequireObject("startVacuum", 117, 531, "rooms/livingRoom/dust.png", "Use a vacuum to suck up this dust!", vacuum, (GameObject)startVacuumArrow);
  startVacuum.setQuad(vacuumQuad);
  TaskVacuum taskVacuum = new TaskVacuum("taskVacuum", "tasks/vacuum/rug.png", startVacuumArrow, null, "Vacuum the livingroom", new PVector(80, 134), 125000);

  livingRoomTV.addGameObject(tvGoToKitchenArrow);
  livingRoomTV.addGameObject(readingLRBackArrow2);
  livingRoomTV.addGameObject(bpArrow);
  livingRoomTV.addGameObject(startVacuum);

  Collectable clothes4 = new Collectable("clothes4", "collectables/LivingRoomShirt.png");
  CollectableObject clothes4co = new CollectableObject("clothes4co", 793.2, 587.4, "rooms/livingRoom/Shirt.png", sfxFolding1, clothes4);
  livingRoomTV.addGameObject(clothes4co);

  TrashObject trash27 = new TrashObject("trash27", 724.8, 345.8, "trash/Sock2.png", sfxFolding1, 16000);
  livingRoomTV.addTrash(trash27);

  TrashObject trash28 = new TrashObject("trash28", 577.2, 978.0, "trash/PaperBall.png", sfxTrash2, 10000);
  livingRoomTV.addTrash(trash28);

  TrashObject trash29 = new TrashObject("trash29", 1250.6, 743.2, "trash/Partyhat1.png", sfxTrash3, 35000);
  livingRoomTV.addTrash(trash29);
  //<-- livingroom 3: tv


  //bedroom parents -->

  MoveToSceneObject TvBackArrow = new MoveToSceneObject("goBackToTv", gwidth/2, gheight - 105, "ui/arrowDown.png", true);

  //folding task
  Collectable[] foldingCollectables = new Collectable[] { clothes1, clothes2, clothes3, clothes4 };
  String[] foldingPileStates = new String[] {
    "piles/clothes/state0empty.png", 
    "piles/clothes/state1.png", 
    "piles/clothes/state2.png", 
    "piles/clothes/state3.png", 
    "piles/clothes/state4.png"};
  MoveToSceneObject foldingTask = new MoveToSceneObject("goToFoldingTask", 777.6, 511.2, "piles/clothes/state4start.png", "TaskFolding");
  RequireObject startFolding = new RequireObject("startFolding", 777.6, 511.2, foldingPileStates, "Bring all clothes here", foldingCollectables, (GameObject)foldingTask);
  TaskFolding taskFolding = new TaskFolding("TaskFolding", "tasks/folding/FoldingBackground.png", foldingTask, null, "Fold the clothes", new PVector(38, 88), 130500);

  bedroomParents.addGameObject(startFolding);

  bedroomParents.addGameObject(TvBackArrow);

  TrashObject trash30 = new TrashObject("trash30", 430.0, 530.6, "trash/Bottle.png", sfxTrash1, 40000);
  bedroomParents.addTrash(trash30);

  TrashObject trash31 = new TrashObject("trash31", 1560.8, 885.6, "trash/BCan2.png", sfxTrash4, 45000);
  bedroomParents.addTrash(trash31);

  TrashObject trash32 = new TrashObject("trash32", 1283.6, 580.2, "trash/ConfettySmol.png", sfxTrash2, 60000);
  bedroomParents.addTrash(trash32);
  //<-- bedroom parents

  //endscreen -->
  EndScreen endscreen = new EndScreen("endscreen");
  //<-- endscreen

  sceneManager.addScene(mainMenu);
  sceneManager.addScene(introVideoScene);
  sceneManager.addScene(bk1beds);
  sceneManager.addScene(bk2desk);
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
  sceneManager.addScene(endscreen);

  mouse = screenScale(new PVector(mouseX, mouseY));

  //try {
  //  sceneManager.goToScene("taskDish");
  //} 
  //catch(Exception e) {
  //  println(e);
  //}
  canvas.endDraw();

  millisAtGameStart = millis();
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

  if (inGame()) {
    inventoryManager.draw();
    taskTracker.draw();
  } else if (sceneManager.getCurrentScene() instanceof Task) {
    canvas.pushMatrix();
    canvas.translate(-82, 1048);
    if (sceneManager.getCurrentScene() instanceof TaskVacuum)
      canvas.translate(45, 0);
    drawTimer();
    canvas.popMatrix();
  }

  if (debugMode) {
    canvas.stroke(255, 0, 0);
    canvas.strokeWeight(5);
    canvas.point(mouse.x, mouse.y);
  }

  millisLeft = 5 * 60 * 1000 - (millis() - millisAtGameStart);
  if (score == scoreMax || millisLeft <= 0 && !(sceneManager.getCurrentScene() instanceof EndScreen)) {
    endGame();
  }

  //hacky sound starters
  if (!sndTheme2.isPlaying() && almostEqual(sndTheme1.duration()*1000, float(millis() - millisAtGameStart), 50)) {
    if (debugMode) println("sndTheme2.play()", sndTheme1.duration()*1000, millis() - millisAtGameStart);
    sndTheme2.play();
  }

  if (!sndTheme3.isPlaying() && almostEqual(sndTheme3.duration()*1000, millisLeft, 1000)) {
    if (debugMode) println("sndTheme3.play()", sndTheme2.duration()*1000, millis() - millisAtGameStart);
    sndTheme3.play();
  }

  //if (debugMode) canvas.image(loadImage("rooms/livingRoom/CapR.png"), mouse.x, mouse.y);

  canvas.endDraw();

  if (fullHD) {
    image(canvas, 0, 0);
  } else {
    //Thanks to hamoid at https://discourse.processing.org/t/faster-pimage-resizing/33593/16 for helping make this way faster!
    image(canvas, 0, 0, width, height);
  }

  if (debugMode) { 
    text(frameRate, 10, 10);
    text(score + "/" + scoreMax, 10, 40);
    text(millisLeft, 10, 70);
    text(sndTheme1.isPlaying() ? "1playing" : "1not", 10, 100); 
    text(sndTheme2.isPlaying() ? "2playing" : "2not", 10, 130); 
    text(sndTheme3.isPlaying() ? "3playing" : "3not", 10, 160);
  }

  if (analytics && frameCount % 30 == 0) analyticRecord("mousePosition");
}

void endGame() {
  try {
    sceneManager.goToScene("endscreen");
  } 
  catch (Exception e) {
    println(e);
  }
  EndScreen es = (EndScreen)sceneManager.getCurrentScene();
  es.calculateScore();
  score += millisLeft;
  if (score < 0) score = 0;
}

void exit() {
  println("exiting");
  saveTable(highscores, "data/highscores.csv");
  if (analytics) {
    analyticRecord("exit");
    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
    Date now = new Date();
    String strDate = sdfDate.format(now);
    saveTable(analyticsTable, "analytics/" + strDate + ".csv");
  }
  super.exit();
}

void mouseMoved() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
  if (inGame()) {
    inventoryManager.mouseMoved();
    taskTracker.mouseMoved();
  }
}

void mouseDragged() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  sceneManager.getCurrentScene().mouseMoved();
  if (inGame()) {
    inventoryManager.mouseMoved();
    taskTracker.mouseMoved();
  }
}

void mouseReleased() {
  mouse = screenScale(new PVector(mouseX, mouseY));
  if (debugMode) println("new PVector(" + mouse.x + ", " + mouse.y + ");");
  sceneManager.getCurrentScene().mouseMoved();
  sceneManager.getCurrentScene().mouseClicked();
  sceneManager.getCurrentScene().mouseMoved();
  if (inGame()) {
    inventoryManager.mouseClicked();
    taskTracker.mouseClicked();
  }
  if (analytics) analyticRecord("mouseReleased");
}

void keyPressed() {
  if (!(sceneManager.getCurrentScene() instanceof EndScreen)) {
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
      if (key == 'e') endGame();
    }
  }
  sceneManager.getCurrentScene().keyPressed();
  inventoryManager.keyPressed();
  if (analytics) analyticRecord(String.valueOf(key));
}


void analyticRecord(String action) {
  TableRow newRow = analyticsTable.addRow();
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
    cursorInt = c;
    if (debugMode) println("Changed cursor to:", cursorInt);
  }
}

void setCursor(PImage p) {
  cursor(p);
}

boolean inGame() {
  return !(sceneManager.getCurrentScene() instanceof Task 
    ||     sceneManager.getCurrentScene() instanceof MainMenu 
    ||     sceneManager.getCurrentScene() instanceof IntroVideoScene
    ||     sceneManager.getCurrentScene() instanceof EndScreen);
}

boolean almostEqual(float a, float b, float ep) {
  //https://stackoverflow.com/a/4915479/8109619
  return (a == b || (a - b) < ep && (b - a) < ep);
}
