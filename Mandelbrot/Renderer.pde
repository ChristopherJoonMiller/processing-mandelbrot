/**
 * Pixel Renderer Class
 * by Christopher Joon Miller
 */

class Renderer
{
  boolean isDirty = false;
  double bailout = 4.0;
  int max_iterations = 1000;
  int[] iteration_counts;
  int most_iterations = 0; // store the max in the scene
  double w, h, dx, dy, width_offset, height_offset, min_x, min_y, scale;
  ComplexNumber center;
  ColoringStrategy colorizer;

  Renderer()
  {
    iteration_counts = new int[width * height];
    background(255,255,0);
    // init buffer
    loadPixels();
    updateScene(1.0, 0, 0);
    //color[] whites_and_blacks = {color(255,255,255), color(0,0,0), color(255,255,255)};
    //Palette p = new Palette("b/w", whites_and_blacks);
    //color[] rgb = {color(255,0,0), color(0,255,0), color(0,0,255)};
    //Palette p = new Palette("rgb", rgb);
    color[] orange_floats = {color(252,148,88), color(252,198,158), color(252,248,248), color(152,238,252), color(52,228,252)};
    Palette of = new Palette("Orange Floats", orange_floats);
    colorizer = new PalettizedColoringStrategy(of);
  }

  void updateMaxIterations(double scaler)
  {
    if( scaler != 0.0 )
    {
      max_iterations *= scaler;
      println("updated max_iterations", max_iterations);
      isDirty = true;
    }
  }

  void zoom()
  {
    // compare mouseX and mouseY to width and height
    // determine the localized position to zoome in
    double screen_x = mouseX / float(width);
    double screen_y = mouseY / float(height);
    double real_x = min_x + screen_x * w;
    double imaginary_y = min_y + screen_y * h;

    updateScene(
      (keyPressed && keyCode == CONTROL) ? scale * 4.0 : scale * 0.25,
      real_x, imaginary_y);
  }

  void setScale(double s)
  {
    scale = s;
    w = 5 * scale; // width is 5 units on the complex plane (real axis)
    h = (w * height) / width; // height is derived based on screen size and how much of the real is shown

    println("rendering a complex plane:", w, h);

    dx = w / (double)width;
    dy = h / (double)height;

    // store the translation from screen coords to cartesian coords
    width_offset = w / 2;
    height_offset = h / 2;
  }

  void setCenter(double real, double imaginary) {
    center = new ComplexNumber(real, imaginary);
    min_x = center.real - width_offset;
    min_y = center.imaginary - height_offset;
  }

  void updateScene(double scale, double real, double imaginary)
  {
    setScale(scale);
    setCenter(real, imaginary);
    isDirty = true;
  }

  void update()
  {
    if(isDirty)
    {
      isDirty = false;
      most_iterations = 0;

      println("Starting Calculations");
      // calculation pass
      for(int y = 0; y < height; y++)
      {
        double imaginary = min_y + y * dy;
        for(int x = 0; x < width; x++)
        {
          double real = min_x + x * dx;
          ComplexNumber z = new ComplexNumber(0,0);
          ComplexNumber c = new ComplexNumber(real, imaginary);

          // calculate whether we're tending towards infinity
          int n = 0;
          while( n < max_iterations )
          {
            // z = z^2 + c
            z = z.multiply(z).add(c);

            if( n > most_iterations )
            {
              most_iterations = n;
            }

            n++;
            iteration_counts[x + y * width] = n;

            // can't actually detect infinity, bailout if we're certain enough
            if(z.magnitude() >= bailout)
            {
              break;
            }
          }
        }
      }

      // drawing pass
      println("Drawing Pass", colorizer.getName());
      for(int y = 0; y < height; y++)
      {
        for(int x = 0; x < width; x++)
        {
          //double nsmooth = (n - Math.log(Math.log(z.magnitude()))/Math.log(2));
          int n = iteration_counts[x + y * width];
          pixels[x+y*width] = colorizer.getColor(n, most_iterations, max_iterations); //<>//
        }
      }

      // now update screen
      updatePixels();
    }
  }
}