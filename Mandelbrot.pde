/**
 * The Mandelbrot Set
 * by Christopher Joon Miller
 */

import java.lang.*;

// GLOBALS
boolean isDirty = false;
double bailout = 4.0;
int max_iterations = 100;
 //<>//
double w, h, dx, dy, width_offset, height_offset, min_x, min_y, scale;
ComplexNumber center;

void setup() {
  size(640, 360);
  background(255,255,0);
  setScale(1.0);
  setCenter(0, 0);

  // init buffer
  loadPixels();
}

// https://processing.org/reference/mouseClicked_.html

void mouseClicked() {
  // compare mouseX and mouseY to width and height
  // determine the localized position to zoome in
  double screen_x = mouseX / float(width);
  double screen_y = mouseY / float(height);
  double real_x = min_x + screen_x * w;
  double imaginary_y = min_y + screen_y * h; //<>//

  // zoom in or out?
  if (keyPressed && keyCode == CONTROL)
  {
    setScale(scale * 2);
  }
  else
  {
    setScale(scale * 0.5);
  }
  setCenter(real_x, imaginary_y);
}

void setScale(double s)
{
  scale = s;
  w = 5 * scale; // width is 5 units on the complex plane (real axis)
  h = (w * height) / width; // height is derived based on screen size and how much of the real is shown

  dx = w / width;
  dy = h / height;

  // store the translation from screen coords to cartesian coords
  width_offset = w / 2;
  height_offset = h / 2;
}

void setCenter(double real, double imaginary) {
  center = new ComplexNumber(real, imaginary);
  min_x = center.real - width_offset;
  min_y = center.imaginary - height_offset;
  isDirty = true;
}

void draw() {
  if( isDirty )
  {
    redraw();
  }
}

void redraw()
{
  isDirty = false;
  for( int y = 0; y < height; y++)
  {
    double imaginary = min_y + y * dy;
    for(int x = 0; x < width; x++)
    {
      double real = min_x + x * dx;
      ComplexNumber z = new ComplexNumber(0,0);
      ComplexNumber c = new ComplexNumber(real,imaginary);

      // calculate whether we're tending towards infinity
      int n = 0;
      while( n < max_iterations )
      {
        // z = z^2 + c
        z = z.multiply(z).add(c);

        // can't actually detect infinity, bailout if we're certain enough
        if(z.magnitude() >= bailout)
        {
          break;
        }
        n++;
      }
      //double nsmooth = (n - Math.log(Math.log(z.magnitude()))/Math.log(2));
      double quotient = Math.max(0, Math.min(1, n / (float)max_iterations)); // between 0 and 1
      int val = Math.round(((float)quotient * 255.0));
      color col;
      if( quotient > 0.5 ) // close
      {
        col = color( val, 255, val);
      }
      else // far
      {
        col = color( 0, val, 0);
      }

      if(n == max_iterations) // in set
      {
        pixels[x+y*width] = color(40);
      }
      else
      {
        pixels[x+y*width] = col;
      }
    }
  }
  updatePixels();
}