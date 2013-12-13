#include <stdlib.h>
#include <stdio.h>

#include <mkl_cblas.h>

#include "rand.h"
#include "mat.h"
#include "nmf.h"

int main(int argc, char **argv)
{
  int M = 200;
  int N = 200;
  int K = 6;
  
  float *_W = (float *)malloc(sizeof(float)*M*10);
  float *_H = (float *)malloc(sizeof(float)*10*N);
  float *_V = (float *)malloc(sizeof(float)*M*N);

  init_rng();

  for (int j=0; j<M; j++)
    for (int i=0; i<K; i++)
      _W[j*K+i]=uniff();
  
  for (int j=0; j<K; j++)
    for (int i=0; i<N; i++)
      _H[j*N+i]=uniff();

  mmultf(_W,_H,_V,M,N,K);

  for (int i=0; i<M*N; i++)
    _V[i]+=uniff()*0.0;//5;

  float *WH = (float *)malloc(sizeof(float)*M*N);

  std::vector<double> ssds;

  FILE *fp = fopen("nmf_ssd.txt","wt");
  for (int k=1; k<=10; k++) {
    printf("factorig for k=%d:\n",k); fflush(stdout);
    nmfssdf(_V,
	    NULL,
	    M,
	    N,
	    _W,
	    _H,
	    k,
	    WH,
	    1000,
	    100000,
	    true,
	    true,
	    NULL,
	    NULL,
	    &ssds);
    fprintf(fp,"%d %0.5f\n",k,ssds.back());
    ssds.clear();
  }
  fclose(fp);
  
  return 0;
}
