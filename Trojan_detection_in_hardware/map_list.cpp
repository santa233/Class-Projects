#include "map_list.hpp"
#include <iostream>
//Constructor.
inst_wire::inst_wire()
{
	// empty constructor
}
void inst_wire::insert_data(std::string key, std::string item_to_insert)
{
	it = maplist.find(key);
	if(it==maplist.end()) {
	//	create position for new key.
		std::list<std::string> List;
		List.push_back(item_to_insert);
		maplist.insert(std::pair<std::string,std::list<std::string> >(key,List));
	}
	else
	{
	//  append the item to be inserted into the list corresponding to the key in the map.
		(maplist.find(key)->second).push_back(item_to_insert);	
	}	      						
}

bool inst_wire::find_data(std::string key)
{
	it=maplist.find(key);
	if(it==maplist.end()) // ie if absent
		return 0;
	else
		return 1;
}

std::pair<bool,std::list<std::string>> inst_wire::get_list(std::string key)
{
	std::list<std::string> List;
	if(find_data(key)==0)
	{
		return std::pair<bool,std::list<std::string>> (0,List);
	}
	else
	{
		List = maplist[key];
		return std::pair<bool,std::list<std::string>> (1,List);
	}
}

void inst_wire::print_data()
{
	for (it = maplist.begin(); it!=maplist.end(); ++it)
	{ 
		int list_size = (it->second).size();
		std::cout << it->first << " =>  " ; 
		for (std::list<std::string>::iterator itt=(it->second).begin(); itt != (it->second).end(); ++itt)
    		std::cout << " " << *itt;
    	std::cout << "\n";
	}
}