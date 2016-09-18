/**
 * The Mandelbrot Set
 * by Christopher Joon Miller
 */

import java.lang.*;
import processing.core.*;
import java.util.ArrayList;

// Create a renderer
Renderer r;

void setup()
{
  size(640, 360);
  r = new Renderer(this);

  // complete all setup
  initColoringStrategies(r);

  // tell renderer to initialize the gui
  r.initGui();
}

void keyPressed()
{
  if(keyPressed)
  {
    if(key == '\t')
    {
      r.toggleGui();
    }
    else if(key == 'i')
    {
      // increase iterations
      r.updateMaxIterations(2.0);
    }
    else if(key == 'I')
    {
      // decrease iterations
      r.updateMaxIterations(0.5);
    }
  }
}

void mouseClicked()
{
  r.zoom();
}

void draw()
{
  r.update();
}