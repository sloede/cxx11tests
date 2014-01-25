// Check if range-based for loops are possible
#include<vector>

std::vector<int> v(10);

void fun() {
  for (int& i: v) {
    i++;
  }
}
