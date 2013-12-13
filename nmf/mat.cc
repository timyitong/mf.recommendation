/*
Jason Lawrence
University of Virginia

mat.cc

Implementation of miscellaneous matrix operations.

Note: depends on external BLAS routines.  I recommend using Intel's
Math Kernel Library (MKL).
*/

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <math.h>
#include <algorithm>

using namespace std;

#include <mkl_cblas.h>

float ssdf(float *V, float *WH, float *B, int M, int N)
{
  float sum = 0.0;
  float *pC = B; float *pA = V; float *pB = WH;
  for(int i=0; i<M*N; i++)
    {
      float diff = (pC ? *pC++ : 1.0) * (*pA++ - *pB++);
      sum += diff*diff;
    }
  return (sum/2.0);
}

float ssdf(float *V,float *B,int M,int N,float *W,float *H,int K,float *WH)
{
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, W, K, H, N, 0.0, WH, N);
  float sum = 0.0;
  float *pC = B; float *pA = V; float *pB = WH;
  for(int i=0; i<M*N; i++)
    {
      float diff = *pA++ - *pB++;
      if (pC)
	sum += *pC++ * (diff * diff);
      else
	sum += diff*diff;
    }
  return sum;
}

float divf(float *V, float *WH, float *B, int M, int N)
{
  float sum = 0.0;
  float *pC = B; float *pA = V; float *pB = WH;
  for(int i=0; i<M*N; i++)
    {
      if (pC)
	{
	  if (pC[i] > 0.0)
	    sum += pC[i] * (pA[i] * log( pA[i] / pB[i] ) - pA[i] + pB[i]);
	}
      else
	sum += (pA[i] * log( pA[i] / pB[i] ) - pA[i] + pB[i]);
    }
  return sum;
}

float divf(float *V, float *B, int M, int N, float *W, float *H, int K, float *WH)
{
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, W, K, H, N, 0.0, WH, N);
  float sum = 0.0;
  float *pC = B; float *pA = V; float *pB = WH;
  for(int i=0; i<M*N; i++)
    {
      if (pC)
	{
	  if (pC[i] > 0.0)
	    sum += pC[i] * (pA[i] * log( pA[i] / pB[i] ) - pA[i] + pB[i]);
	}
      else
	sum += (pA[i] * log( pA[i] / pB[i] ) - pA[i] + pB[i]);
    }
  return sum;
}
