/**
 * GUI Class
 * by Christopher Joon Miller
 */

import g4p_controls.*;
import processing.core.PApplet;

// need to make all GUI elements as globals
// so that we can test against them in handleEvents
GDropList ColoringStrategySelector;

public void handleButtonEvents(GButton button, GEvent event) {
  println(button);
  println(event);
}

void handleDropListEvents(GDropList list, GEvent event)
{ 
  if (list == ColoringStrategySelector)
  {
    int colorizer_selected = ColoringStrategySelector.getSelectedIndex();
    print("Selected coloring strategy: ", colorizer_selected, ColoringStrategySelector.getSelectedText());
    r.setSelectedColoringStrategy(colorizer_selected);
  }
}

public class GUI
{
  PApplet parent;
  Renderer r;
  public
  ArrayList<GAbstractControl> guiItems;
  boolean isVisible = true;

  GUI(Renderer r)
  {
    G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
    G4P.setCursor(ARROW);
    this.r = r;
    parent = r.getParentApp();
    
    guiItems = new ArrayList<GAbstractControl>();
  } //<>//
  
  void setVisible(boolean isVisible)
  {
    if(this.isVisible != isVisible)
    {
      for (GAbstractControl element : guiItems)
      {
        element.setVisible(isVisible);
      }
      this.isVisible = isVisible;
    }
  }

  void initColoringStrategySelector()
  {
    // ask renderer for its coloring strategies //<>//
    ArrayList<ColoringStrategy> colorizers = r.getColoringStrategies();
    int size = colorizers.size();
  
    String[] items = new String[size];
    for (int i = 0; i < size; i++) {
      items[i] = colorizers.get(i).getName(); 
    }
  
    ColoringStrategySelector = new GDropList(parent, 10, 10, 120, 100, size);
    ColoringStrategySelector.setItems(items, 0);
    
    guiItems.add(ColoringStrategySelector);
  }
}