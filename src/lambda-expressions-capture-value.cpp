// Check if lambda expressions with capture-by-value are supported
#include <algorithm>
#include <vector>

void fun() {
  const int val = 0;
  std::vector<int> v(5);
  std::sort(v.begin(), v.end(),
            [=](int i, int j){ return i < j && val < i; });
}
