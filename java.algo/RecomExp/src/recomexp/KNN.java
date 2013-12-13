/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package recomexp;

import java.util.*;

import org.ejml.data.DenseMatrix64F;
import org.ejml.ops.CommonOps;

/**
 *
 * @author timyitong
 */
public class KNN {
    DenseMatrix64F train;
    
    MatrixRow2Normalizer normalizer;
    DenseMatrix64F S;
    DenseMatrix64F X;
    DenseMatrix64F test;
    
    class Node implements Comparable<Node>{
        int index;
        double score;
        
        Node (int index, double score){
            this.index = index;
            this.score = score;
        }
        
        public int compareTo(Node n){
            if (this.score > n.score){
                return -1;
            }else if (this.score == n.score){
                return 0;
            }else{
                return 1;
            }
        }
    }
    
    public KNN(DenseMatrix64F train, DenseMatrix64F test){
        this.train = train;
        this.test = test;
    }
    
    public void train(){
        normalizer = new MatrixRow2Normalizer(train);
        normalizer.normalize();
        X = normalizer.normal;
        DenseMatrix64F Xt = X.copy();
        CommonOps.transpose(Xt);
        
        int n = X.getNumRows();
        S = new DenseMatrix64F(n, n);
        CommonOps.mult(X, Xt, S);
                        
    }
    
    public DenseMatrix64F test(int k){
        DenseMatrix64F SK = new DenseMatrix64F(S.getNumRows(), S.getNumCols());
        for (int i = 0; i < S.getNumRows(); i++){
            List<Node> nodes = new ArrayList<Node>();
            for (int j = 0; j < S.getNumCols(); j++){
                if (j != i)
                    nodes.add(new Node(j, S.get(i, j)));
            }
            
            Collections.sort(nodes);
            List<Node> topList = nodes.subList(0, k);
            
            double sum = 0;
            for (Node node: topList){
                sum += node.score;
            }
            if (sum != 0){
                for (Node node: topList){
                    SK.set(i, node.index, node.score/sum);
                }
            }
        }

        DenseMatrix64F res = new DenseMatrix64F(SK.getNumRows(), X.getNumCols());
        CommonOps.mult(SK, X, res);
        
        for (int i = 0; i < res.getNumRows(); i++){
            for (int j = 0; j < res.getNumCols(); j++){
                if (Math.abs(test.get(i, j)-0) < 0.000001){
                    res.set(i, j, 0);
                }
            }
        } 
        DenseMatrix64F predict = normalizer.denormalize(res);
        return predict;
    }
}
