class MainMenu extends Scene {

  PImage pattern = loadImage("menus/main/pattern.png");
  int perPattern = 7;

  boolean highscoreScreen = false;
  PImage highscoreImage;

  GameObject backbutton;

  MainMenu(String sceneName, String backgroundImageFile) {
    super(sceneName, backgroundImageFile, null);

    backbutton = new GameObject("highscoresbackbutton", 0, 0, "menus/main/btn_back.png") {
      public boolean mouseClicked() {
        if (super.mouseClicked()) {
          highscoreScreen = false;
          return true;
        }
        return false;
      }
    };
    backbutton.setXY(gwidth/2, 893, true);
    backbutton.setHoverImage("menus/main/btn_backH.png");
    highscoreImage = loadImage("menus/main/Highscore.png");
  }

  void draw() {

    canvas.background(lerpColor(#78C8A1, #F69E86, (((millis()/5000)%2==0)?millis()%5000:5000-millis()%5000)/5000.0));

    for (int i = 0; i < perPattern; i++)
    {
      canvas.image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, 0);
      canvas.image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, pattern.height);
    }

    if (highscoreScreen) {
      canvas.image(backgroundImage, 0, 0);
      float w = 475;
      canvas.pushStyle();
      canvas.fill(255, 100);
      canvas.stroke(#7f5b84);
      canvas.strokeWeight(6);
      canvas.pushMatrix();
      canvas.translate(gwidth/2-w/2, 300);
      canvas.rect(0, 0, w, 525, 32);

      highscores.trim();
      highscores.sortReverse("score");

      canvas.fill(0);
      for (int i = 0; i < (highscores.getRowCount() < 10 ? highscores.getRowCount() : 10); i++) {
        float y = i * 50 + 10;
        TableRow tr = highscores.getRow(i);
        canvas.textAlign(LEFT, TOP);
        canvas.text(tr.getString("name"), 32, y);
        canvas.textAlign(RIGHT, TOP);
        canvas.text(nfc(tr.getInt("score")), w-32, y);
      }

      canvas.popStyle();
      canvas.popMatrix();

      backbutton.draw();

      canvas.pushStyle();
      canvas.imageMode(CENTER);
      canvas.image(highscoreImage, gwidth/2, 220);
      canvas.popStyle();
    } else {
      super.draw(); //draws backgroundImage and all objects (the buttons)
    }

    if (!mediaLoaded)
      canvas.text("Loading game media assets...", 50, 50);

    millisAtGameStart = millis();
  }

  void mouseMoved() {
    if (highscoreScreen) {
      if (backbutton.mouseMoved()) {
        setCursor(HAND);
      } else {
        setCursor(ARROW);
      }
    } else {
      super.mouseMoved();
    }
  }

  void mouseClicked() {
    if (highscoreScreen) {
      backbutton.mouseClicked();
    } else {
      if (mediaLoaded) super.mouseClicked();
    }
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
      sndTheme2.stop();
    }

    if (introVideo.available())
      introVideo.read();

    canvas.image(introVideo, 0, 0);

    if (introVideo.time() < 2)
      canvas.text("Press space to skip", 50, 50);

    if (introVideo.duration() - introVideo.time() < 0.2) {
      String s = "Objective: Clean up the house before your parents get home!\n\nPress space to start the game!";
      canvas.fill(0);
      canvas.text(s, 52, 53);
      canvas.fill(255);
      canvas.text(s, 50, 50);
    }

    if (debugMode)
      println(introVideo.duration()  + " - " + introVideo.time() + " = " + (introVideo.duration() - introVideo.time()), frameRate);

    //if (introVideo.time() >= introVideo.duration() - 0.01) {
    //  end();
    //}

    millisAtGameStart = millis();
  }

  private void end() {
    try {
      sceneManager.goToScene("bk1beds");
      introVideo = null; //allow the gc to clear the video from memory
      sndTheme1.play();
      if (debugMode) println("sndTheme1 dur: " + sndTheme1.duration());
    } 
    catch (Exception e) {
      println(e);
    }
  }

  void keyPressed() {
    if (key == ' ') end();
  }
}

void movieEvent(Movie m) {
  m.read();
}

class EndScreen extends Scene {

  PImage parentsHappy;
  PImage parentsNeutral;
  PImage parentsAngry;

  boolean textInputting = false;
  String textInputted = "";

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

    textInputting = true;
    textInputted = "";
  }

  void draw() {
    canvas.image(backgroundImage, 0, 0);
    //TODO: make this look fancier
    canvas.text("Score: " + score, 500, 500);
    canvas.text("Name: " + textInputted, 600, 600);
  }

  void keyPressed() {
    if (textInputting) {
      //based on https://forum.processing.org/one/topic/how-to-input-text-and-process-it.html
      if (key == BACKSPACE) {
        if (textInputted.length() > 0) {
          textInputted = textInputted.substring(0, textInputted.length() - 1);
        }
      } else if (key == RETURN || key == ENTER && key != ',') {
        println ("ENTER");
        textInputting = false;

        TableRow newRow = highscores.addRow();
        newRow.setString("name", textInputted);
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        newRow.setString("time", strDate);
        newRow.setInt("score", score);

        highscores.trim();
        highscores.sortReverse("score");
        saveTable(highscores, "data/highscores.csv");
      } else if (key != CODED) {
        textInputted += key;
      }
      println (textInputted);
    }
  }
}
