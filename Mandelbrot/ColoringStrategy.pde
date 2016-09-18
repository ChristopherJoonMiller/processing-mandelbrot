/**
 * Mandlebrot Colorization Strategies
 * by Christopher Joon Miller
 */

// Todo, make math lib
double ONE_OVER_LOG2 = 1 / Math.log(2);

public interface ColoringStrategy
{
  public color getColor(int n, int most_iterations, int max_iterations, ComplexNumber c);
  public String getName();
}

class BlackColoringStrategy implements ColoringStrategy
{
  public color getColor(int n, int most_iterations, int max_iterations, ComplexNumber c)
  {
    return n == max_iterations ? color(0,0,0) : color(255,255,255);
  }

  public String getName()
  {
    return "Default Black";
  }
}

class SmoothedGreenColoringStrategy implements ColoringStrategy
{
  public color getColor(int n, int most_iterations, int max_iterations, ComplexNumber c)
  {
    if(n == max_iterations) // in set
    {
      return color(40);
    }

    double quotient = Math.max(0, Math.min(1, n / (float)most_iterations)); // between 0 and 1
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

    return col;
  }

  public String getName()
  {
    return "Smoothed Green";
  }
}

class Palette
{
  String name;
  color[] colors;
  Palette(String n, color[] color_array)
  {
    name = n;
    colors = color_array;
  }

  String getName()
  {
    return name;
  }

  int getSize()
  {
    return colors.length;
  }

  color getColor(int slot)
  {
    slot = Math.max(0, Math.min(colors.length - 1, slot)); // clamp between 0 and colors.length -1
    return colors[slot];
  }
}

class PalettizedColoringStrategy implements ColoringStrategy
{
  Palette p;
  public
  PalettizedColoringStrategy(Palette palette)
  {
    p = palette;
  }

  public color getColor(int n, int most_iterations, int max_iterations, ComplexNumber c)
  {
    if(n == max_iterations) // in set
    {
      return color(40);
    }
 //<>//
    double size = Math.sqrt(c.real * c.real + c.imaginary * c.imaginary);
    double smoothed = Math.log(Math.log(n) * ONE_OVER_LOG2) * ONE_OVER_LOG2;
    int slot = (int)(Math.sqrt(n - smoothed)) % p.getSize();

    return p.getColor(slot);
  }

  public String getName()
  {
    return "Palettized " + p.getName();
  }
}

void initColoringStrategies(Renderer r)
{
    // Black
    r.registerColoringStrategy(new BlackColoringStrategy());

    // Smoothed Green
    r.registerColoringStrategy(new SmoothedGreenColoringStrategy());

    // Orange Float
    color[] orange_floats = {color(252,148,88), color(252,198,158), color(252,248,248), color(152,238,252), color(52,228,252)};
    Palette of = new Palette("Orange Floats", orange_floats);
    r.registerColoringStrategy(new PalettizedColoringStrategy(of));
}