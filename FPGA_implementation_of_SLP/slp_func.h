#ifndef SLP_FUNC_H_
#define SLP_FUNC_H_

#define eta 0.015

const int op_nodes=10;
const int image_size=784;


using namespace std;

void slp_func(float (&weights_ARR_in)[10][784], double image[784], float (&weights_ARR_out)[10][784], int image_number, int outcome);//, int image_size, int op_nodes);

#endif

