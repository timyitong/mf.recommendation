/*
Jason Lawrence
University of Virginia

rand.h

Helper functions for random number generation.

Note: implements a random number generator adapted from Numerical
Recipes (c).
*/

#ifndef __RAND_H__
#define __RAND_H__

#include <stdlib.h>
#include <time.h>
#include <float.h>
#include <math.h>
#include <algorithm>

extern long rng_idum;

// Robust random number generator adapted from Numerical Recipes

#define IM1 2147483563
#define IM2 2147483399
#define AM (1.0/(double)IM1)
#define IMM1 (IM1-1)
#define IA1 40014
#define IA2 40692
#define IQ1 53668
#define IQ2 52774
#define IR1 12211
#define IR2 3791
#define NTAB 32
#define NDIV (1+IMM1/NTAB)
//#define EPS 1.2e-7
#define EPS DBL_EPSILON
#define RNMX (1.0-EPS)

#define RAND_EPSF FLT_EPSILON
#define RAND_EPSD DBL_EPSILON

// Long period (> 2 × 1018) random number generator of L’Ecuyer with
// Bays-Durham shuffle and added safeguards. Returns a uniform random
// deviate between 0.0 and 1.0 (exclusive of the endpoint
// values). Call with idum a negative integer to initialize;
// thereafter, do not alter idum between successive deviates in a
// sequence. RNMX should approximate the largest floating value that
// is less than 1.

inline double ran2(long *idum)
{
  int j;
  long k;
  static long idum2=123456789;
  static long iy=0;
  static long iv[NTAB];
  double temp;


  if (*idum <= 0)  // Initialize.
    {
      if (-(*idum) < 1) *idum=1;  //Be sure to prevent idum = 0.
      else *idum = -(*idum);
      idum2=(*idum);
      for (j=NTAB+7;j>=0;j--)    // Load the shuffle table (after 8 warm-ups).
	{
	  k=(*idum)/IQ1;
	  *idum=IA1*(*idum-k*IQ1)-k*IR1;
	  if (*idum < 0) *idum += IM1;
	  if (j < NTAB) iv[j] = *idum;
	}
      iy=iv[0];
    }

  k=(*idum)/IQ1;                        // Start here when not initializing.

  *idum=IA1*(*idum-k*IQ1)-k*IR1;        // Compute idum=(IA1*idum) %
					// IM1 without overflows by
					// Schrage’s method.
  if (*idum < 0) *idum += IM1;
  k=idum2/IQ2;
  idum2=IA2*(idum2-k*IQ2)-k*IR2;        // Compute idum2=(IA2*idum) % IM2
				        // likewise.
  if (idum2 < 0) idum2 += IM2;
  j=iy/NDIV;                            // Will be in the range 0..NTAB-1.
  iy=iv[j]-idum2;                       // Here idum is shuffled, idum and
				        // idum2 are combined to generate
				        // output.
  iv[j] = *idum;
  if (iy < 1) iy += IMM1;
  if ((temp=AM*(double)iy) > RNMX) return RNMX; // Because users don’t expect endpoint values.
  else return temp;
}

inline void init_rng ()
{
  rng_idum = -1 * (long)time(NULL);
  ran2(&rng_idum);
}

inline double unifd ()
{
  return (ran2(&rng_idum));
}

inline float uniff ()
{
  return ((float)ran2(&rng_idum));
}

inline double normalf (double sigma)
{
  double R = sqrt(2.0*sigma*sigma*log(1.0/std::max(RAND_EPSD,1.0-unifd())));
  return (R * cos(unifd()));
}

inline float normalf (float sigma)
{
  float R = sqrtf(2.0F*sigma*sigma*logf(1.0F/std::max(RAND_EPSF,1.0F-uniff())));
  return (R * cosf(uniff()));
}

#endif
