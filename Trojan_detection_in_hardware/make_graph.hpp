#include <iostream>
#include <stdlib.h>
#include <string>
#include <fstream>
#include <map>
#include <list>
#include <sstream>
#include <vector>
#include "map_list.hpp"
#include "map_signals.hpp"
#include "component.hpp"
#include "wire.hpp"
# define TRUE 1
# define FALSE 0
#define CONSERVATIVE FALSE
#define PRECISE TRUE

class netlist_graph
{
	private:
		//std::string cell_inst_name,cell_type_name,wire_name;
		bool default_model;
		map_signals input_to_dut,output_from_dut, signals_in_dut;
		map_signals input_to_dut_t,output_from_dut_t, signals_in_dut_t;
		std::map<std::string,AndGate*> cell_type_and;
		std::map<std::string,OrGate*> cell_type_or;
		std::map<std::string,NotGate*> cell_type_not;
		inst_wire cell_wires,cell_instances_input,cell_instances_output;
		bool input, output;
	public:
		netlist_graph();
		//bool get_default_model();
		void insert_data_input_to_dut(std::string ip_op_arr , bool val);
		void insert_data_output_from_dut(std::string ip_op_arr , bool val);
		void insert_data_input_to_dut_t(std::string ip_op_arr , bool val);
		void insert_data_output_from_dut_t(std::string ip_op_arr , bool val);
		void insert_and(std::string cell_inst_name);
		void insert_not(std::string cell_inst_name);
		void insert_or(std::string cell_inst_name);
		void insert_into_GATE(std::string cell_type_name, std::string cell_inst_name);
		void cell_wires_insert_data(std::string cell_inst_name, std::string wire_name);
		void ip_op_indicate(std::string cell_type_name,int word_count);
		bool get_bool_input();
		bool get_bool_output();
		void cell_instances_input_insert_data(std::string wire_name , std::string cell_inst_name);
		void cell_instances_output_insert_data(std::string wire_name,std::string cell_inst_name);
		std::pair<bool,std::list<std::string>> cell_instances_output_get_dat (std::string wire_name);
		void signals_in_dut_insert_data(std::string wire_name,bool val);
		void signals_in_dut_t_insert_data(std::string wire_name,bool val);
		void insert_input_Wire_GATE(std::string cell_type_name,std::string cell_inst_name,std::string wire_name);
		void insert_output_Wire_GATE(std::string cell_type_name,std::string cell_inst_name,std::string wire_name);
		void incr_and_set_ip_to_dut_val(std::string line,bool);
		void set_input_to_dut_begin();
		void set_model_ALL_GATES(bool val);
		int get_number_of_inputs();
		void build_graph(std::list<std::string>inst_with_nonDefault_model);
		std::vector<Wire*> get_op_wire_of_GATE(std::string curr_inst);
		std::vector<std::list<std::string>> propagate_thru_graph();
		void print_datas();
		void clear_map_signals_bool();
};