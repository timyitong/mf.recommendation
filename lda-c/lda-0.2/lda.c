/*
    lda.c
    Latent Dirichlet Allocation, main driver.
    (c) 2004 Daichi Mochihashi, All Rights Reserved.
    $Id: lda.c,v 1.12 2013/01/13 14:23:27 daichi Exp $
    
*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "lda.h"
#include "learn.h"
#include "writer.h"
#include "feature.h"
#include "dmatrix.h"
#include "util.h"

int
main (int argc, char *argv[])
{
	document *data;
	double *alpha;
	double **beta;
	FILE *ap, *bp;		// for alpha, beta
	char c;
	int nlex, dlenmax;
	int nclass     = CLASS_DEFAULT;		// default in lda.h
	int emmax      = EMMAX_DEFAULT;		// default in lda.h
	int demmax     = DEMMAX_DEFAULT;	// default in lda.h
	double epsilon = EPSILON_DEFAULT;	// default in lda.h

	while ((c = getopt(argc, argv, "N:I:D:E:h")) != -1)
	{
		switch (c) {
			case 'N': nclass  = atoi(optarg); break;
			case 'I': emmax   = atoi(optarg); break;
			case 'D': demmax  = atoi(optarg); break;
			case 'E': epsilon = atof(optarg); break;
			case 'h': usage (); break;
			default : usage (); break;
		}
	}
	if (!(argc - optind == 2))
		usage ();

	/* open data */
	if ((data = feature_matrix(argv[optind], &nlex, &dlenmax)) == NULL) {
		fprintf(stderr, "lda:: cannot open training data.\n");
		exit(1);
	}
	/* allocate parameters */
	if ((alpha = (double *)calloc(nclass, sizeof(double))) == NULL) {
		fprintf(stderr, "lda:: cannot allocate alpha.\n");
		exit(1);
	}
	if ((beta = dmatrix(nlex, nclass)) == NULL) {
		fprintf(stderr, "lda:: cannot allocate beta.\n");
		exit(1);
	}
	/* open model outputs */
	if (((ap = fopen(strconcat(argv[optind + 1], ".alpha"), "w")) == NULL)
	 || ((bp = fopen(strconcat(argv[optind + 1], ".beta"), "w"))  == NULL))
	{
		fprintf(stderr, "lda:: cannot open model outputs.\n");
		exit(1);
	}

	lda_learn (data, alpha, beta, nclass, nlex, dlenmax,
		   emmax, demmax, epsilon);
	lda_write (ap, bp, alpha, beta, nclass, nlex);

	free_feature_matrix(data);
	free_dmatrix(beta, nlex);
	free(alpha);
	
	fclose(ap);
	fclose(bp);

	exit(0);
}

void
usage ()
{
	printf(LDA_COPYRIGHT);
	printf("usage: %s -N classes [-I emmax] [-D demmax] [-E epsilon] train model\n",
	       "lda");
	exit(0);
}

