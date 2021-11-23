class TaskCloths extends Task {

  TaskCloths(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc) {
    super(sceneName, backgroundImageFile, sceneStarter, replaceWith, desc);
  }
  PImage pileOfChlotes;
  PImage foldedChlotes;
  PImage cloth;
  Quad[] parts;
  

  boolean[] lock = new boolean[] {false, false, false};
  boolean[] pointInQuad = new boolean[] {false, false, false};
  boolean[] released = new boolean[] {true, true, true};
  boolean[] isMouseOverPile = new boolean[] {false, false}; // 0 is to finish the cloth, 1 is to get a cloth
  boolean hasSomethingInHand = false;
  boolean hasClothToFold = false;
  boolean addedACloth = true;
  
  int folded = 0;




  void setup()
  {

    pileOfChlotes = loadImage("pileOfChlotes.png");
    foldedChlotes = loadImage("foldedChlotes.png");
    cloth = loadImage("tshirt.png");
    parts = new Quad[3];
    parts[0] = new Quad(new PVector(754, 300), new PVector(754, 350), new PVector(700, 370), new PVector(700, 320));
    parts[1] = new Quad(new PVector(754 + cloth.width, 300), new PVector(754 + cloth.width, 350), new PVector(800 + cloth.width, 370), new PVector(800 + cloth.width, 320));
    parts[2] = new Quad(new PVector(754, 300 + cloth.height), new PVector(754 + cloth.width, 300 + cloth.height), new PVector(754 + cloth.width, 650), new PVector(754, 650));
    mouse = new PVector(0, 0);
  }

  void draw()
  {
    if(folded == 5)
    {
      done();
    }
    canvas.image(backgroundImage, 0, 0);

    canvas.image(pileOfChlotes, 1297, 488);
    canvas.image(foldedChlotes, 250, 455);

    if (hasClothToFold)
    {
      canvas.image(cloth, 754, 300);
      canvas.noStroke();
      canvas.fill(0, 0, 255);
      for (int i = 0; i < 3; i++)
      {
        canvas.quad(parts[i].a.x, parts[i].a.y, parts[i].b.x, parts[i].b.y, parts[i].c.x, parts[i].c.y, parts[i].d.x, parts[i].d.y);
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
    println(mouseX, mouseY, pointInQuad[0], pointInQuad[1], pointInQuad[2]);

    for (int i = 0; i < 3; i++)
    {
      if (!lock[i])
      {
        if (pointInQuad[i] && !hasSomethingInHand)
        {
          hasSomethingInHand = true;
          released[i] = false;
        }


        if (parts[i].c.x > 754 && parts[i].c.x < 754 + cloth.width && parts[i].c.y > 300 && parts[i].c.y < 300 + cloth.height)
        {
          lock[i] = true;
          released[i] = true;
          hasSomethingInHand = false;
        }
      }
    }

    if (isMouseOverPile[1])
    {
      hasClothToFold = true;
      addedACloth = false;
      parts[0] = new Quad(new PVector(754, 300), new PVector(754, 350), new PVector(700, 370), new PVector(700, 320));
      parts[1] = new Quad(new PVector(754 + cloth.width, 300), new PVector(754 + cloth.width, 350), new PVector(800 + cloth.width, 370), new PVector(800 + cloth.width, 320));
      parts[2] = new Quad(new PVector(754, 300 + cloth.height), new PVector(754 + cloth.width, 300 + cloth.height), new PVector(754 + cloth.width, 650), new PVector(754, 650));
      hasSomethingInHand = false;
      for (int i = 0; i < 3; i++)
      {
        lock[i] = false;
        released[i] = true;
      }
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
    if (mouseX > 1297 && mouseX < 1297 + pileOfChlotes.width && mouseY > 488 && mouseY < 488 + pileOfChlotes.height)
    {
      isMouseOverPile[1] = true;
    } else
    {
      isMouseOverPile[1] = false;
    }

    if (mouseX > 250 && mouseX < 250 + foldedChlotes.width && mouseY > 455 && mouseY < 455 + foldedChlotes.height)
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
          parts[i].c.x = mouseX;
          parts[i].d.x = mouseX;
          parts[i].c.y = mouseY + 25;
          parts[i].d.y = mouseY - 25;
        } else {
          parts[i].c.y = mouseY;
          parts[i].d.y = mouseY;
          parts[i].c.x = mouseX + 83;
          parts[i].d.x = mouseX - 83;
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
