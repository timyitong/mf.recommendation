/*
Jason Lawrence
University of Virginia

nmf.cc

Main implementation of weighted non-negative matrix factorization.

Note: depends on external BLAS routines.  I recommend using Intel's
Math Kernel Library (MKL).
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>

#include <mkl_cblas.h>

#include "rand.h"
#include "timer.h"
#include "mat.h"
#include "nmf.h"

long rng_idum;

void normcolsf(float *W, int M, int K, float *sums)
{
  bzero(sums, sizeof(float)*K); 
  float *pW = W;
  for (int m=0; m<M; m++)
    for (int k=0; k<K; k++)
      sums[k] += *pW++;

  pW = W;
  for (int m=0; m<M; m++)
    for (int k=0; k<K; k++)
      *pW++ /= sums[k];
}

void normrowsf(float *W, float *H, int M, int N, int K, float *sums)
{
  bzero(sums, sizeof(float)*K); 
  float *_H=H;
  for (int k=0; k<K; k++)
    for (int n=0; n<N; n++)
      sums[k] += *_H++;

  _H=H;
  for (int k=0; k<K; k++)
    for (int n=0; n<N; n++)
      *_H++ /= sums[k];

  float *_W=W;
  for (int m=0; m<M; m++)
    for (int k=0; k<K; k++)
      *_W++ *= sums[k];
}

float nmfssdf(float *V,
	      float *B,
	      int M,
	      int N,
	      float *W,
	      float *H,
	      int K,
	      float *WH,
	      int min_iters,
	      int max_iters,
	      bool init_w,
	      bool init_h,
	      void (*cb)(int, float *, float *, int, int, int),
	      std::vector<double> *t,
	      std::vector<double> *ssds)
{
  //Perform random initialization
  if (init_w) {
    float *pW = W;
    for (int i=0; i<M*K; i++)
      *pW++ = uniff() + EPS;
  }
  if (init_h) {
    float *pH = H;
    for (int i=0; i<N*K; i++)
      *pH++ = uniff() + EPS;
  }

  float *Vorg = new float[M*N];
  memcpy(Vorg,V,sizeof(float)*M*N);

  // Auxilary for W update
  float *VHt = new float[M*K];
  float *WHHt = new float[M*K];

  // Auxilary for H update
  float *WtV = new float[K*N];
  float *WtWH = new float[K*N];

  // Auxilary for normalization step
  float* sums = new float[K];

  float old_ssd = ssdf(V, B, M, N, W, H, K, WH);

  printf("NMF: initial SSD %.6e\n", old_ssd);

  if (t) t->push_back(0.0);
  if (ssds) ssds->push_back(old_ssd);

  // Fold weights into data matrix and current estimate
  if (B){
    elmulf(V,B,M*N);
    elmulf(WH,B,M*N);
  }

  double tel=0.0;
  Timer timer;
  timer.start();
  
  //Iterate
  for(int i=0; (max_iters==0 || i<max_iters); i++)
    {
      // Expectation phase (extimate mixing weights, W)

      // (V*H')
      cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans, M, K, N, 1.0, V, N, H, N, 0.0, VHt, K); 

      // (WH*H')
      cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans, M, K, N, 1.0, WH, N, H, N, 0.0, WHHt, K);

      // (V*H')./(WH*H')
      eldivf(VHt,WHHt,M*K);

      // W <- W.*(V*H')./(WH*H')
      elmulf(W,VHt,M*K);

      // Fix W at stationary point
      normcolsf(W,M,K,sums);

      // Minimization phase (esimate basis functions, H)
      
      // (W'*V)
      cblas_sgemm(CblasRowMajor, CblasTrans, CblasNoTrans, K, N, M, 1.0, W, K, V, N, 0.0, WtV, N);

      // (W'*WH)
      cblas_sgemm(CblasRowMajor, CblasTrans, CblasNoTrans, K, N, M, 1.0, W, K, WH, N, 0.0, WtWH, N);

      // (W'*V)./(W'*WH)
      eldivf(WtV,WtWH,K*N);

      // H <- H.*(W'*V)./(W'*WH)
      elmulf(H,WtV,K*N);

      // Compute current estimate
      cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, W, K, H, N, 0.0, WH, N);

      if (cb) cb(i,W,H,M,N,K);

      if ( i % 1000 == 0 )
	{
	  double secs = timer.stop(); tel+=secs;

	  float ssd = ssdf(Vorg, WH, B, M, N);

#ifdef VERBOSE
	  printf("NMF: %d SSD %.6e", i, ssd);

	  if (i > 0)
	    {
	      double secs_iter = secs / 1000.0;
	      printf("\t(secs per iter ~ %.10f)     ", secs_iter);
	    }
	  printf("\n");
	  fflush(stdout);
#endif

	  if (t) t->push_back(tel);
	  if (ssds) ssds->push_back(ssd);

	  if ( (i > min_iters) && (ssd > old_ssd) )
	    {
	      fprintf(stderr, "\n\tError increased!\n");
	      old_ssd = ssd;
	      break;
	    }

	  if ( (i > min_iters) && ((old_ssd-ssd) < NMF_SSD_THRESH) )
	    {
	      fprintf(stdout, "\n\tNMF converged.\n");
	      old_ssd = ssd;
	      break;
	    }

	  old_ssd = ssd;
	  
	  timer.start();
	}

      // Fold weights into estimate
      if (B)
	elmulf(WH,B,M*N);
    }

  printf("\n"); fflush(stdout);

  delete [] Vorg;

  delete [] VHt;
  delete [] WHHt;
  delete [] WtV;
  delete [] WtWH;
  delete [] sums;

  //W*H
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, W, K, H, N, 0.0, WH, N);

  return old_ssd;
}
