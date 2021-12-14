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
traceFunctionTime("MainMenu.draw()" );
   background(lerpColor(#78C8A1, #F69E86, (((millis()/5000)%2==0)?millis()%5000:5000-millis()%5000)/5000.0));

    for (int i = 0; i < perPattern; i++)
    {
     image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, 0);
     image(pattern, (i * pattern.width + millis() / 10.0f)% (gwidth + 3.455 * pattern.width) -  pattern.width, pattern.height);
    }

    if (highscoreScreen) {
     image(backgroundImage, 0, 0);
      float w = 475;
     pushStyle();
     fill(255, 100);
     stroke(#7f5b84);
     strokeWeight(6);
     pushMatrix();
     translate(gwidth/2-w/2, 300);
     rect(0, 0, w, 525, 32);

     fill(0);
      for (int i = 0; i < (highscores.getRowCount() < 10 ? highscores.getRowCount() : 10); i++) {
        float y = i * 50 + 10;
        TableRow tr = highscores.getRow(i);
       textAlign(LEFT, TOP);
       text(tr.getString("name"), 32, y);
       textAlign(RIGHT, TOP);
       text(nfc(tr.getInt("score")), w-32, y);
      }

     popStyle();
     popMatrix();

      backbutton.draw();

     pushStyle();
     imageMode(CENTER);
     image(highscoreImage, gwidth/2, 220);
     popStyle();
    } else {
      super.draw(); //draws backgroundImage and all objects (the buttons)
    }

    if (!mediaLoaded)
     text("Loading game media assets...", 50, 50);

    millisAtGameStart = millis();
traceFunctionTime("MainMenu.draw()" );
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

   image(introVideo, 0, 0);

    if (introVideo.time() < 2)
     text("Press space to skip", 50, 50);

    if (introVideo.duration() - introVideo.time() < 0.2) {
      String s = "Objective: Clean up the house before your parents get home!\n\nPress space to start the game!";
     fill(0);
     text(s, 52, 53);
     fill(255);
     text(s, 50, 50);
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
      introVideo.stop();
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

  PImage scoreBubble;

  boolean textInputting = false;
  String textInputted = "";

  EndScreen(String sceneName) {
    super(sceneName, "menus/end/parentsAngry.png", null);
    parentsHappy = loadImage("menus/end/parentsHappy.png");
    parentsNeutral = loadImage("menus/end/parentsNeutral.png");
    parentsAngry = loadImage("menus/end/parentsAngry.png");

    scoreBubble = loadImage("menus/end/score.png");
  }

  void calculateScore() {
    if (score == scoreMax) backgroundImage = parentsHappy;
    else if (score >= scoreMax*2.0/3.0) backgroundImage = parentsNeutral;
    else backgroundImage = parentsAngry;

    debugMode = false;
    textInputted = "";
    textInputting = true;
  }

  void draw() {
   image(backgroundImage, 0, 0);


   pushStyle();
   pushMatrix();
   translate(gwidth/2, gheight/2);
   imageMode(CENTER);
   image(scoreBubble, 0, 0);
   fill(0);
    changeFontSize(128);
   textAlign(CENTER, CENTER);
   text(nfc(score), 0, -20);
    changeFontSize(120);
   textAlign(CENTER, CENTER);
   text("Name:", 0, 300);
   text(textInputted, 0, 400);
    if (textInputting) {
      if (millis() % 2000 < 1000) {
        float x =textWidth(textInputted)/2;
       stroke(0);
       strokeWeight(2);
       line(x, 389, x, 461);
      }
      changeFontSize(48);
     textAlign(CENTER, CENTER);
     text("Press enter to save your highscore!", 0, 498);
    } else {
      changeFontSize(48);
     textAlign(CENTER, CENTER);
     text("Press ESC to close the game", 0, 498);
    }
   popStyle();
   popMatrix();
  }

  void keyPressed() {
    if (textInputting) {
      //based on https://forum.processing.org/one/topic/how-to-input-text-and-process-it.html
      if (key == BACKSPACE) {
        if (textInputted.length() > 0) {
          textInputted = textInputted.substring(0, textInputted.length() - 1);
        }
      } else if (key == RETURN || key == ENTER && key != ',') {
        if (debugMode) println ("ENTER");
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
        loadGame();
      } else if (key != CODED) {
        textInputted += key;
        if (textWidth(textInputted) > 250) {
          textInputted = textInputted.substring(0, textInputted.length() - 1);
        }
      }
      if (debugMode) println (textInputted);
    }
  }
}
