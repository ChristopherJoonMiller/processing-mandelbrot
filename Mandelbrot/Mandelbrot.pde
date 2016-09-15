/**
 * The Mandelbrot Set
 * by Christopher Joon Miller
 */

import java.lang.*;
import processing.core.*;
import java.util.ArrayList;

// Create an Applet reference
processing.core.PApplet thisApplet;

// Create a renderer
Renderer r;

void setup()
{
  thisApplet = this;
  size(640, 360);
  r = new Renderer(thisApplet);
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

//void mouseClicked()
//{
//  r.zoom();
//}

void draw()
{
  r.update();
}