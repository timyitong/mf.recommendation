/*
    feature.h
    a header file for feature matrix.
    $Id: feature.h,v 1.3 2004/11/01 06:49:06 dmochiha Exp $
*/
#ifndef LDA_FEATURE_H
#define LDA_FEATURE_H
#include <stdio.h>

typedef struct {
	int    len;
	int    *id;
        double *cnt;
} document;

extern document *feature_matrix(char *filename, int *maxid, int *maxfeat);
extern void free_feature_matrix(document *matrix);

#endif
