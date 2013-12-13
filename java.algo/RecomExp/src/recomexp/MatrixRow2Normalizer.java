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
public class MatrixRow2Normalizer {
    DenseMatrix64F origin;
    DenseMatrix64F normal;
    double[] means;
    double[] vars;
    
    public MatrixRow2Normalizer(DenseMatrix64F data){
        origin = data;
    }
    
    public void normalize(){
        means = new double[origin.getNumRows()];
        vars = new double[origin.getNumRows()];
        normal = new DenseMatrix64F(origin.getNumRows(), origin.getNumCols());
        
        for (int i = 0; i < origin.getNumRows(); i++){
            int c = 0;
            for (int j = 0; j < origin.getNumCols(); j++){
                if (origin.get(i, j) != 0){
                    means[i] += origin.get(i, j);
                    c += 1;
                }
            }
            if (c != 0){
                means[i] /= c;
            }
        }
        
        for (int i = 0; i < origin.getNumRows(); i++){
            for (int j = 0; j < origin.getNumCols(); j++){
                double val = origin.get(i, j);
                double newVal = val-means[i];
                normal.set(i, j, newVal);
                vars[i] += newVal*newVal;
            }
        }
        
        for (int i = 0; i < origin.getNumRows(); i++){
            for (int j = 0; j < origin.getNumCols(); j++){
                double val = normal.get(i, j);
                double newVal = val/Math.sqrt(vars[i]);
                normal.set(i, j, newVal);
            }
        }    
    }
    
    public DenseMatrix64F denormalize(DenseMatrix64F predict){
        DenseMatrix64F res = new DenseMatrix64F(predict.getNumRows(), predict.getNumCols());
        for (int i = 0; i < res.getNumRows(); i++){
            for (int j = 0; j < res.getNumCols(); j++){
                res.set(i, j, predict.get(i, j)*Math.sqrt(vars[i])+means[i]);
            }
        }
        
        return res;
    }
    
}
