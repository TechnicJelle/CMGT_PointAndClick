class TaskSweep extends Task {

  TaskSweep(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter) {
    super(sceneName, backgroundImageFile, sceneStarter);
  }

  PVector[] trashPos;
  PVector[] trashVel;
  PVector[] trashAcc;
  float[] trashSize;
  boolean[] trashDone;

  int size;

  GameObject curable;

  PVector broomCenter;
  Quad broomHitBox;


  void setup() {
    //size = int(random(60, 120));
    size = 1;
    trashPos = new PVector[size];
    trashVel = new PVector[size];
    trashAcc = new PVector[size];
    trashSize = new float[size];
    trashDone = new boolean[size];

    for (int i = 0; i < size; i++) {
      trashPos[i] = new PVector(random(gwidth), random(gheight));
      trashVel[i] = PVector.random2D();
      trashAcc[i] = new PVector(0, 0);
      trashSize[i] = random(12, 24);
      trashDone[i] = false;
    }
    broomCenter = new PVector(0, 0);
    PVector broomSize = new PVector(200, 70);
    broomHitBox = new Quad(broomCenter, broomSize);
    curable = new GameObject("curable", gwidth-100, gheight/2, "tasks/sweep/curable.png", true);
    curable.setQuad(1729.2, 453.6, 1863.6, 478.8, 1857.6, 596.4, 1726.8, 630.0);
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

        if (broomHitBox.clickCheck(pos))
          acc.add(diff);

        vel.mult(0.9);
        vel.add(acc);
        pos.add(vel);
        acc.mult(0);
      }
      canvas.stroke(0);
      canvas.strokeWeight(2);
      canvas.fill(255);
      canvas.circle(trashPos[i].x, trashPos[i].y, trashSize[i]);
    }

    //canvas.stroke(255, 0, 0);
    //canvas.strokeWeight(5);
    //line(broom.x, broom.y, broom.x + diff.x, broom.y + diff.y);

    canvas.stroke(0);
    canvas.stroke(0);
    canvas.strokeWeight(2);
    canvas.fill(255);
    broomHitBox.draw();
    //broomHitBox.drawDebug(color(255, 0, 0));

    if (allDone) {
      sceneManager.goToPreviousScene();
      sceneManager.getCurrentScene().removeGameObject(sceneStarter);
    }

    //canvas.pushMatrix();
    //canvas.translate(broomCenter.x, broomCenter.y);
    //canvas.rotate(diff.heading() + HALF_PI);
    //canvas.translate(-100, 0);
    //canvas.stroke(0);
    //canvas.strokeWeight(2);
    //canvas.fill(255);
    //canvas.rect(0, 0, 200, 70);
    //canvas.popMatrix();

    broomHitBox.popMatrix();
  }
}
