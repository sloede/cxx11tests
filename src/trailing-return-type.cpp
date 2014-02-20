// Check if trailing return types are supported
#include <algorithm>
#include <vector>

void fun() {
  int val = 0;
  std::vector<int> v(5);
  std::sort(v.begin(), v.end(),
            [&](int i, int j)->bool{ val++; return i < j && val++ < i; });
}
