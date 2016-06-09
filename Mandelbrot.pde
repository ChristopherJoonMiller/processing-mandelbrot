/**
 * The Mandelbrot Set
 * by Christopher Joon Miller  
 */

void setup() {
  size(640, 360);
}

boolean isDirty = true;
void draw() {
  loadPixels();
  if( isDirty )
  {
    isDirty = false;
    // It all starts with the width, try higher or lower values
    double w = 5; // width is 5 units on the complex plane (real axis)
    double h = (w * height) / width; // height is derived based on screen size and how much of the real is shown
    
    ComplexNumber center = new ComplexNumber(0,0);
    double dx = w / width;
    double dy = h / height;
    
    double min_x = center.real - w / 2;
    double min_y = center.imaginary - h / 2;
    
    int max_iterations = 100;
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
          if(z.value() >= 4.0)
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
  }
  updatePixels();
}