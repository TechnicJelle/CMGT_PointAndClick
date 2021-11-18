class TaskDish extends Task{
  
    TaskDish(String sceneName, String backgroundImageFile) {
    super(sceneName, backgroundImageFile);
  }
  
PImage sponge;
PImage dishes;
//PImage backgroundImage;

boolean hasADishToClean = false;
boolean isMouseOver = false;
boolean isMouseOver2 = false;
boolean isPlateClean = true;

int cleanPlates = 0;


PVector[] dirt  = new PVector[3];
boolean[] hasBeenCleaned = new boolean[3];




void setup()
{
  //fullScreen();

  sponge = loadImage("rooms/livingRoom/Sponge.png");
  dishes = loadImage("dish.png");
  //backgroundImage = loadImage("tasks/dishes/bg.png");
  
  for (int i = 0; i < 3; i++)
  {
    dirt[i] = new PVector(0,0);
   
    hasBeenCleaned[i] = false;
  }


  
}

void draw()
{
  if(cleanPlates == 3)
  {
    
  }
  canvas.image(backgroundImage, 0, 0);
  
  canvas.pushMatrix();
  canvas.image(dishes, 1300, 700);
  canvas.image(dishes, 400, 700);
  canvas.popMatrix();

  


  if (hasADishToClean)
  {
    canvas.fill(255);
    canvas.circle(1920/2, 1080/2, 600);
    canvas.circle(1920/2, 1080/2, 500);

    if (!isPlateClean)
      for (int i = 0; i < 3; i++)
      {
        canvas.fill(0);
        if (!hasBeenCleaned[i])
          canvas.circle(dirt[i].x, dirt[i].y, 50);
      }
      
  }
  image(sponge, mouse.x - sponge.width/2, mouse.y - sponge.height/2);
  
  //println(isMouseOver);
}

void mouseMoved()
{
  if (mouse.x > 1300 && mouse.x < 1300 + dishes.width && mouse.y > 700 && mouse.y < 700 + dishes.height)
  {
    isMouseOver = true;
  }
  else
  {
    isMouseOver = false;
  }
  
  if (mouse.x > 400 && mouse.x < 400 + dishes.width && mouse.y > 700 && mouse.y < 700 + dishes.height)
  {
    isMouseOver2 = true;
  }
  else
  {
    isMouseOver2 = false;
  }

  if (hasADishToClean)
    for (int i = 0; i < 3; i++)
    {
      if (mouse.x > dirt[i].x - 25 && mouse.x < dirt[i].x + 25 && mouse.y > dirt[i].y - 25 && mouse.y < dirt[i].y + 25)
        hasBeenCleaned[i] = true;
        if(checkPlate())
        {
          isPlateClean = true;
          cleanPlates++;
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

      hasBeenCleaned[i] = false;
    }
    hasADishToClean = true;
    isPlateClean = false;
  }
  
  if(isMouseOver2 && isPlateClean)
  hasADishToClean = false;
  
}

boolean checkPlate()
{
  for(int i = 0; i < 3; i++)
  {
    if(!hasBeenCleaned[i])
    return false;
  }
  return true;
}
}
