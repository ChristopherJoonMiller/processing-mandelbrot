/**
 * Complex Number Class
 * by Christopher Joon Miller
 */

class ComplexNumber
{
  // data storage for the real and imaginary parts of the number
  double real;
  double imaginary;
  public
  ComplexNumber( double r, double i )
  {
    real = r;
    imaginary = i;
  }

  double magnitude()
  {
    double value = java.lang.Math.sqrt(real*real + imaginary*imaginary); //<>//
    return value;
  }

  ComplexNumber add(ComplexNumber operand)
  {
    return new ComplexNumber(real + operand.real, imaginary + operand.imaginary);
  }

  ComplexNumber subtract(ComplexNumber operand)
  {
    return new ComplexNumber(real - operand.real, imaginary - operand.imaginary);
  }

  ComplexNumber multiply(ComplexNumber operand)
  {
    return new ComplexNumber(
      (real * operand.real) - (imaginary * operand.imaginary),
      (imaginary * operand.real) + (real * operand.imaginary)
    );
  }

  ComplexNumber divide(ComplexNumber operand)
  {
    double denominator = (operand.real * operand.real + operand.imaginary * operand.imaginary);
    return new ComplexNumber(
      (real * operand.real + imaginary * operand.imaginary) / denominator,
      (imaginary * operand.real - real * operand.imaginary) / denominator
    );
  }
}