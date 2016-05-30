#include <math.h>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstring>
#include <vector>

#include "slp_func.h"

//#define PATH_PREFIX "C:\\Users\\danny\\xilinx_projs\\baller2\\"

const int train_dataset_size = 60000;
const char filename1[] = "train-images.idx3-ubyte";
const char filename3[] = "t10k-images.idx3-ubyte";
const char filename2[] = "train-labels.idx1-ubyte";
const char filename4[] = "t10k-labels.idx1-ubyte";

using namespace std;

int ReverseInt (int i)
{
 
    unsigned char ch1, ch2, ch3, ch4;
    ch1 = i & 255;
    ch2 = (i >> 8) & 255;
    ch3 = (i >> 16) & 255;
    ch4 = (i >> 24) & 255;
    return((int) ch1 << 24) + ((int)ch2 << 16) + ((int)ch3 << 8) + ch4;
}

vector< vector<double> > read_Mnist(const char filename1[])

{
    vector< vector<double> > vec;
    FILE * fp;
    fp = fopen (filename1, "r");
    int ch = 0;
    while(1)
    {
        unsigned char revword[4];
        for (int i = 0 ; i < 4 ; i++)
        {
            unsigned char  c = (unsigned char)fgetc(fp);
            if( feof(fp) )
            {
                ch = 1;
                break ;
            }
            else
                revword[i] = c;
        }
        if(ch == 1)
            break;
        int magic_number = ((int) revword[0] << 24) + ((int)revword[1] << 16) + ((int)revword[2] << 8) + revword[3];
        cout << magic_number << endl;
        for (int i = 0 ; i < 4 ; i++)
        {
            unsigned char  c = (unsigned char)fgetc(fp);
            if( feof(fp) )
            {
                ch = 1;
                break ;
            }
            else
                revword[i] = c;
        }
        if(ch == 1)
            break;
        int number_of_images = ((int) revword[0] << 24) + ((int)revword[1] << 16) + ((int)revword[2] << 8) + revword[3];
        cout << number_of_images << endl;
        for (int i = 0 ; i < 4 ; i++)
        {
            unsigned char  c = (unsigned char)fgetc(fp);
            if( feof(fp) )
            {
                ch = 1;
                break ;
            }
            else
                revword[i] = c;
        }
        if(ch == 1)
            break;
        int n_rows = ((int) revword[0] << 24) + ((int)revword[1] << 16) + ((int)revword[2] << 8) + revword[3];
        cout << n_rows << endl;
        for (int i = 0 ; i < 4 ; i++)
        {
            unsigned char  c = (unsigned char)fgetc(fp);
            if( feof(fp) )
            {
                ch = 1;
                break ;
            }
            else
                revword[i] = c;
        }
        if(ch == 1)
            break;
        int n_cols = ((int) revword[0] << 24) + ((int)revword[1] << 16) + ((int)revword[2] << 8) + revword[3];
        cout << n_cols << endl;
        for(int i = 0; i < number_of_images; ++i)
        {
            vector<double> tp;
            for(int r = 0; r < n_rows; ++r)
            {
                for(int c = 0; c < n_cols; ++c)
                {
                    unsigned char  temp = (unsigned char)fgetc(fp);
                    tp.push_back(((double)temp)/255);
                }
                if(ch == 1)
                    break;
            }
            if(ch == 1)
                break;
            vec.push_back(tp);
        }
        if(ch == 1)
            break;
    }
    return vec;
}


vector<int> read_Mnist_label(const char filename1[])

{
    vector<int> vec;
    FILE * fp;
    fp = fopen (filename1, "r");
    int ch = 0;
    while(1)
    {
    	unsigned char revword[4];
    	for (int i = 0 ; i < 4 ; i++)
    	{
    		unsigned char  c = (unsigned char)fgetc(fp);
    		if( feof(fp) )
    		{
    			ch = 1;
       		 	break ;
    		}
       		else
    			revword[i] = c;
    	}
    	if(ch == 1)
    		break;
    	int magic_number = ((int) revword[0] << 24) + ((int)revword[1] << 16) + ((int)revword[2] << 8) + revword[3];
    	for (int i = 0 ; i < 4 ; i++)
    	{
    		unsigned char  c = (unsigned char)fgetc(fp);
    		if( feof(fp) )
    		{
    			ch = 1;
       		 	break ;
    		}
       		else
    			revword[i] = c;
    	}
    	if(ch == 1)
    		break;
    	int number_of_images = ((int) revword[0] << 24) + ((int)revword[1] << 16) + ((int)revword[2] << 8) + revword[3];
    	//cout << number_of_images << endl;
    	for(int i = 0; i < number_of_images; ++i)
        {
            unsigned char  temp = (unsigned char)fgetc(fp);
            if( feof(fp) )
			{
				ch = 1;
		 		break ;
			}
            vec.push_back((int)temp);
        }
        if(ch == 1)
    		break;
    }
    return vec;
}

int main()
{
	vector<vector<double> > vec=read_Mnist(filename1);
	cout << vec.size()<< endl;
    vector<int> vec1=read_Mnist_label(filename2);
    double input_image[image_size];
    float weights_ARR_in[op_nodes][image_size];
    float weights_ARR_out[op_nodes][image_size];
    for(int img_no = 0; img_no <op_nodes ; img_no ++)
    {
        for(int pixel_no = 0 ; pixel_no < image_size ; pixel_no++)
        {
            float p = (float) (rand() %101);
            float ARR = ((p/100)-0.5);
            weights_ARR_in[img_no][pixel_no] = ARR;
            weights_ARR_out[img_no][pixel_no] = ARR;
        }
    }
    //int ck = 0;
    for (int img_no = 0; img_no <60000 ; img_no ++)
    {
    	cout<< "Image " << img_no << endl;
    	int outcome = vec1[img_no];
    	double current_img[image_size];
    	for(int i = 0; i < image_size ; i++)
    	{
    		current_img[i] = vec[img_no][i];
    	}
    	slp_func(weights_ARR_in, current_img, weights_ARR_out, img_no, outcome);
    	for(int i = 0 ; i < op_nodes ; i++)
    	{
    		for(int j = 0 ; j< image_size ; j++)
    		{
    			//if(weights_ARR_in[i][j] == weights_ARR_out[i][j] || weights_ARR_out[i][j] == 0)
    			//{
    				//cout << "ERROR!!!!!!!!!!!!!!!!!!!!!" << endl;
    			//	ck = 1;
    			//	break;
    			//}
    			weights_ARR_in[i][j] = weights_ARR_out[i][j];
    		}
    		//if(ck == 1)
    		//	break;
    	}
    	//if(ck == 1)
    	//    break;
    }
}
