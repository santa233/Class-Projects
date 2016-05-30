#ifndef WIRE_HPP
#define WIRE_HPP
#include <string>
/*
 * Class reprenting a wire connected between two components.
 * The wire can hold a single value, 0 (false) or 1 (true).
 * The wire does not have references to the components it connects.  Rather,
 * the components must get/set the value held in the wire themselves.
 */
class Wire {
  private:
    std::string name;
    bool value;
  public:
    Wire(std::string);
    Wire(std::string,bool val);
    ~Wire();
    void setHigh();
    void setLow();
    void set(bool val);
    bool get();
    std::string get_name();
};



#endif
