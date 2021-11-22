class TaskDish extends Task {

  TaskDish(String sceneName, String backgroundImageFile, MoveToSceneObject sceneStarter, GameObject replaceWith, String desc) {
    super(sceneName, backgroundImageFile, sceneStarter, replaceWith, desc);
  }

  PImage spongeCursor;
  PImage spongeClick;
  PImage dishes;

  PImage[] dryingRack;
  PImage plate;

  PImage[] stains;


  PVector[] dirt  = new PVector[3];
  boolean[] hasBeenCleaned = new boolean[3];

  boolean hasADishToClean = false;
  boolean isMouseOver = false;
  boolean isMouseOver2 = false;
  boolean isPlateClean = true;
  boolean addedAPlate = true;

  int cleanPlates = 0;



  int[] randomStains;


  void setup() {
    //PImage img = createImage(1, 1, ARGB);
    //img.loadPixels();
    //for (int i = 0; i < img.pixels.length; i++) {
    //  img.pixels[i] = color(255, 1);
    //}
    //img.updatePixels();
    //cursor(img);
    spongeCursor = loadImage("tasks/dishes/SpongeCursor.png");
    spongeClick = loadImage("tasks/dishes/SpongeClick.png");

    dishes = loadImage("tasks/dishes/DirtyDishes.png");
    dryingRack = new PImage[] {loadImage("tasks/dishes/DryingRackBase.png"), loadImage("tasks/dishes/DryingRack1.png"), loadImage("tasks/dishes/DryingRack2.png"), 
      loadImage("tasks/dishes/DryingRack3.png"), loadImage("tasks/dishes/DryingRack4.png"), loadImage("tasks/dishes/DryingRack5.png")};
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
      done();
    }


    canvas.image(backgroundImage, 0, 0);

    canvas.pushMatrix();
    canvas.image(dishes, 1570, 573);
    canvas.image(dryingRack[cleanPlates], 266, 543);
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

    cursor(dist(mouse.x, mouse.y, 1001, 621) < 280 && hasADishToClean ? spongeClick : spongeCursor);
    //canvas.image(dist(mouse.x, mouse.y, 1001, 621) < 280 && hasADishToClean ? spongeClick : spongeCursor, mouse.x - spongeCursor.width/2, mouse.y - spongeCursor.height/2);
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
    if (mouse.x > 266 && mouse.x < 266 + dryingRack[cleanPlates].width && mouse.y > 543 && mouse.y < 543 + dryingRack[cleanPlates].height)
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
      addedAPlate = false;
    }

    if (isMouseOver2 && isPlateClean && !addedAPlate)
    {
      addedAPlate = true;
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
