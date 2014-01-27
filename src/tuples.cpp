// Check if some of the operations of the new typle class are supported
#include <tuple>

void f() {
  std::tuple<int, int, double> mytuple;
  int val = std::get<0>(mytuple);

  int a, b;
  double c;
  std::tie(a, b, c) = mytuple;
}
