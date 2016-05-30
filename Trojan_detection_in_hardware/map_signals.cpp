#include "map_signals.hpp"
#include <iostream>
#include <string>
#include <map>
#include <list>

using namespace std;
//constructor
map_signals::map_signals()
{
	//empty constructor
}

void map_signals::insert_data(std::string key, bool value)
{
	it=mapsignals.find(key);
	if(it==mapsignals.end())
		mapsignals.insert(std::pair<std::string,bool>(key,value));
	else
		mapsignals[key] = value;
}

bool map_signals::find_data( std::string key)
{
	it=mapsignals.find(key);
	if(it==mapsignals.end()) // ie if absent
		return 0;
	else
		return 1;
}

std::pair <bool,bool> map_signals::fetch_value(std::string key)
{
	if(find_data(key)==0)
		return std::pair<bool,bool> (0,0);
	else
		return std::pair<bool,bool> (1,mapsignals[key]);
}

void map_signals::print_map()
{
	for (it = mapsignals.begin(); it!=mapsignals.end(); ++it)
	{ std::cout << it->first << " => " << it->second << '\n'; }
		
} 

void map_signals::begin()
{
	it=mapsignals.begin();
}

void map_signals::end()
{
	it=mapsignals.end();
}

std::string map_signals::get_this()
{
	return it->first;
}

void map_signals::incr()
{
	++it;
}
void map_signals::set_value(bool value)
{
	//cout << it-> first << endl;
	it->second=value;
}

void map_signals::set_value(std::string key, bool value)
{
	mapsignals[key]=value;
}

bool map_signals::is_end()
{
	if(it==mapsignals.end())
		return 1;
	else
		return 0;
}
int map_signals::size()
{
	return mapsignals.size();
}

void map_signals::set_ALL(bool val)
{
	for (it = mapsignals.begin(); it!=mapsignals.end(); ++it)
	{ 
		it->second = val; }
}