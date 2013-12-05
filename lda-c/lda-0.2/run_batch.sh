for i in 100 200 500 1000
do
    ./lda -N $i  ../../data/ml.movie.train results/ml.movie.model$i
done
