#include "wire.hpp"
#include <string>
/*
 * Implementation of Wire
 */
Wire::Wire(std::string NAME) {
  name=NAME;
  value = 0;
}

Wire::Wire(std::string NAME,bool val) {
  name=NAME;
  value = val;
}

void Wire::setHigh() {
  value = 1;
}

void Wire::setLow() {
  value = 0;
}

void Wire::set(bool val) {
  this->value = val;
}

bool Wire::get() {
  return value;
}

std::string Wire::get_name()
{
	return name;
}