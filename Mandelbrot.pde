/**
 * The Mandelbrot Set
 * by Christopher Joon Miller
 */

import java.lang.*;

// Create a renderer
Renderer r;

void setup() {
  size(640, 360);
  r = new Renderer();
}

void keyPressed()
{
  if(keyPressed)
  {
    if(key == 'i')
    {
      // increase iterations
      r.updateMaxIterations(5);
    }
    if(key == 'I')
    {
      // decrease iterations
      r.updateMaxIterations(.2);
    }
  }
}

// https://processing.org/reference/mouseClicked_.html
void mouseClicked() {
  r.zoom();
}

void draw() {
  r.update();
}
