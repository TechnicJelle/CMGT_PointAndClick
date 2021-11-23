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
  }
}
