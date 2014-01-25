// Check if lambda expressions are supported in general
#include <numeric>
#include <vector>

void fun() {
  std::vector<int> v{0, 1, 2, 4, 8};
  int val = std::accumulate(v.begin(), v.end(), 0,
                            [](int i, int a){ return i+a; });
}
