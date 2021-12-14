void drawTimer() {
  changeFontSize(34);
 fill(0);
 text((millisLeft / 1000) / 60 + ":" + nf((millisLeft / 1000.0f) % 60.0f, 2, 2), 89, -7);
}

class TaskTracker {
  ArrayList<Task> tasks;
  int currentTask;

  PImage phone;
  boolean phoneUp = false;

  PImage taskTodo;
  PImage taskDone;
  PImage taskDoneMinimap;

  PImage imgPinned;
  PImage imgNotPinned;

  GameObject pin;
  boolean pinned;

  private boolean btm, top;

  TaskTracker() {
    tasks = new ArrayList<Task>();
    currentTask = -1;
    phone = loadImage("ui/HandPhone.png");
    taskTodo = loadImage("ui/TaskTodo.png");
    taskDone = loadImage("ui/TaskDone.png");
    taskDoneMinimap = loadImage("ui/minimap/CheckIcon.png");

    pin = new GameObject("taskTrackerPin", 0, 0, "ui/minimap/NotPinnedIcon.png");
    putPhoneDown();

    imgPinned = loadImage("ui/minimap/PinnedIcon.png");
    imgNotPinned = loadImage("ui/minimap/NotPinnedIcon.png");
  }

  void addTask(Task t) {
    tasks.add(t);
  }

  void draw() {
   pushMatrix();
    if (phoneUp) {
     translate(0, 574);
    } else {
     translate(0, 900);
    }
   image(phone, 0, 0);

    if (debugMode) {
     stroke(0);
     strokeWeight(1);
     noFill();
     rect(0, 0, phone.width, gheight);
     rect(0, 326, phone.width, 180);
    }

    //timer
   translate(210, 7);
    drawTimer();

    //tasks
   translate(0, 24);
    changeFontSize(32);
    for (int i = 0; i < tasks.size(); i++) {
      Task task = tasks.get(i);
      PImage img = task.completed ? taskDone : taskTodo;
     image(img, 0, fontSize*(i+1)-img.height);
      drawText(task.description, 36, fontSize*i);
    }

    //minimap
   translate(0, 119);
   image(sceneManager.getCurrentScene().minimapImage, 0, 0);
    for (int i = 0; i < tasks.size(); i++) {
      Task task = tasks.get(i);
     pushStyle();
     imageMode(CENTER);
      if (task.completed) {
       image(taskDoneMinimap, task.minimapLocation.x, task.minimapLocation.y);
      } else {
       image(task.minimapIcon, task.minimapLocation.x, task.minimapLocation.y);
      }
     popStyle();
    }

   popMatrix();

    pin.draw();
  }

  void mouseMoved() {
    pin.mouseMoved();
    btm = pointInRect(mouse.x, mouse.y, 0, 900, phone.width, gheight);
    top = pointInRect(mouse.x, mouse.y, 0, gheight-phone.height, phone.width, gheight);
    if (btm)
      putPhoneUp();
    if (phoneUp && top)
      return;
    if (!top && !pinned)
      putPhoneDown();
  }

  void putPhoneUp() {
    phoneUp = true;
    pin.setXY(426.0, 600.0, true);
  }

  void putPhoneDown() {
    phoneUp = false;
    pin.setXY(426, 926.4, true);
  }

  boolean mouseClicked() {
    if (pin.mouseClicked()) {
      pinned = !pinned;
      if (pinned) {
        pin.setGameObjectImage(imgPinned);
      } else {
        pin.setGameObjectImage(imgNotPinned);
      }
      return true;
    }
    return false;
  }
}
