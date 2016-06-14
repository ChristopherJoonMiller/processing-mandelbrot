/**
 * Mandlebrot Colorization Strategies
 * by Christopher Joon Miller
 */

public interface ColoringStrategy
{
  public color getColor(int n, int most_iterations, int max_iterations);
  public String getName();
}

class BlackColoringStrategy implements ColoringStrategy
{
  public color getColor(int n, int most_iterations, int max_iterations)
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
  public color getColor(int n, int most_iterations, int max_iterations)
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
    slot = Math.max(0, Math.min(colors.length - 1, slot)); // between 0 and 1
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

  public color getColor(int n, int most_iterations, int max_iterations)
  {
    if(n == max_iterations) // in set
    {
      return color(40);
    }

    float quotient = Math.max(0, Math.min(1, n / (float)most_iterations)); // between 0 and 1
    int slot = round(quotient * p.getSize()); //<>//

    return p.getColor(slot);
  }

  public String getName()
  {
    return "Palettized " + p.getName();
  }
}