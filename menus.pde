class MainMenu extends Scene {

  PImage pattern = loadImage("menus/main/pattern.png");
  int perPattern = 7;

  MainMenu(String sceneName, String backgroundImageFile) {
    super(sceneName, backgroundImageFile, null);
  }

  void draw() {

    canvas.background(lerpColor(#78C8A1, #F69E86, (((millis()/5000)%2==0)?millis()%5000:5000-millis()%5000)/5000.0));

    for (int i = 0; i < perPattern; i++)
    {
      canvas.image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, 0);
      canvas.image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, pattern.height);
    }
    super.draw(); //draws backgroundImage and all objects (the buttons)

    if (!introVideoLoaded)
      canvas.text("Loading intro video...", 50, 50);

    millisAtGameStart = millis();
  }

  void mouseClicked() {
    if (introVideoLoaded) super.mouseClicked();
  }
}

class IntroVideoScene extends Scene {

  boolean firstTime = true;

  IntroVideoScene(String sceneName, String backgroundImageFile) {
    super(sceneName, backgroundImageFile, null);
  }

  void draw() {
    if (firstTime) {
      introVideo.play();
      firstTime = false;
    }

    if (introVideo.available())
      introVideo.read();

    canvas.image(introVideo, 0, 0);

    if (introVideo.time() < 2)
      canvas.text("Press space to skip", 50, 50);

    if (introVideo.duration() - introVideo.time() < 0.2)
      canvas.text("Press space to start the game!", 50, 50);

    if (debugMode)
      println(introVideo.duration()  + " - " + introVideo.time() + " = " + (introVideo.duration() - introVideo.time()), frameRate);

    //if (introVideo.time() >= introVideo.duration() - 0.01) {
    //  end();
    //}

    millisAtGameStart = millis();
  }

  private void end() {
    try {
      sceneManager.goToScene("bk2beds");
      introVideo = null; //allow the gc to clear the video from memory
    } 
    catch (Exception e) {
      println(e);
    }
  }

  void keyPressed() {
    if (key == ' ') end();
  }
}

void loadVideo() {
  introVideo = new Movie(this, "menus/main/introVideo.mp4");
  introVideoLoaded = true;
}

void movieEvent(Movie m) {
  m.read();
}

class EndScreen extends Scene {

  PImage parentsHappy;
  PImage parentsNeutral;
  PImage parentsAngry;

  EndScreen(String sceneName) {
    super(sceneName, "menus/end/parentsAngry.png", null);
    parentsHappy = loadImage("menus/end/parentsHappy.png");
    parentsNeutral = loadImage("menus/end/parentsNeutral.png");
    parentsAngry = loadImage("menus/end/parentsAngry.png");
  }

  void calculateScore() {
    if (score == scoreMax) backgroundImage = parentsHappy;
    else if (score >= scoreMax*2.0/3.0) backgroundImage = parentsNeutral;
    else backgroundImage = parentsAngry;
  }

  void draw() {
    canvas.image(backgroundImage, 0, 0);
    canvas.text("Score: " + score, 500, 500);
  }
}
