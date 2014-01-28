// Check if local types are allowed as template arguments
#include <algorithm>

void f() {
  struct Sorter { bool operator()(int a, int b) { return a > b; } };
  int values[5] = {0, 4, 3, 2, 4};
  std::sort(values, values+5, Sorter());
}
