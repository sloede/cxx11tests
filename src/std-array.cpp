// See if some of the new std::array methods are supported
#include <array>

void f() {
  std::array<int, 5> a;
  int* p = a.data();
}
