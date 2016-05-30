#include "make_graph.hpp"
#include <iostream>
#include <stdlib.h>
#include <string>
#include <fstream>
#include <map>
#include <list>
#include <sstream>
#include <vector>
#include <stdlib.h>     
#include <time.h>
#define PRECISE TRUE
#define CONSERVATIVE FALSE


using namespace std;

int main()
{
    std::string line;
    std::ifstream text1 ("simple.txt");
    std::ifstream text2 ("ip.txt");
	std::string wordone("\0"),word;
	std::string a;
	std::string cell_inst_name,cell_type_name,wire_name;
	netlist_graph graph;
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
		      								std::string ip_op_arr_t = ip_op_arr;
		      								ip_op_arr_t.push_back('_');
		      								ip_op_arr_t.push_back('t');
		   									//cout << signal_type << " " << word <<  endl;
		      								if(signal_type == "input" && word != "input")
		      								{
		      									//***********************************
			      								graph.insert_data_input_to_dut(ip_op_arr,FALSE);
			      								graph.insert_data_input_to_dut(ip_op_arr_t,FALSE);
			      							}
			      							if(signal_type == "output" && word != "output")
		      								{
		      									//***********************************
			      								graph.insert_data_output_from_dut(ip_op_arr,FALSE);
			      								graph.insert_data_output_from_dut(ip_op_arr_t,FALSE);
			      							}			
		      							}
		      						}
		      						if(nummax_done == FALSE && nummin_done == FALSE)
		      						{
										std::string ip_op_arr = word;
										std::string ip_op_arr_t = ip_op_arr;
		      							ip_op_arr_t.push_back('_');
		      							ip_op_arr_t.push_back('t');
										if(signal_type == "input" && word != "input")
		      							{
		      								//****************************************
			      							graph.insert_data_input_to_dut(ip_op_arr,FALSE);
			      							graph.insert_data_input_to_dut(ip_op_arr_t,FALSE);
			      						}
			      						if(signal_type == "output" && word != "output")
		      							{
		      								//****************************************
			      							graph.insert_data_output_from_dut(ip_op_arr,FALSE);
			      							graph.insert_data_output_from_dut(ip_op_arr_t,FALSE);
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
		      					graph.insert_into_GATE(cell_type_name,cell_inst_name);
		      				}
		      				if(word_count>2)
		      				{
		//						wires
		      					wire_name=word;
		      					std::string wire_name_t = word;
		      					wire_name_t.push_back('_');
		      					wire_name_t.push_back('t');
		      					//std::string wire_name_t =  
		//						fill the cell wires map
								graph.cell_wires_insert_data(cell_inst_name,wire_name);
								graph.cell_wires_insert_data(cell_inst_name,wire_name_t);
								graph.ip_op_indicate(cell_type_name,word_count);

		      					if(graph.get_bool_input() == TRUE)
		      					{
		      						graph.cell_instances_input_insert_data(wire_name,cell_inst_name);
		      						graph.cell_instances_input_insert_data(wire_name_t,cell_inst_name);
									graph.signals_in_dut_insert_data(wire_name,0);
									graph.signals_in_dut_insert_data(wire_name_t,0);
		      						graph.insert_input_Wire_GATE(cell_type_name,cell_inst_name,wire_name);
		      						graph.insert_input_Wire_GATE(cell_type_name,cell_inst_name,wire_name_t);

		      					}
		//      					OUTPUT
		      					if( graph.get_bool_output() == TRUE)
		      					{
		      						graph.cell_instances_output_insert_data(wire_name,cell_inst_name);
		      						graph.cell_instances_output_insert_data(wire_name_t,cell_inst_name);
									graph.signals_in_dut_insert_data(wire_name,0);
									graph.signals_in_dut_insert_data(wire_name_t,0);
									graph.insert_output_Wire_GATE(cell_type_name,cell_inst_name,wire_name);
									graph.insert_output_Wire_GATE(cell_type_name,cell_inst_name,wire_name_t);
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
			graph.set_input_to_dut_begin();
			while(text2.good())
			{
				getline(text2,line);
				wordone.clear();
				int size=line.size();
				int word_count=0;
				linecount++;
				if(line!="\0")
				{
					graph.incr_and_set_ip_to_dut_val(line,0);
				}
			}
		}
		text2.close();
		std::list<std::string> p;
		char qwerty;
		cout << "*********************************************************************************"<<endl;
		cout << "graph built enter any key to continue" << endl;
		cout << "*********************************************************************************"<<endl;
		cin >> qwerty;
		cout << endl;

		//conservative
		//cout <<"*********************************************************************************"<< endl;
	    //cout <<"******************************CONSERVATIVE***************************************"<< endl;
	    //cout <<"*********************************************************************************"<< endl;
		graph.set_model_ALL_GATES(CONSERVATIVE);
		graph.build_graph(p);
		graph.print_datas();
		cout << "*********************************************************************************"<<endl;
		cout << "graph populated with the input enter any key to continue" << endl;
		cout << "*********************************************************************************"<<endl;
		cin >> qwerty;
		cout << endl;		
		std::vector<std::list<std::string>> list_live_signals_c = graph.propagate_thru_graph();
		int consv_size = list_live_signals_c.size();
		std::list<std::string> list1 = list_live_signals_c[0];
		// testing pt=recise model
		cout << "PATHS =>" << endl;
		for (std::list<std::string>::iterator it=list1.begin(); it != list1.end(); ++it)
	    	cout << *it <<" ";
	    cout << endl;
	    std::list<std::string> list2 = list_live_signals_c[1];
		cout << "PATHS =>" << endl;
		for (std::list<std::string>::iterator it=list2.begin(); it != list2.end(); ++it)
	    	cout << *it <<" ";
	    cout << endl;
	    list1 = list_live_signals_c[2];
		cout << "PATHS =>" << endl;
		for (std::list<std::string>::iterator it=list1.begin(); it != list1.end(); ++it)
	    	cout << *it <<" ";
	    cout << endl;
	    list2 = list_live_signals_c[3];
		cout << "PATHS =>" << endl;
		for (std::list<std::string>::iterator it=list2.begin(); it != list2.end(); ++it)
	    	cout << *it <<" ";
	    cout << endl;
	    cout << "********************************************************************************"<< endl;
		cout << "vector of paths from inputs to outputs(consv) displayed enter any key to continue" << endl;
		cout << "*********************************************************************************"<<endl;
		cin >> qwerty;
		cout << endl;
	    //precise
	    //cout <<"*********************************************************************************"<< endl;
	    //cout <<"*********************************PRECISE*****************************************"<< endl;
	    //cout <<"*********************************************************************************"<< endl;
	    //graph.clear_map_signals_bool();
	    graph.set_model_ALL_GATES(PRECISE);
		graph.build_graph(p);
		std::vector<std::list<std::string>> list_live_signals_p = graph.propagate_thru_graph();
		std::map<std::list<std::string>,int> freq_map_live_signals_p;
		//graph.print_datas();
		srand(time(NULL));
		for(int i =0; i< 100; i++)
		{
			int ip_nos=graph.get_number_of_inputs();
			//graph.set_input_to_dut_begin();
			graph.clear_map_signals_bool();
			graph.set_input_to_dut_begin();
			for(int j=0;j<ip_nos;j++)
			{
				std::string num;
				if(j%2 == 0)
					num = (char)(rand()%2 + 48);
					//num = '1';
				else
				{
					if(j == 1 || j == 5)
						num = '1';
					else
						num = '0';
				}
				//cout << rand()%200 << " ";
				graph.incr_and_set_ip_to_dut_val(num,0);
			}
			//cout << endl;
			graph.set_model_ALL_GATES(PRECISE);
			graph.build_graph(p);
			//graph.print_datas();
			list_live_signals_p = graph.propagate_thru_graph();
			int list_live_signals_size = list_live_signals_p.size();
			for(int j = 0 ; j<list_live_signals_size; j++)
			{
				if(freq_map_live_signals_p.find(list_live_signals_p[j]) == freq_map_live_signals_p.end())
				{
					freq_map_live_signals_p.insert(std::pair<std::list<std::string> , int> (list_live_signals_p[j],1));
				}
				else
				{
					freq_map_live_signals_p[list_live_signals_p[j]]++;
				}
			}
			//graph.print_datas();
		}
		cout << endl;
	    cout << "********************************************************************************"<< endl;
		cout << "Frequency map updated/populated enter any key to continue" << endl;
		cout << "*********************************************************************************"<<endl;
		cin >> qwerty;
		cout << endl;
		//cout << "frequencies" << endl;
		std::list<std::string> trojans;
		//cout << "hi" << endl;
		int ii=0;
		for (int i = 0; i < consv_size; i++)
		{
			int check_if_present = 0;
			int to_accept_or_not = 1;
		//	cout << "*************new***************"<< endl;
		//	cout << "hi" << i << endl;
			std::list<std::string> curr_live_signals = list_live_signals_c[i];
			std::list<std::string> curr_live_signals_temp = list_live_signals_c[i];
			for(std::map<std::list<std::string>,int>::iterator it = freq_map_live_signals_p.begin(); it!=freq_map_live_signals_p.end(); ++it)
			{
				//(*it).first;
				std::list<std::string> lists = (*it).first;
				if (lists == curr_live_signals)
					check_if_present = 1;
				//for(std::list<std::string>::iterator itt = lists.begin(); itt != lists.end(); ++itt)
				//	cout << (*itt) << " " ;
				//cout << " => " << (*it).second << endl;
			}
			//cout << check_if_present << endl;
			if(check_if_present == 1)
			{
			//	cout << "bye" << endl;
				int freq = freq_map_live_signals_p[curr_live_signals];
				if(freq < 10)
					to_accept_or_not = 0;
			}
			if(check_if_present == 0 || to_accept_or_not == 0)
			{
				//pass entire inst list int crapg propgate one by one with conservative model.
				//graph.set_model_ALL_GATES(PRECISE);
				//cout << "bye" << endl;
				curr_live_signals.reverse();
				std::list<string> with_consv_model;
				int check_trj = 0;
				for(std::list<std::string>::iterator itt = curr_live_signals.begin(); itt != curr_live_signals.end(); ++itt)
				{
					graph.set_model_ALL_GATES(PRECISE);
					//cout << *itt << endl;
					std::pair<bool,std::list<std::string>> pair1=graph.cell_instances_output_get_dat(*itt);
					if(pair1.first == 1)
					{
						ii++;
						for(std::list<std::string>::iterator ittt = (pair1.second).begin(); ittt != (pair1.second).end(); ++ittt)
						{
							//cout << (*ittt) << " " ;
							with_consv_model.push_back(*ittt);
						}
					}
					//cout << endl;
					//for(std::list<std::string>::iterator ittt = with_consv_model.begin(); ittt != with_consv_model.end(); ++ittt)
					//	cout << (*ittt) << " " ;
					//cout << endl << "************" << endl;
					std::string signal = (*itt);
					graph.set_input_to_dut_begin();
					graph.clear_map_signals_bool();
					std::ifstream text3 ("ip.txt");
					if(text3.is_open())
					{
						graph.set_input_to_dut_begin();
						while(text3.good())
						{
							getline(text3,line);
							wordone.clear();
							int size=line.size();
							int word_count=0;
							linecount++;
							if(line!="\0")
							{
								graph.incr_and_set_ip_to_dut_val(line,0);
							}
						}
					}
					text3.close();
					//cout << "hi6"<<endl;
					graph.build_graph(with_consv_model);
					//graph.print_datas();
					//cout << "hi6"<<endl;
					std::vector<std::list<std::string>> list_live_signals_m = graph.propagate_thru_graph();
					//cout<< list_live_signals_m.size();
					int check_if_present_mixed = 0;

					for(int j = 0; j < list_live_signals_m.size(); j++ )
					{
						std::list<std::string> ppppp =  list_live_signals_m[j];
						//for (std::list<std::string>:: iterator rats = ppppp.begin(); rats!=ppppp.end(); ++rats)
						//{
						//	cout << (*rats) << " " ; 
						//}
						//cout << endl;
						//for (std::list<std::string>:: iterator rats = curr_live_signals_temp.begin(); rats!=curr_live_signals_temp.end(); ++rats)
						//{
						//	cout << (*rats) << " " ; 
						//}
						//cout << endl;
						//cout << "its workking " << ii << endl;
						if(curr_live_signals_temp == list_live_signals_m[j] && check_trj == 0)
						{
							//cout<< "hi" << endl;
							check_if_present_mixed = 1;
							check_trj = 1;
							trojans.push_back(*itt);
						}
					}
				}
				//	cout << (*itt) << " " ;
			}
		}
		trojans.unique();
		cout << "trojans >>>>>>>>>>>>>> " << endl;
		for(std::list<std::string>::iterator itt = trojans.begin(); itt != trojans.end(); ++itt)
		{
			//out << (*itt) << " " ;
			std::pair<bool,std::list<std::string>> pair1=graph.cell_instances_output_get_dat(*itt);
			if(pair1.first == 1)
			{
				for(std::list<std::string>::iterator ittt = (pair1.second).begin(); ittt != (pair1.second).end(); ++ittt)
				{
					cout << (*ittt) << " " ;
				}
			}
		}
		cout << endl;
		cout << endl;
	    cout << "********************************************************************************"<< endl;
		cout << "Trojans displayed. Demo is over " << endl << "THANK YOU:)"<< endl;
		cout << "*********************************************************************************"<<endl;
		//cin >> qwerty;
		cout << endl;

	}
	else
	{
		std::cout << "Unable to open file" << std::endl << std::endl;
	}
	return(0);    
}