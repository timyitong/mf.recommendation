for i in 1 90 179 267 356 445 534 622 711 800
do
    ./lda -N $i  ../../data/ml.movie.train results/ml.movie.model$i
done
