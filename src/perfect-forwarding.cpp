// Check if perfect forwarding is supported
#include <string>
template <class T>
void f(T&& n) {
  std::string name = std::forward<T>(n);
}
