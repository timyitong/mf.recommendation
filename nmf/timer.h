/*
Jason Lawrence
University of Virginia

timer.h

Simple class for computing time intervals.
*/

#ifndef _TIMER_H_
#define _TIMER_H_

#include <sys/timeb.h>

class Timer {
  struct timeb tb_before;
 public:
  Timer();
  ~Timer();
  void start(void);
  double stop(void);
};

inline
Timer::Timer ()
{
}

inline
Timer::~Timer ()
{
}

inline void
Timer::start ()
{
  ftime((struct timeb *)&tb_before);
}

inline double
Timer::stop ()
{
  struct timeb tb_after;

  // Get timestamp
  ftime((struct timeb *)&tb_after);

  // Compute elapsed time
  long secs_elapsed = tb_after.time - tb_before.time;
  long msecs_elapsed = tb_after.millitm - tb_before.millitm;
  if (msecs_elapsed < 0)
    {
      secs_elapsed--;
      msecs_elapsed+=1000;
    }

  double ret = ( ((double)secs_elapsed) * 1000.0 + ((double)msecs_elapsed) ) / 1000.0;

  return ret;
}

#endif
