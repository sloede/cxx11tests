// Check if std::unique_ptr is supported
#include <memory>
#include <string>

void f() {
  std::unique_ptr<std::string> p(new std::string);
}
