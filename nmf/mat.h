/*
Jason Lawrence
University of Virginia

mat.h

Interface for miscellaneous matrix operations.

Note: depends on external BLAS routines.  I recommend using Intel's
Math Kernel Library (MKL).
*/

#ifndef __MAT_H__
#define __MAT_H__

float ssdf(float *V, float *WH, float *B, int M, int N);
float ssdf(float *V, float *B, int M, int N,float *W, float *H, int K,float *WH);
float divf(float *V, float *WH, float *B, int M, int N);
float divf(float *V, float *B, int M, int N,float *W, float *H, int K,float *WH);

inline void mmultf(float *A, float *B, float *AB, int M, int N, int K)
{
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A, K, B, N, 0.0, AB, N);
}

inline float mminf(float *A, int MN)
{
  float m = A[0];
  for (int i=1; i<MN; i++)
    if (A[i]<m)
      m=A[i];
  return m;
}

inline float mmaxf(float *A, int MN)
{
  float m = A[0];
  for (int i=1; i<MN; i++)
    if (A[i]>m)
      m=A[i];
  return m;
}

inline void eldivf(float *A, float *B, int MN)
{
  float *pA = A; float *pB = B;
  for (int i=0; i<MN; i++, pA++, pB++)
    *pA = (*pA) / (*pB);
}

inline void eldiv2f(float *A, float *B, int MN)
{
  float *pA = A; float *pB = B;
  for (int i=0; i<MN; i++, pA++, pB++)
    *pB = (*pA) / (*pB);
}

inline void elmulf(float *V, float *B, int MN)
{
  float *pV = V; float *pB = B;
  for (int i=0; i<MN; i++, pV++, pB++)
    *pV = (*pV) * (*pB);
}

#endif
