// Check if trailing return types are supported
#include <algorithm>
#include <vector>

void fun() {
  int val = 0;
  std::vector<int> v{0, 1, 2, 4, 8};
  std::sort(v.begin(), v.end(),
            [&](int i, int j)->bool{ val++; return i < j && val++ < i; });
}
