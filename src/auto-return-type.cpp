// Check if return type deduction works
#include <string>
std::string fun() {
  return std::string("Wololo!");
}

auto s = fun();
