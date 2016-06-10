class Renderer
{
  boolean isDirty = false;
  double bailout = 4.0;
  int max_iterations = 1000;
  int[] iteration_counts;
  int most_iterations = 0; // store the max in the scene
  double w, h, dx, dy, width_offset, height_offset, min_x, min_y, scale;
  ComplexNumber center;

  Renderer()
  {
    iteration_counts = new int[width * height];
    background(255,255,0);
    // init buffer
    loadPixels();
    updateScene(1.0, 0, 0);
  }

  void updateMaxIterations(double scaler)
  {
    if( scaler != 0.0 )
    {
      max_iterations *= scaler;
      println("updated max_iterations", max_iterations);
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
    isDirty = false;
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
        most_iterations = 0;
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
    for(int y = 0; y < height; y++)
    {
      for(int x = 0; x < width; x++)
      {
        //double nsmooth = (n - Math.log(Math.log(z.magnitude()))/Math.log(2));
        int n = iteration_counts[x + y * width];
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

    // now update screen
    updatePixels();
  }
}
