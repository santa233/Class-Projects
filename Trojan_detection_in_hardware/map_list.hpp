#ifndef INSTWIRE_HPP
#define INSTWIRE_HPP
#include <string>
#include <map>
#include <list>
class inst_wire
{
	private:
		std::map<std::string,std::list<std::string> >  maplist;
		std::map<std::string,std::list<std::string> >::iterator it;
	public:
		inst_wire();
//		~inst_wire();
		void insert_data(std::string key,std::string item_to_insert);
		bool find_data(std::string key);
		//std::list<std::string> get_data(std::string key);
		std::pair<bool,std::list<std::string>> get_list(std::string key);
		void print_data();
};


#endif