#ifndef MAPSIGNALS_HPP
#define MAPSIGNALS_HPP
#include <string>
#include <map>
#include <list>

class map_signals
{
	private:
		std::map<std::string,bool> mapsignals;
		std::map<std::string,bool>::iterator it;
	public:
		map_signals();
		void insert_data(std::string key, bool value);
		bool find_data(std::string key);
		std::pair <bool,bool> fetch_value (std::string key);
		void print_map();
		bool is_end();
		void begin();
		void end();
		void incr();
		void set_value(bool value);
		int size();
		void set_value(std::string key, bool value);
		void set_ALL(bool val);
		std::string get_this();
};

#endif