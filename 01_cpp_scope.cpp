#include <iostream>
#include <string>
#include <utility>

class Resource {
  public:
    Resource (std::string name) : name_(std::move(name)) {
        std::cout << "Acquired " << name_ << "\n";
    }
    ~Resource () {
        std::cout << "Released " << name_ << "\n";
    }

  private:
    std::string name_;
};

int main() {
    try {
        Resource a("A");
        Resource b("B");
        // do something with a and b
        throw std::exception();
        // do some more with a and b
    } catch (const std::exception &) {
        std::cout << "Oops\n";
    }
}
