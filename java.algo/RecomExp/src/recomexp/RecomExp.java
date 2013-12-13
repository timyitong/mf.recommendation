/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package recomexp;

/**
 *
 * @author timyitong
 */
public class RecomExp {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String netflixTrain = "smallnetflix_mm.train.txt";
        String netflixTest = "smallnetflix_mm.validate.txt";
        int[] k = Utils.sequence(10, 200, 10);
        SmallNetflixExp netflixExp = new SmallNetflixExp(netflixTrain, netflixTest, k);
        netflixExp.run();
    }
}
