#include "component.hpp"

#include <iostream>

using namespace std;
/*
 * Gate implementation
 */

Gate::Gate() {
 model = PRECISE;
}

void Gate::addInput(Wire* wi) {
  inputs.push_back(wi);
}

void Gate::addOutput(Wire* wi) {
  outputs.push_back(wi);
}

std::vector<Wire*> Gate::getInput(){
  return inputs;
}

std::vector<Wire*> Gate::getOutput(){
  return outputs;
}
void Gate::setModel() {
  bool model1 = !model;
  //cout << model <<" t" << endl;
  model = model1;
 // cout << model << endl;
}

void Gate::setModel(bool val) {
  model = val;
}
AndGate::AndGate() {
//  model = val;
}




void AndGate::propogate() 
{
  if (inputs.size() < 4) 
  {
    std::cout<<"Less than 4 inputs!" << std::endl;
  }
  else 
  {
    std::vector<Wire*> i;
    std::vector<Wire*> i_t;
    for (auto it = inputs.begin(); it != inputs.end(); ++it) 
    {
      std::string ip_name = (*it)->get_name();
      int ip_name_len = ip_name.length();
      if (ip_name[ip_name_len-1] == 't' && ip_name[ip_name_len-2] == '_') 
      {
        i_t.push_back(*it);
      }
      else 
      {
        i.push_back(*it);
      }
    }
    if (i.size() < 2) 
    {
      std::cout<<"Less than 2 i!" << std::endl;
    }
    else 
    {
      bool value = 1;
      for (auto itt = i.begin(); itt != i.end(); ++itt) 
      {
        //cout << (*itt)->get() << " ";
        if ((*itt)->get() == 0) 
        {
          //cout << "false";
          value = 0;
          break;
        }
      }
      //cout << endl;

      for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) 
      {
        std::string op_name = (*itt)->get_name();
        int op_name_len = op_name.length();
        if (op_name[op_name_len-1] != 't' && op_name[op_name_len-2] != '_') 
        {
          (*itt)->set(value);
        }
      }
    }
    if(model == CONSERVATIVE) 
    {
      //cout << "v have entered and " << endl;
      if (i_t.size() < 2) 
      {
        std::cout<<"Less than 2 i_t!" << std::endl;
      }
      else 
      {
        bool value = 0;
        for (auto itt = i_t.begin(); itt != i_t.end(); ++itt) 
        {
          if ((*itt)->get() == 1) 
          {
            value = 1;
            break;
          }
        }

        for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) 
        {
          std::string op_name = (*itt)->get_name();
          int op_name_len = op_name.length();
          if (op_name[op_name_len-1] == 't' && op_name[op_name_len-2] == '_') 
          {
            (*itt)->set(value);
          }
        }
      }
    }
    else
    {
      //add precise model
      if (i_t.size() != 2 && i.size() !=2) 
      {
        std::cout<<"Less than 2 i_t and i!" << std::endl;
      }
      else
      {
        bool A = i[0]->get();
        bool B = i[1]->get();
        bool A_t = i_t[0]->get();
        bool B_t = i_t[1]->get();
        bool O_t =  (A & B_t) | (B & A_t) | (A_t & B_t);

        for (auto itt = outputs.begin(); itt != outputs.end(); ++itt)
        {
          std::string op_name = (*itt)->get_name();
          int op_name_len = op_name.length();
          if (op_name[op_name_len-1] == 't' && op_name[op_name_len-2] == '_')  
          {
            (*itt)->set(O_t);
          }
        }
      }
    }
  }
}

/*
 * OR Gate Implementation
 */
OrGate::OrGate() {
//  model = val;
}

