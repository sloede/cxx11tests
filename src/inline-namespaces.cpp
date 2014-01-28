// Check if inline namespaces are supported
namespace my_lib {
namespace V1 {
  void f() {}
}
inline namespace V2 {
  void f() {}
  void g() {}
}
}

void fun() {
  my_lib::g();
}
