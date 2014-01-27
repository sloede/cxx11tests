// Check if std::weak_ptr is supported
#include <memory>
#include <string>

void f() {
  std::weak_ptr<std::string> p(new std::string);
}
