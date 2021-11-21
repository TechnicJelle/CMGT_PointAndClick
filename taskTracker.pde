class TaskTracker {
  PImage phone;
  boolean phoneUp = false;
  
  private boolean btm, top;

  TaskTracker() {
    phone = loadImage("ui/HandPhone.png");
  }

  void draw() {
    if (phoneUp) {
      canvas.image(phone, 0, 574);
    } else {
      canvas.image(phone, 0, 900);
    }
    //canvas.stroke(0);
    //canvas.strokeWeight(1);
    //canvas.noFill();
    //canvas.rect(0, gheight-phone.height, phone.width, gheight);
    //canvas.rect(0, 900, phone.width, gheight);
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
