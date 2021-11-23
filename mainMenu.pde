class MainMenu extends Scene {

  PImage pattern = loadImage("pattern.png");
  int perPattern = 7;

  MainMenu(String sceneName, String backgroundImageFile) {
    super(sceneName, backgroundImageFile, null);
  }

  void draw() {
    super.draw();
    canvas.background(lerpColor(#78C8A1, #F69E86, (((millis()/5000)%2==0)?millis()%5000:5000-millis()%5000)/5000.0));

    for (int i = 0; i < perPattern; i++)
    {
      canvas.image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, 0);
      canvas.image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, pattern.height);
    }
    canvas.image(backgroundImage, 0, 0);

    if (!introVideoLoaded)
      canvas.text("Loading intro video...", 50, 50);
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
    if (introVideo.time() < 5)
      canvas.text("Press space to skip", 50, 50);
    if (debugMode) println(introVideo.time(), introVideo.duration());
    if (introVideo.time() >= introVideo.duration() - 0.01) {
      end();
    }
  }

  private void end() {
    try {
      sceneManager.goToScene("bk2beds");
      introVideo = null; //allow the gc to clear the video from memory
      millisAtGameStart = millis();
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
  introVideo = new Movie(this, "introVideo.mp4");
  introVideoLoaded = true;
}

void movieEvent(Movie m) {
  m.read();
}
