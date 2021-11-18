class TaskDish extends Task {

  TaskDish(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter) {
    super(sceneName, backgroundImageFile, sceneStarter);
  }



  PImage sponge;
  PImage dishes;

  PImage[] dryingRag;
  PImage plate;

  PImage[] stains;


  PVector[] dirt  = new PVector[3];
  boolean[] hasBeenCleaned = new boolean[3];

  boolean hasADishToClean = false;
  boolean isMouseOver = false;
  boolean isMouseOver2 = false;
  boolean isPlateClean = true;

  int cleanPlates = 0;



  int[] randomStains;


  void setup()
  {
    //fullScreen();


    sponge = loadImage("rooms/livingRoom/Sponge" + ".png");
    dishes = loadImage("tasks/dishes/DirtyDishes.png");
    dryingRag = new PImage[] {loadImage("tasks/dishes/DryingRagBase.png"), loadImage("tasks/dishes/DryingRag1.png"), loadImage("tasks/dishes/DryingRag2.png"), 
      loadImage("tasks/dishes/DryingRag3.png"), loadImage("tasks/dishes/DryingRag4.png"), loadImage("tasks/dishes/DryingRag5.png")};
    plate = loadImage("tasks/dishes/PlateBase.png");
    stains = new PImage[] {loadImage("tasks/dishes/Stain1.png"), loadImage("tasks/dishes/Stain2.png"), loadImage("tasks/dishes/Stain3.png"), 
      loadImage("tasks/dishes/Stain4.png"), loadImage("tasks/dishes/Stain5.png")};

    randomStains = new int[] {(int)random(1, 5), (int)random(1, 5), (int)random(1, 5)};


    for (int i = 0; i < 3; i++)
    {
      dirt[i] = new PVector(0, 0);

      hasBeenCleaned[i] = false;
    }
  }

  void draw()
  {

    if (cleanPlates == 5)
    {
      sceneManager.goToPreviousScene();
      sceneManager.getCurrentScene().removeGameObject(sceneStarter);
    }

    canvas.image(sponge, mouse.x - sponge.width/2, mouse.y - sponge.height/2);


    canvas.image(backgroundImage, 0, 0);

    canvas.pushMatrix();
    canvas.image(dishes, 1570, 573);
    canvas.image(dryingRag[cleanPlates], 266, 543);
    canvas.popMatrix();

    if (hasADishToClean)
    {

      canvas.image(plate, 667, 288);



      if (!isPlateClean)
        for (int i = 0; i < 3; i++)
        {
          canvas.fill(0);
          if (!hasBeenCleaned[i])
            canvas.image(stains[randomStains[i]], dirt[i].x, dirt[i].y);
        }
    }
    canvas.image(sponge, mouse.x - sponge.width/2, mouse.y - sponge.height/2);
  }

  void mouseMoved()
  {
    if (mouse.x > 1570 && mouse.x < 1570 + dishes.width && mouse.y > 573 && mouse.y < 573 + dishes.height)

    {
      isMouseOver = true;
    } else
    {
      isMouseOver = false;
    }
    if (mouse.x > 266 && mouse.x < 266 + dryingRag[cleanPlates].width && mouse.y > 543 && mouse.y < 543 + dryingRag[cleanPlates].height)
    {
      isMouseOver2 = true;
    } else
    {

      isMouseOver2 = false;
    }

    if (hasADishToClean)
      for (int i = 0; i < 3; i++)
      {
        if (mouse.x > dirt[i].x  && mouse.x < dirt[i].x + stains[randomStains[i]].width && mouse.y > dirt[i].y && mouse.y < dirt[i].y + stains[randomStains[i]].height)

          hasBeenCleaned[i] = true;
        if (checkPlate())
        {
          isPlateClean = true;
        }
      }
  }

  void mouseClicked()
  {
    if (isMouseOver && isPlateClean)
    {
      for (int i = 0; i < 3; i++)
      {
        dirt[i].x = random(1920/2 - 250, 1920/2 + 250);
        dirt[i].y = random(1080/2 - 200, 1080/2 + 200);

        randomStains[i] = (int)random(1, 5);


        hasBeenCleaned[i] = false;
      }
      hasADishToClean = true;
      isPlateClean = false;
    }

    if (isMouseOver2 && isPlateClean)
    {
      hasADishToClean = false;
      cleanPlates++;
    }
  }

  boolean checkPlate()
  {
    int a = 1;
    for (int i = 0; i < 3; i++)
    {
      if (!hasBeenCleaned[i])
        a = 0;
    }

    if (a == 1)
      return true;
    else return false;
  }
}
