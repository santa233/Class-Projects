#ifndef GATE_HPP
#define GATE_HPP
#define TRUE 1
#define FALSE 0
#define PRECISE TRUE
#define CONSERVATIVE FALSE

#include <vector>
#include "wire.hpp"

/*
 * A class representing a single gate
 * NOTE!!: If you want the wire outputs to be updated automatically, the call
 * to propogate() should be made when wires are added, or when wires are
 * updated (which may require the Wire class to have a reference to the
 * gates to which it serves as an input)
 */
class Gate {
  protected:
    std::vector<Wire*> inputs;
    //std::vector<Wire*> tracked_inputs;
    std::vector<Wire*> outputs;
    //std::vector<Wire*> tracked_outputs;
    bool model;
  public:
    /*
     * Constructor for gate.
     */
    Gate();

    /*
     * Method to add input wire
     */
    void addInput(Wire* wi);

    /*
     * Method to add output wire
     */
    void addOutput(Wire* wi);

    /*
     * Method to get input wire
     */
    std::vector<Wire*> getInput();

    /*
     * Method to get output wire
     */
    std::vector<Wire*> getOutput();

    /*
     * Method to choose the model.
     */
    void setModel();

    void setModel(bool val);

    /*
     * Method to set the output wire from the state of the input wires.
     * Will set the output wire to 0 (false) or 1 (true).
     * Will print an error if there is not enough inputs set, and will set
     * output wire to 0.
     */
    virtual void propogate() =0;
};

/*
 * A class representing an AND gate.
 */
class AndGate : public Gate {
  public:
    AndGate();

    /*
     * Sets output to 1 iff all inputs are 1, else sets output to 0
     */
    void propogate();
};

/*
 * A class representing an OR gate
 */
class OrGate : public Gate {
  public:
    OrGate();

    /*
     * Sets output to 0 iff all inputs are 0, else sets output to 1
     */
    void propogate();
};

/*
 * A class representing an NOT gate
 */
class NotGate : public Gate {
  public:
    NotGate();

    /*
     * Sets output to 0 iff all inputs are 0, else sets output to 1
     */
    void propogate();
};


#endif
