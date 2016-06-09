/**
 * The Mandelbrot Set
 * by Christopher Joon Miller  
 */

// GLOBALS
boolean isDirty = false;
double bailout = 4.0;
int max_iterations = 100;

double w, h, dx, dy, width_offset, height_offset, min_x, min_y;
ComplexNumber center; //<>//

void setup() {
  size(640, 360);
  w = 5; // width is 5 units on the complex plane (real axis)
  h = (w * height) / width; // height is derived based on screen size and how much of the real is shown

  dx = w / width;
  dy = h / height;

  // store the translation from screen coords to cartesian coords
  width_offset = w / 2;
  height_offset = h / 2;

  setCenter(0, 0);

  // init buffer
  loadPixels();
}

// https://processing.org/reference/mouseClicked_.html

void mouseClicked() { //<>//
  // compare mouseX and mouseY to width and height
  // determine the localized position to zoome in
  double screen_x = mouseX / float(width);
  double screen_y = mouseY / float(height);
  double real_x = min_x + screen_x * w;
  double imaginary_y = min_y + screen_y * h;

  setCenter(real_x, imaginary_y);
}

void setCenter(double real, double imaginary) {
  center = new ComplexNumber(real, imaginary);
  min_x = center.real - width_offset;
  min_y = center.imaginary - height_offset;
  println("Complex Window");
  println(min_x, min_y);
  println(min_x + w, min_y + h);
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
        z = z.multiply(z).add(c);
        if(z.magnitude() >= bailout)
        {
          break;
        }
        n++;
      }
      if(n == max_iterations) // in set
      {
        pixels[x+y*width] = color(40);
      }
      else
      {
        pixels[x+y*width] = color(200);
      }
    }
  }
  updatePixels();
}