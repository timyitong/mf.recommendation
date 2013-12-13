/*
Jason Lawrence
University of Virginia

nmf.h

Interface for weighted non-negative matrix factorization.

Note: depends on external BLAS routines.  I recommend using Intel's
Math Kernel Library (MKL).
*/

#ifndef __NMF_H__
#define __NMF_H__

#include <vector>

#include <mkl_cblas.h>

#define NMF_SSD_THRESH 0.001

float nmfssdf(float *V,                                              // input data matrix (MxN)
	      float *B,                                              // confidence/weighting matrix (MxN)
	      int M,                                                 // number of rows in V
	      int N,                                                 // number of columns in V
	      float *W,                                              // left-hand factor (MxK)
	      float *H,                                              // right-hand factor (KxN)
	      int K,                                                 // rank of factorization
	      float *WH,                                             // product of WH (MxN)
	      int min_iters=0,                                       // minimum number of iterations
	      int max_iters=0,                                       // maximum number of iterations
	      bool init_w=true,                                      // flag to initialize W to non-negative noise
	      bool init_h=true,                                      // flag to initialize H to non-negative noise
	      void (*cb)(int, float *, float *, int, int, int)=0,    // callback function for external visualization
	      std::vector<double> *t=0,                              // vector of elapsed time at each iteration
	      std::vector<double> *ssds=0);                          // vector of SSD error at each iteration

#endif
