// Check if range-based for loops are possible
#include<vector>

std::vector<int> v;
for (int& i: v) {
  i++;
}
