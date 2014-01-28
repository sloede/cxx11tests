// Check if the variadic version of the sizeof... operator
template <class... Ts>
struct MyClass {
  int noTypes() { return sizeof...(Ts); }
};
