class TaskSweep extends Task {

  TaskSweep(String sceneName, String backgroundImageFile) {
    super(sceneName, backgroundImageFile);
  }

  PVector[] trashPos;
  PVector[] trashVel;
  PVector[] trashAcc;
  float[] trashSize;

  int size;

  PVector broom;
  PVector broomHitBox;
  PVector broomSize;


  void setup() {
    size = int(random(60, 120));
    trashPos = new PVector[size];
    trashVel = new PVector[size];
    trashAcc = new PVector[size];
    trashSize = new float[size];

    for (int i = 0; i < size; i++) {
      trashPos[i] = new PVector(random(gwidth), random(gheight));
      trashVel[i] = PVector.random2D();
      trashAcc[i] = new PVector(0, 0);
      trashSize[i] = random(12, 24);
    }
    broom = new PVector(0, 0);
    broomSize = new PVector(200, 70);
  }

  void draw() {
    canvas.image(backgroundImage, 0, 0);

    PVector diff = PVector.sub(mouse, broom);
    broom = broom.add(diff.mult(0.1f));
    canvas.stroke(255, 0, 0);
    canvas.strokeWeight(5);
    //line(broom.x, broom.y, broom.x + diff.x, broom.y + diff.y);

    canvas.pushMatrix();
    canvas.translate(broom.x, broom.y);
    canvas.rotate(diff.heading() + HALF_PI);
    canvas.stroke(0);
    canvas.strokeWeight(2);
    canvas.fill(255);
    canvas.rect(-broomSize.x/2.0f, 0, broomSize.x, broomSize.y);
    canvas.popMatrix();

    for (int i = size-1; i >= 0; i--) {
      PVector pos = trashPos[i];
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

      if (dist(pos.x, pos.y, broom.x, broom.y) < 50)
        acc.add(diff);

      vel.mult(0.9);
      vel.add(acc);
      pos.add(vel);
      acc.mult(0);
      canvas.circle(trashPos[i].x, trashPos[i].y, 16);
    }
  }
}
