/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package recomexp;

import org.ejml.data.DenseMatrix64F;
import org.ejml.ops.SpecializedOps;

/**
 *
 * @author timyitong
 */
public class Utils {

    public static double rmse(DenseMatrix64F predict, DenseMatrix64F test){
        double rmse = 0;
        double num = 0;
        for (int i = 0; i < test.getNumRows(); i++){
            int c = 0;
            double err = 0;
            for (int j = 0; j < test.getNumCols(); j++){
                double t = test.get(i, j);
                if (t != 0){
                    double p = predict.get(i, j);
                    err += (t-p)*(t-p);
                    c += 1;
                    // System.out.println(p+":"+t);
                }
            }
            if (c != 0){
                rmse += Math.sqrt(err/c);
                num += 1;
            }
        }
        if (num != 0)
            rmse /= num;
        return rmse;
    }
    
    public static int[] sequence(int s, int e, int step){
        int[] res = new int[(e-s)/step + 1];
        int t = s;
        for (int i = 0; i < res.length; i ++){
            res[i] = t;
            t += step;
        }
        return res;
    }
    
    public static void printMatrixRow(DenseMatrix64F matrix, int row, int begin, int end){
        for (int j = begin; j < end; j++){
            System.out.print(matrix.get(row, j)+" ");
        }
        System.out.println();
    }
}
