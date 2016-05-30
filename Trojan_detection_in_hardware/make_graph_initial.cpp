// Example program




////////////////////////////////////////////////////





//WRITE DESTRUCTOR FUNCTION FOR COMPONENT








/////////////////////////////////////////////////
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

using namespace std;


int main()
{
    std::string line;
    std::ifstream text1 ("simple.txt");
    std::ifstream text2 ("ip.txt");
	std::string wordone("\0"),word;
	std::string a;
	std::string cell_inst_name,cell_type_name,wire_name;
	map_signals input_to_dut,output_from_dut, signals_in_dut;
	std::map<std::string,AndGate*> cell_type_and;
	std::map<std::string,OrGate*> cell_type_or;
	std::map<std::string,NotGate*> cell_type_not;
	inst_wire cell_wires,cell_instances_input,cell_instances_output;
	std::string signal_type;
	int i=0,linecount=0;
	bool input, output;
	int nummax,nummin;
	int ip_op;
	bool nummax_done,nummin_done;
	if (text1.is_open())
	{
		while (text1.good())
		{
			getline(text1,line);
			wordone.clear();
			int size=line.size();
			int word_count=0;
			linecount++;
			nummax_done = FALSE;
			nummin_done = FALSE;
			ip_op = 0;
    		for(i=0;i<size;i++)
   			{
        		a=line[i];
        		if( a!= " ")
        		{
        		    wordone.push_back(line[i]);
        		}
        		else
        		{
        			word=wordone;
        			wordone.clear();
        	    	if(word.size()>0)
           	 		{
      					word_count++;
      					if(word == "input" || word == "output" )
      					{
      						ip_op=1;
      						signal_type = word;
      					}
      					else
      					{
	      					if(ip_op==1)
	      					{
	      						if(word[0]-48 >=0 && word[0]-48 <= 9)
	      						{
	      							if(nummax_done == FALSE)
	      							{
	      								nummax = atoi(word.c_str());
	      								nummax_done = TRUE;
	      							}
	      							else
	      							{
	      								if(nummin_done == FALSE)
	      								{
	      									nummin = atoi(word.c_str());
	      									nummin_done = TRUE;
	      								}
	      							}
	      						}
	      						else 
	      						{
	      							if(nummax_done == TRUE && nummin_done == TRUE)
	      							{
	      								cout << "done array " << word << endl;
	      								for(int ii=nummin ; ii<=nummax ; ii++)
	      								{
		      								std::string ip_op_arr = word;
		      								char q = '[';
		      								ip_op_arr.push_back(q);
		      								std::string op = std::to_string(ii);
		      								for (int len=0 ; len < op.size() ; len++)
		      									ip_op_arr.push_back(op[len]);
		      								q= ']';
		      								ip_op_arr.push_back(q);
		   									cout << signal_type << " " << word <<  endl;
		      								if(signal_type == "input" && word != "input")
		      								{
			      								input_to_dut.insert_data(ip_op_arr,FALSE);
			      							}
			      							if(signal_type == "output" && word != "output")
		      								{
			      								output_from_dut.insert_data(ip_op_arr,FALSE);
			      							}			
		      							}
		      						}
		      						if(nummax_done == FALSE && nummin_done == FALSE)
		      						{
										std::string ip_op_arr = word;
										if(signal_type == "input" && word != "input")
		      							{	
			      							input_to_dut.insert_data(ip_op_arr,FALSE);
			      						}
			      						if(signal_type == "output" && word != "output")
		      							{
			      							output_from_dut.insert_data(ip_op_arr,FALSE);
			      						}		

		      						}
		      					}
		      				}
	      				}
	      				if(ip_op==0)
	      				{
		      				if(word=="\0") {
		      					word_count=0;
		      				}
		      				if(word_count==1)
		      				{
		//      				cell type
		      					cell_type_name=word;	
		      				}
		      				if(word_count==2)
		      				{
		//      				cell instance
		      					cell_inst_name=word;
								if(cell_type_name == "AND"){
		//						fill up map cell_type _and with entry
		      						AndGate *and1;
		      						and1 = new AndGate;
									cell_type_and.insert(std::pair<std::string,AndGate*>(cell_inst_name,and1));
								}
								if(cell_type_name == "OR"){
		//						fill up map cell_type _and with entry
									OrGate *or1;
									or1 = new OrGate;
									cell_type_or.insert(std::pair<std::string,OrGate*>(cell_inst_name,or1));
								}
								if(cell_type_name == "NOT"){
		//						fill up map cell_type _and with entry
									NotGate *not1;
									not1 = new NotGate;
									cell_type_not.insert(std::pair<std::string,NotGate*>(cell_inst_name,not1));
								}
		      				}
		      				if(word_count>2)
		      				{
		//						wires
		      					wire_name=word;
		//						fill the cell wires map
								cell_wires.insert_data(cell_inst_name,wire_name);
		      					//find if the wire is an input to the gate or output.
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
		//      				INPUT
		      					if(input == TRUE)
		      					{
									cell_instances_input.insert_data(wire_name,cell_inst_name);
									if(input_to_dut.find_data(wire_name)==0) {
		      							signals_in_dut.insert_data(wire_name,0);
		      						}
									Wire *wire1;
		      						wire1 = new Wire(wire_name);
		      						if(cell_type_name == "AND")
		      							(cell_type_and.find(cell_inst_name)->second)->addInput(wire1);
		      						if(cell_type_name == "OR")
		      							(cell_type_or.find(cell_inst_name)->second)->addInput(wire1);
		      						if(cell_type_name == "NOT")
		      							(cell_type_not.find(cell_inst_name)->second)->addInput(wire1);
		      					}
		//      					OUTPUT
		      					if( output == TRUE)
		      					{
									cell_instances_output.insert_data(wire_name,cell_inst_name);
									if(output_from_dut.find_data(wire_name)==0)
		      							signals_in_dut.insert_data(wire_name,0);
									Wire *wire1;
		      						wire1 = new Wire(wire_name);
		      						if(cell_type_name == "AND")
		      							(cell_type_and.find(cell_inst_name)->second)->addOutput(wire1);
		      						if(cell_type_name == "OR")
		      							(cell_type_or.find(cell_inst_name)->second)->addOutput(wire1);
		      						if(cell_type_name == "NOT")
		      							(cell_type_not.find(cell_inst_name)->second)->addOutput(wire1);
		      					}
		      				}	
		      			}
		      		wordone.clear();
	            	}
        		}    
    		}
		}
		text1.close();
		if(text2.is_open())
		{
			input_to_dut.begin();
			while(text2.good())
			{
				getline(text2,line);
				wordone.clear();
				int size=line.size();
				int word_count=0;
				linecount++;
				if(line!="\0")
				{
					if(input_to_dut.is_end()==0)
					{
						if(line=="1")
							input_to_dut.set_value(TRUE);
						else
							input_to_dut.set_value(FALSE);
						input_to_dut.incr();
					}
				}
			}
		}
		text2.close();
		cout << "\n" << "\n";
		cout << "INPUTS =>  Values" << endl;
		input_to_dut.print_map();
		cout << "******************" << endl;
		cout << "signal/input  =>   inputs to which cell instance" << endl;
		cell_instances_input.print_data();
		cout << "******************" << endl;
		cout << "signal/input  =>   outputs from which cell instance" << endl;
		cell_instances_output.print_data();
		cout << "******************" << endl;
		/////////////////////////////// ******** BUILD GRAPH ******** /////////////////////////////////////////////////////////////
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
		while(!live_inst.empty())
		{
			std::string curr = live_inst.front();
			cout << curr << endl;
			live_inst.pop_front();
			//update ip wires values
			std::vector<Wire*> curr_outputs,curr_inputs;
			if(cell_type_and.find(curr)!=cell_type_and.end())
			{
				curr_inputs = (cell_type_and[curr])->getInput();
			}
			if(cell_type_or.find(curr)!=cell_type_or.end())
			{
				curr_inputs = (cell_type_or[curr])->getInput();
			}
			if(cell_type_not.find(curr)!=cell_type_not.end())
			{
				curr_inputs = (cell_type_not[curr])->getInput();
			}
			int curr_ip_size = curr_inputs.size();
			std::string ops,ips;
			cout << curr_ip_size << endl;
			for ( int i = 0 ; i < curr_ip_size ; i++)	
			{
				ips = curr_inputs[i]->get_name();
				cout << ips << endl;;
				bool val;
				if(input_to_dut.find_data(ips)!=0)
					val = (input_to_dut.fetch_value(ips)).second;
				else
					val = (signals_in_dut.fetch_value(ips).second);
				curr_inputs[i]->set(val);
			}
			//get op wires
			//execute curr
			//append the op of curr to op_wire
			if(cell_type_and.find(curr)!=cell_type_and.end())
			{
				(cell_type_and[curr])->propogate();
				//cout "hi "
				curr_outputs = (cell_type_and[curr])->getOutput();
				//cout "hi "
			}
			if(cell_type_or.find(curr)!=cell_type_or.end())
			{
				(cell_type_or[curr])->propogate();
				//cout "hi "
				curr_outputs = (cell_type_or[curr])->getOutput();
				//cout "hi "
			}
			if(cell_type_not.find(curr)!=cell_type_not.end())
			{
				(cell_type_not[curr])->propogate();
				//cout "hi "
				curr_outputs = (cell_type_not[curr])->getOutput();
			}
			int curr_op_size = curr_outputs.size();
			//cout << curr_op_size << endl;
			for ( int i = 0 ; i < curr_op_size ; i++ )
			{
				ops = curr_outputs[i]->get_name();
				bool op_val =  curr_outputs[i]->get();
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
		/////////*******************Get Direction**************////////////////////
		//analyse input_to_dut to get the input to track.
		/*std::list<std::string> live_signals;
		std::list<std::pair<int,std::string>> inst_stack;
		//std::string parent inst;
		input_to_dut.begin();
		int brk = 0;
		while(!input_to_dut.is_end())
		{
			std::string ip_name = input_to_dut.get_this();
			std::pair <bool,bool> val_pair = input_to_dut.fetch_value(ip_name);
			if(val_pair.second == 1)
			{
				live_signals.push_back(ip_name);
				//get the instances connected to it
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
				break;
			}
			input_to_dut.incr();
		}
		int prev_level=0;
		while(!inst_stack.empty())
		{
			std::pair<int,std::string> curr_inst_pair = inst_stack.front();
			std::string curr_inst = curr_inst_pair.second;
			int curr_level = curr_inst_pair.first;
			cout << prev_level << " " <<curr_level  << " " << brk<< endl;
			if(prev_level > curr_level || (prev_level == 4 && curr_level == 4))// backrtack...
			{
				inst_stack.pop_front();
				live_signals.pop_back();
			}
			else
			{
				//inst_stack.pop_front();
				//look at the output of the instance. if it is one push the output into live_signals and the cell instances into the instance stack
				//else leave it. also it the output of the current instance is the output of the circuit, then break
				std::vector<Wire*> op_wire;
				if(cell_type_and.find(curr_inst) != cell_type_and.end())
					op_wire = cell_type_and[curr_inst]->getOutput();
				if(cell_type_not.find(curr_inst) != cell_type_not.end())
					op_wire = cell_type_not[curr_inst]->getOutput();	
				if(cell_type_or.find(curr_inst) != cell_type_or.end())
					op_wire = cell_type_or[curr_inst]->getOutput();
				int op_wire_size = op_wire.size();
				for(int i=0;i<op_wire_size;i++)
				{
					if(op_wire[i]->get() == 1 && brk == 0)
					{
						std::string op_wire_name = op_wire[i]->get_name();
						live_signals.push_back(op_wire_name);
						std::pair<bool,std::list<std::string>> list_pair = cell_instances_input.get_list(op_wire_name);
						if(cell_instances_input.find_data(op_wire_name)==1)
						{
							std::list<std::string> ip_inst_list =list_pair.second;
							for (std::list<std::string>::iterator it=ip_inst_list.begin(); it != ip_inst_list.end(); ++it)
							{
	    						std::pair<int,std::string> pp (curr_level+1,*it);
    							inst_stack.push_front(pp);
							}
    					}
    					else
    					{
    						if(cell_instances_output.find_data(op_wire_name)==1)
    							brk = 1;
    					}
					}
				}
				prev_level = curr_level;
				if(brk == 1)
					break;
				
			}

		}*/
		cout << "******************" << endl;
		cout << "OUTPUT(S) =>  Values" << endl;
		output_from_dut.print_map();
		cout << "******************" << endl;
		cout << "INTERNAL SIGNALS =>  Values" << endl;
		signals_in_dut.print_map();
		cout << "******************" << endl;
		//cout << "PATHS =>" << endl;
		//for (std::list<std::string>::iterator it=live_signals.begin(); it != live_signals.end(); ++it)
	    //	cout << *it <<" ";
	    //cout << endl;

	}
	else
	{
		std::cout << "Unable to open file" << std::endl << std::endl;
	}
	return(0);    
}


