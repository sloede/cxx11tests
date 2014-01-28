// Check if std::move is supported
#include <utility>

template <class T>
void my_swap(T& a, T& b) {
  T t(std::move(a));
  a = std::move(b);
  b = std::move(t);
};

void f() {
  int i, j;
  my_swap(i, j);
}
