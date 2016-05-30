#include "slp_func.h"
#include "math.h"
#include <stdlib.h>

void slp_func(float (&weights_ARR_in)[10][784], double image[784], float (&weights_ARR_out)[10][784], int image_number, int outcome)//, int image_size, int op_nodes)
{
    float y_k = 0;
    float sum_D = 0;
    float acti_arr[op_nodes];
    /////////// GET ACTIVATION.
    label00:for(int op_node_no =0 ; op_node_no < op_nodes; op_node_no++)
    {
        float pp1=0;
        float pp2=0;float pp3=0;float pp4=0;
        labe01_1:for(int i = 0; i < image_size/4; i++)
        	pp1 = pp1 + weights_ARR_in[op_node_no][i]*image[i];
        label01_2:for(int i = image_size/4; i < image_size/2; i++)
        	pp2 = pp2 + weights_ARR_in[op_node_no][i]*image[i];
        label01_3:for(int i = image_size/2; i < image_size*3/4; i++)
           	pp3 = pp3 + weights_ARR_in[op_node_no][i]*image[i];
        label01_4:for(int i = image_size*3/4; i < image_size; i++)
           	pp4 = pp4 + weights_ARR_in[op_node_no][i]*image[i];
        /////////// LINEAR ACTIVATION FUNCTION g(A) = A.
        acti_arr[op_node_no] = pp1 + pp2 + pp3 + pp4;
    }
    labe0:for(int pixel_no_1 = 0 ; pixel_no_1 < image_size ; pixel_no_1++)
    {
        sum_D = 0;
        label1:for(int op_node_no =0 ; op_node_no < op_nodes; op_node_no++)
        {
            if(outcome == op_node_no)
                y_k = 1;
            else
                y_k = 0;
            /////////// CALC FIRST TERM IN GRADIENT.
            sum_D = (y_k - acti_arr[op_node_no]);
            float del_E_wjk = 0;
            del_E_wjk = eta * sum_D * image[pixel_no_1];
            weights_ARR_out[op_node_no][pixel_no_1] = weights_ARR_in[op_node_no][pixel_no_1] + del_E_wjk;
        }
    }
}
