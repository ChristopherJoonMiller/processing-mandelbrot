/**
 * Pixel Renderer Class
 * by Christopher Joon Miller
 */
import processing.core.*;

class Renderer
{
  boolean isDirty = false;
  double bailout = 4.0;
  int max_iterations = 1000;
  int[] iteration_counts;
  int pixel_count = 0;
  ComplexNumber[] complexes; // compute and store all complex numbers
  int most_iterations = 0; // store the max in the scene
  double w, h, dx, dy, width_offset, height_offset, min_x, min_y, scale;
  ComplexNumber center;
  ArrayList<ColoringStrategy> colorizers = new ArrayList<ColoringStrategy>();
  int selectedColorizer = 0;
  processing.core.PApplet parentApp;
  GUI gui;

  Renderer(processing.core.PApplet parent)
  {
    // Store the parent app reference
    parentApp = parent;

    // Create a GUI
    gui = new GUI(this); //<>//

    pixel_count = width * height;
    iteration_counts = new int[pixel_count];
    complexes = new ComplexNumber[pixel_count];

    // init buffer
    background(0, 0, 0);
    loadPixels();
 //<>//
    // finally draw
    updateScene(1.0, 0, 0);
  }

  processing.core.PApplet getParentApp()
  {
    return parentApp;
  }

  void initGui()
  {
    // call this after all of the coloring strategies have registered themselves
    gui.initColoringStrategySelector();
  }

  ArrayList<ColoringStrategy> getColoringStrategies()
  {
    return colorizers;
  }

  void setSelectedColoringStrategy(int index)
  {
    selectedColorizer = index;
    isDirty = true;
  }

  void registerColoringStrategy(ColoringStrategy cs)
  {
    colorizers.add(cs);
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
    if( gui.isVisible )
    {
      return;
    }
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
    //center = new ComplexNumber(real, imaginary);
    min_x = real - width_offset;
    min_y = imaginary - height_offset;

    // now that we have our min limit
    // calculate the complexes once
    int i = 0;
    for(int y = 0; y < height; y++)
    {
      double imaginary_y = min_y + y * dy;
      for(int x = 0; x < width; x++)
      {
        double real_x = min_x + x * dx;
        ComplexNumber c = new ComplexNumber(real_x, imaginary_y);
        complexes[i] = c;
        i++;
      }
    }
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
      ColoringStrategy colorizer = colorizers.get(selectedColorizer);
      isDirty = false;
      most_iterations = 0;

      // initialize z;
      ComplexNumber z = new ComplexNumber(0,0);

      println("Starting Calculations");

      // calculation pass
      for(int i = 0; i < pixel_count; i++)
      {
        z.real = z.imaginary = 0; // assigning 0s is faster than re allocating

        // calculate whether we're tending towards infinity
        int n = 0;
        while( n < max_iterations )
        {
          // z = z^2 + c
          z = z.multiply(z).add(complexes[i]);

          if( n > most_iterations )
          {
            most_iterations = n;
          }

          n++;
          iteration_counts[i] = n;

          // can't actually detect infinity, bailout if we're certain enough
          if(z.magnitude() >= bailout)
          {
            break;
          }
        }
      }
      // drawing pass
      println("Drawing Pass", colorizer.getName());
      for(int i = 0; i < pixel_count; i++)
      {
        pixels[i] = colorizer.getColor(iteration_counts[i], most_iterations, max_iterations, complexes[i]);
      }

      // now update screen
      updatePixels();
    }
  }
  void toggleGui()
  {
    // when hiding the UI we need to redraw ourselves
    if(gui.isVisible)
    {
      isDirty = true;
    }
    gui.setVisible(!gui.isVisible);
  }
}