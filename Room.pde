class Room {
  private String roomName;
  public ArrayList<Scene> scenes;
  public ArrayList<GameObject> trash;
  
  public Room()
  {
    scenes = new ArrayList<Scene>();
    trash = new ArrayList<GameObject>();
  }


  public void update() //renders the scenes
  {
    for (int i = 0; i < scenes.size(); i++)
      scenes.get(i).draw(wwidth, wheight);
  }

  public String getRoomName()
  {
    return roomName;
  }
}
