// Check if the new features of std::vector are supported
#include <vector>

void f() {
  std::vector<int> v;
  v.emplace_back(10);
  v.shrink_to_fit();
  int* d = v.data();
  v.cbegin();
  v.cend();
  v.crbegin();
  v.crend();
}
