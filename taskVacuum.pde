class TaskVacuum extends Task {

  TaskVacuum(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc, PVector minimapLocation, PImage minimapIcon, int sa) {
    super(sceneName, backgroundImageFile, sceneStarter, replaceWith, desc, minimapLocation, minimapIcon, sa);
  }

  PVector[] dustP;
  PVector[] dustV;
  PImage speck;
  int specks = 100000;
  int sucked = 0;

  float vacuumSize = 64;

  PImage head;

  PVector diff;
  PVector mse;

  void setup() {
    setCursor(ARROW);
    speck = loadImage("tasks/vacuum/speck.png");
    head = loadImage("tasks/vacuum/vacuum.png");
    dustP = new PVector[specks];
    dustV = new PVector[specks];
    for (int i = 0; i < specks; i++) {
      dustP[i] = new PVector(random(gwidth), random(gheight));
      dustV[i] = PVector.random2D();
    }
    diff = new PVector(0, 0);
    mse = mouse.copy();
    sfxVacuumStart.play();
  }


  void draw() {
    canvas.image(backgroundImage, 0, 0);
    canvas.tint(128);
    if (!sfxVacuumStart.isPlaying() && !sfxVacuumRunning.isPlaying()) sfxVacuumRunning.play();
    for (int i = 0; i < specks; i++) {
      if (dustP[i] == null) 
        continue;
      PVector p = dustP[i];
      PVector v = dustV[i];
      diff = PVector.sub(mse, p);
      if (diff.magSq() < sq(vacuumSize)) {
        dustP[i] = null;
        sucked++;
        continue;
      }
      v.add(diff.mult(pow(1000.0f/diff.magSq(), 1.8)));

      v.mult(0.9);
      p.add(v);
      canvas.image(speck, p.x, p.y);
    }
    canvas.noTint();

    canvas.pushStyle();
    canvas.imageMode(CENTER);
    canvas.image(head, mse.x, mse.y);
    canvas.popStyle();

    float x1 = -100;
    float y1 = gheight/2;
    float x2 = 200;
    float y2 = y1;
    float x3 = mse.x-300 - mse.x/2 + map(noise(millis()/3000.0f+99999), 0, 1, -200, 200);
    float y3 = mse.y + map(noise(millis()/3000.0f), 0, 1, -200, 200);
    //float y3 = mouse.y-0.5;
    float x4 = mse.x-47;
    float y4 = mse.y-0.4;

    canvas.strokeCap(ROUND);
    canvas.strokeJoin(ROUND);
    canvas.noFill();

    canvas.strokeWeight(28.5);
    canvas.stroke(0);
    canvas.bezier(x1, y1, x2, y2, x3, y3, x4, y4);

    canvas.strokeWeight(20.5);
    canvas.stroke(75);
    canvas.bezier(x1, y1, x2, y2, x3, y3, x4, y4);

    if (float(sucked)/specks > 0.99f) {
      sfxVacuumStop.play();
      sfxVacuumRunning.stop();
      done();
    }
  }

  void mouseUpdate() {
    mse.x = constrain(mouse.x, 66, 1856);
    mse.y = constrain(mouse.y, 132, 948);
  }

  void mouseMoved() {
    mouseUpdate();
  }

  void mouseDragged() {
    mouseUpdate();
  }
}
