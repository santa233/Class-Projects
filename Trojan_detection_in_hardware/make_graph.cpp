#include "make_graph.hpp"
#include <stdlib.h>
#include <iostream>

using namespace std;

netlist_graph::netlist_graph()
{
//	default_model = val;
}
//netlist_graph::~netlist_graph()
//{


//}
//bool netlist_graph::get_default_model() 
//{
//	return default_model;
//}
void netlist_graph::insert_data_input_to_dut(std::string ip_op_arr, bool val)
{
	input_to_dut.insert_data(ip_op_arr,val);
}
void netlist_graph::insert_data_output_from_dut(std::string ip_op_arr, bool val)
{
	output_from_dut.insert_data(ip_op_arr,val);
}
void netlist_graph::insert_data_input_to_dut_t(std::string ip_op_arr, bool val)
{
	input_to_dut_t.insert_data(ip_op_arr,val);
}
void netlist_graph::insert_data_output_from_dut_t(std::string ip_op_arr, bool val)
{
	output_from_dut_t.insert_data(ip_op_arr,val);
}
void netlist_graph::insert_and(std::string cell_inst_name)
{
	//bool model = get_default_model();
	AndGate *and1;
	and1 = new AndGate;
	cell_type_and.insert(std::pair<std::string,AndGate*>(cell_inst_name,and1));
}
void netlist_graph::insert_not(std::string cell_inst_name)
{
	//bool model = get_default_model();
	NotGate *not1;
	not1 = new NotGate;
	cell_type_not.insert(std::pair<std::string,NotGate*>(cell_inst_name,not1));
}
void netlist_graph::insert_or(std::string cell_inst_name)
{
	//bool model = get_default_model();
	OrGate *or1;
	or1 = new OrGate;
	cell_type_or.insert(std::pair<std::string,OrGate*>(cell_inst_name,or1));
}
void netlist_graph::insert_into_GATE(std::string cell_type_name, std::string cell_inst_name)
{
	if(cell_type_name == "AND"){
	//fill up map cell_type _and with entry
	insert_and(cell_inst_name);
	}
	if(cell_type_name == "OR"){
	//fill up map cell_type _not with entry
	insert_or(cell_inst_name);
	}
	if(cell_type_name == "NOT"){
	//fill up map cell_type _or with entry
	insert_not(cell_inst_name);
	}
}
void netlist_graph::cell_wires_insert_data(std::string cell_inst_name, std::string wire_name)
{
	cell_wires.insert_data(cell_inst_name,wire_name);
}
void netlist_graph::ip_op_indicate(std::string cell_type_name,int word_count)
{
	if(cell_type_name=="FFGEN")
	{
		switch(word_count)
		{
			case 3:
				input = TRUE;
				output = FALSE;
				break;
			case 4:
				input = TRUE;
				output = FALSE;
				break;
			case 5:
				input = TRUE;
				output = FALSE;
				break;
			case 6:
				input = TRUE;
				output = FALSE;
				break;
			case 7: 
				input = TRUE;
				output = FALSE;
				break;
			case 8:
				input = TRUE;
				output = FALSE;
				break;
			case 9:
				output = TRUE;
				input = FALSE;
				break;	
			case 10: 
				output = TRUE;
				input = FALSE;
				break;	
			default: 
				input = TRUE;
				output = FALSE;
				break;
		}
	}
	if(cell_type_name == "NOT") 
	{
		//cout << "hi" << endl;
		switch(word_count)
		{
			case 3:
				input = TRUE;
				output = FALSE;
				break;
			case 4:
				output = TRUE;
				input = FALSE;
				break;
			default:
				input = TRUE;
				output = FALSE;
				break;
		}

	}
	else
	{
		//cout << cell_inst_name <<endl;
		switch(word_count)
		{
			case 3:
				input = TRUE;
				output = FALSE;
				break;
			case 4:
				input = TRUE;
				output = FALSE;
				break;
			case 5:
				output = TRUE;
				input = FALSE;
				break;
			default: 
				input = TRUE;
				output = FALSE;
				break;
		}
	}
}
bool netlist_graph::get_bool_input()
{
	return input;
}
bool netlist_graph::get_bool_output()
{
	return output;
}
void netlist_graph::cell_instances_input_insert_data(std::string wire_name,std::string cell_inst_name)
{
	cell_instances_input.insert_data(wire_name,cell_inst_name);
}
void netlist_graph::cell_instances_output_insert_data(std::string wire_name,std::string cell_inst_name)
{
	cell_instances_output.insert_data(wire_name,cell_inst_name);
}
std::pair<bool,std::list<std::string>> netlist_graph::cell_instances_output_get_dat (std::string wire_name)
{
	return(cell_instances_output.get_list(wire_name));
}
void netlist_graph::signals_in_dut_insert_data(std::string wire_name,bool val)
{
	if(get_bool_input() == TRUE)
	{
		if(input_to_dut.find_data(wire_name)==0)
		{
			signals_in_dut.insert_data(wire_name,0);
		}
	}
	if(get_bool_output() == TRUE)
	{
		if(output_from_dut.find_data(wire_name)==0)
		{
		    signals_in_dut.insert_data(wire_name,0);
		}
	}
	//signals_in_dut.insert_data(wire_name,val);
}
void netlist_graph::signals_in_dut_t_insert_data(std::string wire_name,bool val)
{
	if(get_bool_input() == TRUE)
	{
		if(input_to_dut_t.find_data(wire_name)==0)
		{
			signals_in_dut_t.insert_data(wire_name,0);
		}
	}
	if(get_bool_output() == TRUE)
	{
		if(output_from_dut_t.find_data(wire_name)==0)
		{
		    signals_in_dut_t.insert_data(wire_name,0);
		}
	}
	//signals_in_dut.insert_data(wire_name,val);
}
void netlist_graph::insert_input_Wire_GATE(std::string cell_type_name,std::string cell_inst_name,std::string wire_name)
{
	Wire *wire1;
	wire1 = new Wire(wire_name);
	if(cell_type_name == "AND")
		(cell_type_and.find(cell_inst_name)->second)->addInput(wire1);
	if(cell_type_name == "OR")
		(cell_type_or.find(cell_inst_name)->second)->addInput(wire1);
	if(cell_type_name == "NOT")
		(cell_type_not.find(cell_inst_name)->second)->addInput(wire1);
}
void netlist_graph::insert_output_Wire_GATE(std::string cell_type_name,std::string cell_inst_name,std::string wire_name)
{
	Wire *wire1;
	wire1 = new Wire(wire_name);
	if(cell_type_name == "AND")
		(cell_type_and.find(cell_inst_name)->second)->addOutput(wire1);
	if(cell_type_name == "OR")
		(cell_type_or.find(cell_inst_name)->second)->addOutput(wire1);
	if(cell_type_name == "NOT")
		(cell_type_not.find(cell_inst_name)->second)->addOutput(wire1);
}
void netlist_graph::incr_and_set_ip_to_dut_val(std::string line, bool alt)
{
	if(!alt)
	{
		//cout << "hi " << line ;
		if(input_to_dut.is_end()==0)
		{
			if(line=="1")
				input_to_dut.set_value(TRUE);
			else
				input_to_dut.set_value(FALSE);
		}
	}
	else 
	{
		//cout << line << " " ;
		if(input_to_dut.is_end()==0)
		{
			if(line=="1")
				input_to_dut.set_value(TRUE);
			else
				input_to_dut.set_value(FALSE);
		}
		input_to_dut.incr();
	}
	input_to_dut.incr();
}
void netlist_graph::set_input_to_dut_begin()
{
	input_to_dut.begin();
}
void netlist_graph::set_model_ALL_GATES(bool val)
{
	for (std::map<std::string, AndGate*>::iterator it = cell_type_and.begin(); it!=cell_type_and.end(); ++it)
	{ 
		//it->first 
		(it->second)->setModel(val) ; 
	}
	for (std::map<std::string, NotGate*>::iterator it = cell_type_not.begin(); it!=cell_type_not.end(); ++it)
	{ 
		//it->first 
		(it->second)->setModel(val) ; 
	}
	for (std::map<std::string, OrGate*>::iterator it = cell_type_or.begin(); it!=cell_type_or.end(); ++it)
	{ 
		//it->first 
		(it->second)->setModel(val) ; 
	}

		
}
int netlist_graph::get_number_of_inputs()
{
	return input_to_dut.size();
}
void netlist_graph::build_graph(std::list<std::string> inst_with_nonDefault_model)
{
	std::list<std::string> live_inst;
	input_to_dut.begin();
		
	while(!input_to_dut.is_end())
	{
		std::string curr = input_to_dut.get_this();
		std::pair<bool,bool> val_pair = input_to_dut.fetch_value(curr);
		bool res = val_pair.second;
		std::pair<bool,std::list<std::string>> list_of_ip_pair = cell_instances_input.get_list(curr);
		std::list<std::string> list_of_ip;
		if(list_of_ip_pair.first == 1)
		{
			list_of_ip=list_of_ip_pair.second;
			for (std::list<std::string>::iterator it=list_of_ip.begin(); it != list_of_ip.end(); ++it)
				live_inst.push_back( *it);
		}
		input_to_dut.incr();
	}
	live_inst.unique();
		int iiiii=0;
	while(!live_inst.empty())
	{

		//cout<< iiiii++ << endl;
		std::string curr = live_inst.front();
		live_inst.pop_front();
		std::vector<Wire*> curr_outputs,curr_inputs;
		int change_model=0;
		for (std::list<std::string>::iterator itt=inst_with_nonDefault_model.begin(); itt != inst_with_nonDefault_model.end(); ++itt)
		{
			//cout << "hi" << endl;
			//cout << curr <<endl;
			if(( *itt) == curr )
			{
				//cout << (*itt);
				change_model=1;
			}
		}
		if(cell_type_and.find(curr)!=cell_type_and.end())
		{
			curr_inputs = (cell_type_and[curr])->getInput();
			//cout << change_model << endl;
			if(change_model==1)
			{
				(cell_type_and[curr])->setModel(CONSERVATIVE);	
				//cout << "done" << curr<<endl;
			}
		}
		if(cell_type_or.find(curr)!=cell_type_or.end())
		{
			curr_inputs = (cell_type_or[curr])->getInput();
			//			cout << change_model << endl;
			if(change_model==1)
			{
				//cout << curr << " " << 
				(cell_type_or[curr])->setModel(CONSERVATIVE);	
				//				cout << "done" << curr <<endl;
			}
		}
		if(cell_type_not.find(curr)!=cell_type_not.end())
		{
			curr_inputs = (cell_type_not[curr])->getInput();
			//			cout << change_model << endl;
			if(change_model==1)
			{

				(cell_type_not[curr])->setModel(CONSERVATIVE);	
				//				cout << "done" <<  curr <<endl;
			}
		}
		//cout << "ger" << endl;
		int curr_ip_size = curr_inputs.size();
		std::string ops,ips;
		for ( int i = 0 ; i < curr_ip_size ; i++)	
		{
			ips = curr_inputs[i]->get_name();
			bool val;
			if(input_to_dut.find_data(ips)!=0)
				val = (input_to_dut.fetch_value(ips)).second;
			else
				val = (signals_in_dut.fetch_value(ips).second);
			//cout << curr <<" " <<ips << " " << val <<" "<< curr_ip_size << endl;
			curr_inputs[i]->set(val);
		}
		//cout << curr_ip_size << endl;
		//get op wires
		//execute curr
		//append the op of curr to op_wire
		if(cell_type_and.find(curr)!=cell_type_and.end())
		{
			//cout << endl;
			(cell_type_and[curr])->propogate();
			curr_outputs = (cell_type_and[curr])->getOutput();
		}
		if(cell_type_or.find(curr)!=cell_type_or.end())
		{
			//cout << endl;
			(cell_type_or[curr])->propogate();
			curr_outputs = (cell_type_or[curr])->getOutput();
		}
		if(cell_type_not.find(curr)!=cell_type_not.end())
		{
			//cout << endl;
			(cell_type_not[curr])->propogate();
			curr_outputs = (cell_type_not[curr])->getOutput();
		}
		int curr_op_size = curr_outputs.size();
		//cout<<"**********************"<<endl;
		for ( int i = 0 ; i < curr_op_size ; i++ )
		{
			ops = curr_outputs[i]->get_name();
			bool op_val =  curr_outputs[i]->get();
			//cout<< curr_op_size<<" "<< ops << op_val <<endl;
			std::pair<bool,std::list<std::string>> list_of_ip_pair = cell_instances_input.get_list(ops);
			std::list<std::string> list_of_ip;
			if(list_of_ip_pair.first == 1)
			{
				list_of_ip=list_of_ip_pair.second;
				for (std::list<std::string>::iterator it=list_of_ip.begin(); it != list_of_ip.end(); ++it)
					live_inst.push_back( *it);
			}
			if(signals_in_dut.find_data(ops) == 1)
				signals_in_dut.set_value(ops,op_val);
			else
				output_from_dut.set_value(ops,op_val);
			live_inst.unique();
		}
	}
	//cout << "done" << endl;
}
std::vector<Wire*> netlist_graph::get_op_wire_of_GATE(std::string curr_inst)
{
	std::vector<Wire*> op_wire ;
	if(cell_type_and.find(curr_inst) != cell_type_and.end())
		op_wire = cell_type_and[curr_inst]->getOutput();
	if(cell_type_not.find(curr_inst) != cell_type_not.end())
		op_wire = cell_type_not[curr_inst]->getOutput();	
	if(cell_type_or.find(curr_inst) != cell_type_or.end())
		op_wire = cell_type_or[curr_inst]->getOutput();
	return op_wire;

}
std::vector<std::list<std::string>> netlist_graph::propagate_thru_graph()
{
	std::vector<std::list<std::string>> list_live_signals;
	std::list<std::string> live_signals;
	std::list<std::pair<int,std::string>> inst_stack;
	input_to_dut.begin();
	int brk = 0;
	while(!input_to_dut.is_end())
	{
		std::string ip_name = input_to_dut.get_this();
		std::pair <bool,bool> val_pair = input_to_dut.fetch_value(ip_name);
		int len = ip_name.length();
		if(ip_name[len-1] == 't' && ip_name[len-2] == '_')
		{
			if(val_pair.second == 1 )
			{
				live_signals.push_back(ip_name);
				std::pair<bool,std::list<std::string>> list_pair = cell_instances_input.get_list(ip_name);
				if(cell_instances_input.find_data(ip_name)==1)
				{
					std::list<std::string> ip_inst_list = list_pair.second;
					for (std::list<std::string>::iterator it=ip_inst_list.begin(); it != ip_inst_list.end(); ++it)
					{
						std::pair<int,std::string> pp (1,*it);
						inst_stack.push_front(pp);
					}
				}
				int prev_level=0;
				int prev_level_modified = 0;
				while(!inst_stack.empty())
				{
					int prev_level_modified = 0;
					//cout << endl;
					//for (std::list<std::pair<int,std::string>>:: iterator rats = inst_stack.begin(); rats!=inst_stack.end(); ++rats)
					//{
					//	cout << (*rats).second << " " ; 
					//}
					//cout << endl;
					std::pair<int,std::string> curr_inst_pair = inst_stack.front();
					std::string curr_inst = curr_inst_pair.second;
					int curr_level = curr_inst_pair.first;
					//cout << prev_level<<" " << curr_level<< endl;
					//if((curr_level - prev_level) == 2)
					//	break;
					if(prev_level >= curr_level )
					{
						//cout << "OH!!" << endl;
						std::string live_front;
						inst_stack.pop_front();
						prev_level = prev_level - 1;
						std::pair<int,std::string> n_curr_inst_pair = inst_stack.front();
						std::string n_curr_inst = n_curr_inst_pair.second;
						int n_curr_level = n_curr_inst_pair.first;
						if(!live_signals.empty())
						{
							live_front = live_signals.back();
							live_signals.pop_back();
						}
						if(prev_level + 1== n_curr_level)
						{
							//the previous one(ie the one just popprd out) had value 0 and n_curr_ind=st is of the same level as the previous one
							//backtrack till the op of instance is 1
							//check if current instance output is 1.
							//if so then limit has been reached. 
							// else'
							//std::string live_front;
							//live_front = live_signals.back();
							//live_signals.push_back(live_front);
							std::vector<Wire*> op_wire = get_op_wire_of_GATE(n_curr_inst);
							int op_wire_size = op_wire.size();
							int ckeck_1 = 1;
							for(int i=0;i<op_wire_size;i++)
							{
								int op_wire_name_len = (op_wire[i]->get_name()).size();
								std::string op_wire_name = op_wire[i]->get_name();
								if(op_wire_name[op_wire_name_len-1] == 't' && op_wire_name[op_wire_name_len-2] == '_' ) 
								{
									//cout << "in if prev>= curr level stmt and same lvl "  << op_wire[i]->get_name() << "    " << endl;	
									if(op_wire[i]->get() == 1 && brk == 0)
									{
										//control must start from n_curr_inst
										ckeck_1 = 0;
										prev_level = n_curr_level - 1;
									}
								}
							}
							if(ckeck_1 == 1)
							{
								//was not 1
								prev_level = n_curr_level;
							}
							live_signals.push_back(live_front);
						}
						else
						{
							//if(!live_signals.empty())
							//	live_signals.pop_back();
							//the previous one(ie the one just popprd out) had value 0 and n_curr_inst is NOT of the same level as the previous one
							//std::string live_front;
							do //while(prev_level + 1== n_curr_level)
							{
								inst_stack.pop_front();
								if(!live_signals.empty())
								{
									live_front = live_signals.back();	
									live_signals.pop_back();
								}
								prev_level = prev_level - 1;
								n_curr_inst_pair = inst_stack.front();
								n_curr_inst = n_curr_inst_pair.second;
								n_curr_level = n_curr_inst_pair.first;
								//cout << "hep" << prev_level << n_curr_level<< endl;
							}while((prev_level + 1!= n_curr_level)&& !inst_stack.empty() );
							n_curr_inst_pair = inst_stack.front();
							n_curr_inst = n_curr_inst_pair.second;
							n_curr_level = n_curr_inst_pair.first;
							prev_level = n_curr_level - 1;
							//cout << live_front << endl;
							live_signals.push_back(live_front);
						}
					}
					else
					{
						std::vector<Wire*> op_wire = get_op_wire_of_GATE(curr_inst);
						int op_wire_size = op_wire.size();
						for(int i=0;i<op_wire_size;i++)
						{
							int op_wire_name_len = (op_wire[i]->get_name()).size();
							std::string op_wire_name = op_wire[i]->get_name();
							if(op_wire_name[op_wire_name_len-1] == 't' && op_wire_name[op_wire_name_len-2] == '_' ) 
							{
								//cout << "before "  << op_wire[i]->get_name() << "    " << endl;	
								if(op_wire[i]->get() == 1 && brk == 0)
								{	
									//cout << "inside "  << op_wire[i]->get_name() << "    " ;								
									live_signals.push_back(op_wire_name);
									std::pair<bool,std::list<std::string>> list_pair = cell_instances_input.get_list(op_wire_name);
									if(cell_instances_input.find_data(op_wire_name)==1)
									{
										std::list<std::string> ip_inst_list =list_pair.second;
										for (std::list<std::string>::iterator it=ip_inst_list.begin(); it != ip_inst_list.end(); ++it)
										{
											std::pair<int,std::string> pp (curr_level+1,*it);
											inst_stack.push_front(pp);
											//cout << endl;
											//for (std::list<std::pair<int,std::string>>:: iterator rats = inst_stack.begin(); rats!=inst_stack.end(); ++rats)
											//{
											//	cout << (*rats).second << " " ; 
											//}
											//cout << endl;
										}
									}
									else
									{
										//cout << "REACHED OP "  << op_wire[i]->get_name() << "    ";	 
										if(cell_instances_output.find_data(op_wire_name)==1)
										{
											//cout << "it works!! " << endl;
											std::list<std::string> oplist = live_signals;
											list_live_signals.push_back(oplist);
											//cout << prev_level << endl;
											while(!inst_stack.empty())
											{
												std::pair<int,std::string> curr_inst_pair_bktrk = inst_stack.front();
												std::string curr_inst_bktrk = curr_inst_pair_bktrk.second;
												std::vector<Wire*> op_wire_bktrk = get_op_wire_of_GATE(curr_inst_bktrk);
												int check =0;
												for(int i=0;i<op_wire_bktrk.size();i++)
												{
													int op_wire_bktrk_name_len = (op_wire_bktrk[i]->get_name()).size();
													std::string op_wire_bktrk_name = op_wire_bktrk[i]->get_name();
													if(op_wire_bktrk_name[op_wire_bktrk_name_len-1] == 't' && op_wire_bktrk_name[op_wire_bktrk_name_len-2] == '_' ) 
													{
														for (std::list<std::string>::iterator ittt=live_signals.begin(); ittt != live_signals.end(); ++ittt)
														{
															string chk1 = *ittt;
															string chk2 = op_wire_bktrk[i]->get_name();
													    	if(chk1 == chk2)
													    	{
													    		live_signals.erase(ittt);
													    		check = 1;
													    		//cout << "ok" << endl; 
													    		prev_level_modified = 1;
													    		prev_level = prev_level-1;
													    		break;
													    	}
														}
													}
												}
												if(check == 0)
												{
													//prev_level_modified = 0;
													prev_level = prev_level +1;
													break;
												}
												else
												{
													inst_stack.pop_front();
													//cout << endl;
													//for (std::list<std::pair<int,std::string>>:: iterator rats = inst_stack.begin(); rats!=inst_stack.end(); ++rats)
													//{
													//	cout << (*rats).second << " " ; 
													//}
													//cout <<prev_level << endl;
												}
											}
										}
									}
								}
								else
								{
									//prev_level_modified = 1;
									//inst_stack.pop_front();
									//prev_level_modified = 1;	
									//prev_level = prev_level-1;
								}

							}
						}
						if(prev_level_modified == 0)
							prev_level = curr_level;
					}	
				}
			}
		}
		live_signals.clear();
		inst_stack.clear();
		input_to_dut.incr();
	}
	return list_live_signals;
}
void netlist_graph::print_datas()
{
	cout << endl << endl;
	cout << "INPUTS =>  Values" << endl;
	input_to_dut.print_map();
	cout << "******************" << endl;
	cout << "signal/input  =>   inputs to which cell instance" << endl;
	cell_instances_input.print_data();
	cout << "******************" << endl;
	cout << "signal/input  =>   outputs from which cell instance" << endl;
	cell_instances_output.print_data();
	//cout << "******************" << endl;
	cout << "******************" << endl;
	cout << "OUTPUT(S) =>  Values" << endl;
	output_from_dut.print_map();
	cout << "******************" << endl;
	cout << "INTERNAL SIGNALS =>  Values" << endl;
	signals_in_dut.print_map();
	cout << "******************" << endl;
}
void netlist_graph::clear_map_signals_bool()
{
	input_to_dut.set_ALL(0);
	output_from_dut.set_ALL(0);
	signals_in_dut.set_ALL(0);
}