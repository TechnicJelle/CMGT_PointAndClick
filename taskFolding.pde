class TaskFolding extends Task {

  TaskFolding(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc, PVector minimapLocation, PImage minimapIcon, int sa) {
    super(sceneName, backgroundImageFile, sceneStarter, replaceWith, desc, minimapLocation, minimapIcon, sa);
  }

  PImage[] pileOfClothes;
  PImage noClothesOnPile;
  PImage[] foldedClothes;
  PImage[] cloths;
  Quad[] parts;


  boolean[] lock = new boolean[] {false, false, false};
  boolean[] pointInQuad = new boolean[] {false, false, false};
  boolean[] released = new boolean[] {true, true, true};
  boolean[] isMouseOverPile = new boolean[] {false, false}; // 0 is to finish the cloth, 1 is to get a cloth
  boolean hasSomethingInHand = false;
  boolean hasClothToFold = false;
  boolean addedACloth = true;

  int folded = -1;

  int clothesLeft = 0;

  //int tshirt = 0;


  void setup()
  {
    setCursor(ARROW);
    pileOfClothes = new PImage[] { loadImage("tasks/folding/unfoldedClothes1.png"), loadImage("tasks/folding/unfoldedClothes2.png"), loadImage("tasks/folding/unfoldedClothes3.png"), loadImage("tasks/folding/unfoldedClothes4.png")};
    noClothesOnPile = loadImage("tasks/folding/foldedClothes0.png");
    foldedClothes = new PImage[] {loadImage("tasks/folding/foldedClothes1.png"), loadImage("tasks/folding/foldedClothes2.png"), loadImage("tasks/folding/foldedClothes3.png"), loadImage("tasks/folding/foldedClothes4.png")};
    cloths = new PImage[] {loadImage("tasks/folding/tshirt1.png"), loadImage("tasks/folding/tshirt2.png"), loadImage("tasks/folding/tshirt3.png"), loadImage("tasks/folding/tshirt4.png")};
    parts = new Quad[3];
    parts[0] = new Quad(new PVector(825.6, 449.4), new PVector(825.6, 499.4), new PVector(750.6, 529.4), new PVector(750.6, 479.4));
    parts[1] = new Quad(new PVector(754 + cloths[folded + 1].width, 300), new PVector(754 + cloths[folded + 1].width, 350), new PVector(800 + cloths[folded + 1].width, 370), new PVector(800 + cloths[folded + 1].width, 320));
    parts[2] = new Quad(new PVector(754, 300 + cloths[folded + 1].height), new PVector(754 + cloths[folded + 1].width, 300 + cloths[folded + 1].height), new PVector(754 + cloths[folded + 1].width, 650), new PVector(754, 650));
    mouse = new PVector(0, 0);
  }

  void draw()
  {
    if (folded == 3)
    {
      done();
    }
   image(backgroundImage, 0, 0);
    if (clothesLeft < 4)
     image(pileOfClothes[clothesLeft], 1297, 488);
    if (folded >= 0)
     image(foldedClothes[folded], 250, 455);
    if (folded < 0)
     image(noClothesOnPile, 250, 455);

    if (hasClothToFold)
    {
     image(cloths[folded + 1], 825.6, 446.4);
      if (folded + 1 == 0)
      {
       strokeWeight(3);
       stroke(#76001d);
       fill(#b9153e);
      } else if (folded + 1 == 1)
      {
       strokeWeight(3);
       stroke(#417da9);
       fill(#82b7dd);
      } else if (folded + 1 == 2)
      {
       strokeWeight(3);
       stroke(#7ed7a6);
       fill(#beffdb);
      } else {
       strokeWeight(3);
       stroke(#9c5d00);
       fill(#ff9800);
      }


      for (int i = 0; i < 3; i++)
      {
       quad(parts[i].a.x, parts[i].a.y, parts[i].b.x, parts[i].b.y, parts[i].c.x, parts[i].c.y, parts[i].d.x, parts[i].d.y);
      }
    }
    /*
  stroke(1);
     noFill();
     circle((parts[0].c.x + parts[0].d.x)/2, (parts[0].c.y + parts[0].d.y)/2, (parts[0].c.y - parts[0].d.y));
     */
  }

  void mouseClicked()
  {
    if (debugMode) println(isMouseOverPile[1]);

    if (random(1.0) < 0.5)
      sfxFolding1.play();
    else
      sfxFolding2.play();

    for (int i = 0; i < 3; i++)
    {
      if (!lock[i])
      {
        if (pointInQuad[i] && !hasSomethingInHand)
        {
          hasSomethingInHand = true;
          released[i] = false;
        }


        if ((parts[i].c.x > 825.6 && parts[i].c.x < 825.6 + cloths[folded + 1].width && parts[i].c.y > 446.4 && parts[i].c.y < 446.4 + cloths[folded + 1].height) 
          && (parts[i].d.x > 825.6 && parts[i].d.x < 825.6 + cloths[folded + 1].width && parts[i].d.y > 446.4 && parts[i].d.y < 446.4 + cloths[folded + 1].height))
        {
          lock[i] = true;
          released[i] = true;
          hasSomethingInHand = false;
        }
      }
    }

    if (isMouseOverPile[1] && !hasClothToFold)
    {
      hasClothToFold = true;
      addedACloth = false;
      parts[0] = new Quad(new PVector(825.6, 449.4), new PVector(825.6, 499.4), new PVector(750.6, 526.4), new PVector(750.6, 479.4));
      parts[1] = new Quad(new PVector(825.6 + cloths[folded + 1].width, 449.4), new PVector(825.6 + cloths[folded + 1].width, 499.4), new PVector(900.6 + cloths[folded + 1].width, 529.4), new PVector(900.6 + cloths[folded + 1].width, 479.4));
      parts[2] = new Quad(new PVector(828.6, 446.4 + cloths[folded + 1].height), new PVector(823.6 + cloths[folded + 1].width, 446.4 + cloths[folded + 1].height), 
        new PVector(823.6 + cloths[folded + 1].width, 750), new PVector(828.6, 750));
      hasSomethingInHand = false;
      for (int i = 0; i < 3; i++)
      {
        lock[i] = false;
        released[i] = true;
      }
      clothesLeft++;
    }

    if (isMouseOverPile[0] && !addedACloth && theClothIsFolded())
    {
      hasClothToFold = false;
      addedACloth = true;
      folded ++;
    }
  }

  void mouseMoved()
  {
    if (clothesLeft < 4)
      if (mouse.x > 1297 && mouse.x < 1297 + pileOfClothes[clothesLeft].width && mouse.y > 488 && mouse.y < 488 + pileOfClothes[clothesLeft].height)
      {
        isMouseOverPile[1] = true;
      } else
      {
        isMouseOverPile[1] = false;
      }

    if (mouse.x > 0 && mouse.x < 550)
    {
      isMouseOverPile[0] = true;
    } else
    {
      isMouseOverPile[0] = false;
    }

    for (int i = 0; i < 3; i++)
    {
      if (parts[i].pointCheck(mouse))
      {
        pointInQuad[i] = true;
      } else
      {
        pointInQuad[i] = false;
      }

      if (!released[i])
      {
        if (i!=2)
        {
          parts[i].c.x = mouse.x;
          parts[i].d.x = mouse.x;
          parts[i].c.y = mouse.y + 25;
          parts[i].d.y = mouse.y - 25;
        } else {
          parts[i].c.y = mouse.y;
          parts[i].d.y = mouse.y;
          parts[i].c.x = mouse.x + 83;
          parts[i].d.x = mouse.x - 83;
        }
      }
    }
  }

  boolean theClothIsFolded()
  {
    int a = 1;
    for (int i = 0; i < 3; i++)
    {
      if (!lock[i])
        a = 0;
    }

    if (a == 1)
      return true;
    else return false;
  }
}
