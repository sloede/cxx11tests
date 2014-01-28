// Check if std::shared_ptr is supported
#include <memory>
#include <string>

void f() {
  std::shared_ptr<std::string> p(new std::string);
}
