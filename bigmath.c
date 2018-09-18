#include "math.h"

int BIGMATH_add_3(int a, int b, int c)
{
    return MATH_add(a, MATH_add(b, c));
}