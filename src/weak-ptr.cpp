// Check if std::weak_ptr is supported
#include <memory>

void f() {
  std::weak_ptr<int> p1;
  std::weak_ptr<int> p2(p1);
}