void OrGate::propogate() {
  if (inputs.size() < 4) 
  {
    std::cout<<"Less than 4 inputs!" << std::endl;
  }
  else 
  {
    std::vector<Wire*> i;
    std::vector<Wire*> i_t;
    for (auto it = inputs.begin(); it != inputs.end(); ++it) 
    {
      std::string ip_name = (*it)->get_name();
      int ip_name_len = ip_name.length();
      if (ip_name[ip_name_len-1] == 't' && ip_name[ip_name_len-2] == '_') 
      {
        i_t.push_back(*it);
      }
      else 
      {
        i.push_back(*it);
      }
    }
    if (i.size() < 2) 
    {
      std::cout<<"Less than 2 i!" << std::endl;
    }
    else 
    {
      bool value = 0;
      for (auto itt = i.begin(); itt != i.end(); ++itt)   
      {
        //cout << (*itt)->get() << " ";
        if ((*itt)->get() == 1) 
        {
          //out << "true";
          value = 1;
          break;
        }
      }
      //cout << endl;
      for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) 
      {
        std::string op_name = (*itt)->get_name();
        int op_name_len = op_name.length();
        if (op_name[op_name_len-1] != 't' && op_name[op_name_len-2] != '_') 
        {
          (*itt)->set(value);
        }
      }
    }
    if(model == CONSERVATIVE) 
    {
     // cout << "v have entered or " << endl;
      if (i_t.size() < 2) 
      {
        std::cout<<"Less than 2 i_t!" << std::endl;
      }
      else 
      {
        bool value = 0;
        for (auto itt = i_t.begin(); itt != i_t.end(); ++itt) 
        {
          if ((*itt)->get() == 1) 
          {
            //cout << "true";
            value = 1;
            break;
          }
        }

        for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) 
        {
          std::string op_name = (*itt)->get_name();
          int op_name_len = op_name.length();
          if (op_name[op_name_len-1] == 't' && op_name[op_name_len-2] == '_') 
          {
            (*itt)->set(value);
          }
        }
      }
    }
    else
    {
      //add precise model
      if (i_t.size() != 2 && i.size() !=2) 
      {
        std::cout<<"Less than 2 i_t and i!" << std::endl;
      }
      else
      {
        bool A = i[0]->get();
        bool B = i[1]->get();
        bool A_t = i_t[0]->get();
        bool B_t = i_t[1]->get();
        bool O_t =  ((~A) & B_t) | ((~B) & A_t) | (A_t & B_t);

        for (auto itt = outputs.begin(); itt != outputs.end(); ++itt)
        {
          std::string op_name = (*itt)->get_name();
          int op_name_len = op_name.length();
          if (op_name[op_name_len-1] == 't' && op_name[op_name_len-2] == '_')  
          {
            (*itt)->set(O_t);
          }
        }
      }
    }
  }
}


/* 
 * NOT Gate Implementation
 */
NotGate::NotGate() {
//  model = val;
}

void NotGate::propogate() {
  if (inputs.size() < 2) {
    std::cout<< "More or Less than 2 input!" << std::endl;
  }
  else {
    std::vector<Wire*> i;
    std::vector<Wire*> i_t;
    for (auto it = inputs.begin(); it != inputs.end(); ++it) {
      std::string ip_name = (*it)->get_name();
      int ip_name_len = ip_name.length();
      if (ip_name[ip_name_len-1] == 't' && ip_name[ip_name_len-2] == '_') {
        i_t.push_back(*it);
      }
      else {
        i.push_back(*it);
      }
    }
    if (i.size() != 1) {
      std::cout<<"Less than 1 i!" << std::endl;
    }
    else {
      bool value = 1;
      for (auto itt = i.begin(); itt != i.end(); ++itt) {
        //cout << (*itt)->get() << " ";
        if ((*itt)->get() == 1) {
          value = 0;
          break;
        }
      }
      //cout << endl;
      for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) {
        std::string op_name = (*itt)->get_name();
        int op_name_len = op_name.length();
        if (op_name[op_name_len-1] != 't' && op_name[op_name_len-2] != '_') {
          (*itt)->set(value);
        }
      }
    }
    if(model == CONSERVATIVE) 
    {
      //cout << "v have entered not" << endl;
      if (i_t.size() != 1) {
        std::cout<<"Less than 1 i_t!" << std::endl;
      }
      else {
        bool value = 0;
        for (auto itt = i_t.begin(); itt != i_t.end(); ++itt) {
          if ((*itt)->get() == 1) {
            value = 1;
            break;
          }
        }

        for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) {
          std::string op_name = (*itt)->get_name();
          int op_name_len = op_name.length();
          if (op_name[op_name_len-1] == 't' && op_name[op_name_len-2] == '_') {
            (*itt)->set(value);
          }
        }
      }
    }
    else
    {
      //add precise model
      if (i_t.size() != 1) {
        std::cout<<"Less than 1 i_t!" << std::endl;
      }
      else {
        bool value = 0;
        for (auto itt = i_t.begin(); itt != i_t.end(); ++itt) {
          if ((*itt)->get() == 1) {
            value = 1;
            break;
          }
        }

        for (auto itt = outputs.begin(); itt != outputs.end(); ++itt) {
          std::string op_name = (*itt)->get_name();
          int op_name_len = op_name.length();
          if (op_name[op_name_len-1] == 't' && op_name[op_name_len-2] == '_') {
            (*itt)->set(value);
          }
        }
      }
    }
  }
}



