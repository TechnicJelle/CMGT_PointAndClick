class TaskTracker {
  ArrayList<Task> tasks;
  int currentTask;

  PImage phone;
  boolean phoneUp = false;

  PImage taskTodo;
  PImage taskDone;

  private boolean btm, top;

  TaskTracker() {
    tasks = new ArrayList<Task>();
    currentTask = -1;
    phone = loadImage("ui/HandPhone.png");
    taskTodo = loadImage("ui/TaskTodo.png");
    taskDone = loadImage("ui/TaskDone.png");
  }

  void addTask(Task t) {
    tasks.add(t);
  }

  void draw() {
    canvas.pushMatrix();
    if (phoneUp) {
      canvas.translate(0, 574);
    } else {
      canvas.translate(0, 900);
    }
    canvas.image(phone, 0, 0);

    if (debugMode) {
      canvas.stroke(0);
      canvas.strokeWeight(1);
      canvas.noFill();
      canvas.rect(0, 0, phone.width, gheight);
      canvas.rect(0, 326, phone.width, 180);
    }

    canvas.translate(209, 7);
    canvas.image(sceneManager.getCurrentScene().minimapImage, 0, 0);

    canvas.translate(0, sceneManager.getCurrentScene().minimapImage.height);
    changeFontSize(32);
    for (int i = 0; i < tasks.size(); i++) {
      Task task = tasks.get(i);
      PImage img = task.completed ? taskDone : taskTodo;
      canvas.image(img, 0, fontSize*(i+1)-img.height);
      drawText(task.description, 42, fontSize*i);
    }





    canvas.popMatrix();
  }

  void mouseMoved() {
    btm = pointInRect(mouse.x, mouse.y, 0, 900, phone.width, gheight);
    top = pointInRect(mouse.x, mouse.y, 0, gheight-phone.height, phone.width, gheight);
    if (btm)
      phoneUp = true;
    if (phoneUp && top)
      return;
    if (!top)
      phoneUp = false;
  }

  void mouseClicked() {
  }
}
