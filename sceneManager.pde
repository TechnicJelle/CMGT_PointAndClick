import java.util.Stack;
import java.util.HashMap;

class SceneManager {
  private HashMap<String, Scene> scenes;
  private Stack<Scene> scenesStack;
  
  public SceneManager() {
    scenes = new HashMap<String, Scene>();
    scenesStack = new Stack<Scene>();
  }
  
  public void addScene(Scene scene) {
    scenes.put(scene.getSceneName(), scene);
    if(scenesStack.size() == 0)
    {
      scenesStack.push(scene);
    }
  }
  
  public void goToScene(String sceneName) throws Exception {
    if(scenes.containsKey(sceneName)) {
      scenesStack.push(scenes.get(sceneName));
    }
    else {
      throw new Exception("Scene not found with name: "+ sceneName + "." + 
                           "Make sure it was added to the sceneManager.");
    }
  }
  
  public void goToPreviousScene() {
    scenesStack.pop();
  }
  
  public Scene getCurrentScene() {
    return scenesStack.peek();
  }
}
