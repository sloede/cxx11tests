// Check if variadic templates are supported
template <class... Args> struct TClass {};

TClass<int, double> tc;

template <class T, class... Dims>
T get_value(T* ptr, Dims... parameters) { return *ptr; };

void f() {
  int i = 4;
  double x = 0.5;
  double y = 1.4;
  get_value(&i, x, y);
}
