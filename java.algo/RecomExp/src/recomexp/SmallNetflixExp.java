/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package recomexp;

import org.ejml.data.DenseMatrix64F;

/**
 *
 * @author timyitong
 */
public class SmallNetflixExp {
    String trainFile;
    String testFile;
    int[] ks;
    
    public SmallNetflixExp(String train, String test, int[] ks){
        this.trainFile = train;
        this.testFile = test;
        this.ks = ks;
    }
    
    public void run(){
        DenseMatrix64F train = new NetflixReader(trainFile).getData();
        DenseMatrix64F test = new NetflixReader(testFile).getData();
        KNN trainer = new KNN(train, test);
        trainer.train();
        for (int i = 0; i < ks.length; i++){
            DenseMatrix64F predict = trainer.test(ks[i]);
            double rmse = Utils.rmse(predict, test);
            System.out.println(rmse);
        }
    }
}
