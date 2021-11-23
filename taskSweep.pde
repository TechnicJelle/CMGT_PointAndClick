class TaskSweep extends Task {

  TaskSweep(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc, PVector minimapLocation) {
    super(sceneName, backgroundImageFile, sceneStarter, replaceWith, desc, minimapLocation);
  }

  PImage[] trashImgs;

  int size;
  PVector[] trashPos;
  PVector[] trashVel;
  PVector[] trashAcc;
  int[] trashImg;
  boolean[] trashDone;

  GameObject curable;

  PVector broomCenter;
  Quad broomHitBox;

  PImage broomCursor;


  void setup() {
    setCursor(ARROW);
    trashImgs = new PImage[4];
    trashImgs[0] = loadImage("tasks/sweep/JunkChips1.png");
    trashImgs[1] = loadImage("tasks/sweep/JunkChips2.png");
    trashImgs[2] = loadImage("tasks/sweep/JunkPopcorn1.png");
    trashImgs[3] = loadImage("tasks/sweep/JunkPopcorn2.png");

    if (debugMode) {
      size = 50;
    } else {
      size = int(random(30, 50));
    }
    trashPos = new PVector[size];
    trashVel = new PVector[size];
    trashAcc = new PVector[size];
    trashImg = new int[size];
    trashDone = new boolean[size];

    for (int i = 0; i < size; i++) {
      trashPos[i] = new PVector(random(gwidth), random(gheight));
      trashVel[i] = PVector.random2D();
      trashAcc[i] = new PVector(0, 0);
      trashImg[i] = int(random(trashImgs.length));
      trashDone[i] = false;
    }

    broomCenter = new PVector(0, 0);
    PVector broomSize = new PVector(200, 70);
    broomHitBox = new Quad(broomCenter, broomSize);
    curable = new GameObject("curable", gwidth, gheight/2, "tasks/sweep/CurableFullSize.png", true);
    curable.setQuad(1684.8, 355.2, 1920, 412.8, 1920, 650, 1689.6, 715.2);
    curable.setClickable(false);

    broomCursor = loadImage("tasks/sweep/BroomCursor.png");
  }

  void draw() {
    canvas.image(backgroundImage, 0, 0);
    curable.draw();

    PVector diff = PVector.sub(mouse, broomCenter).mult(0.1f);
    broomCenter.add(diff);
    broomHitBox.translate(diff);
    broomHitBox.pushMatrix();
    broomHitBox.rotate(broomCenter, diff.heading());
    PVector offset = diff.copy().rotate(-HALF_PI).setMag(100);
    broomHitBox.translate(offset);

    boolean allDone = true;

    for (int i = size-1; i >= 0; i--) {
      PVector pos = trashPos[i];
      if (curable.pointInGameObject(pos))
        trashDone[i] = true;

      if (!trashDone[i]) {
        allDone = false;
        PVector vel = trashVel[i];
        PVector acc = trashAcc[i];

        if (pos.x <= 0) {
          pos.x = 0;
          vel.x *= -0.9;
        }
        if (pos.x >= gwidth) {
          pos.x = gwidth;
          vel.x *= -0.9;
        }
        if (pos.y <= 0) {
          pos.y = 0;
          vel.y *= -0.9;
        }
        if (pos.y >= gheight) {
          pos.y = gheight;
          vel.y *= -0.9;
        }

        if (broomHitBox.pointCheck(pos))
          acc.add(diff);

        vel.mult(0.9);
        vel.add(acc);
        pos.add(vel);
        acc.mult(0);
      }
      if (debugMode) {
        canvas.stroke(0);
        canvas.strokeWeight(2);
        canvas.fill(255);
        canvas.circle(trashPos[i].x, trashPos[i].y, 50);
      }
      canvas.pushStyle();
      canvas.imageMode(CENTER);
      canvas.image(trashImgs[trashImg[i]], trashPos[i].x, trashPos[i].y);
      canvas.popStyle();
    }

    //canvas.stroke(255, 0, 0);
    //canvas.strokeWeight(5);
    //line(broom.x, broom.y, broom.x + diff.x, broom.y + diff.y);

    if (debugMode) {
      canvas.stroke(0);
      canvas.strokeWeight(2);
      canvas.fill(255);
      broomHitBox.draw();
      canvas.stroke(255, 0, 0);
      canvas.strokeWeight(1);
      canvas.noFill();
      broomHitBox.drawDebug();
    }

    if (allDone) {
      done();
    }

    canvas.pushMatrix();
    canvas.translate(broomCenter.x, broomCenter.y);
    canvas.rotate(diff.heading() + HALF_PI);
    canvas.translate(-100, 0);
    //canvas.stroke(0);
    //canvas.strokeWeight(2);
    //canvas.fill(255);
    //canvas.rect(0, 0, 200, 70);
    canvas.image(broomCursor, 0, 0);
    canvas.popMatrix();

    broomHitBox.popMatrix();
  }
}
