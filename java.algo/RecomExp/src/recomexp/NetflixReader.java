/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package recomexp;
import java.io.*;
import java.util.*;
import org.ejml.data.DenseMatrix64F;
/**
 *
 * @author timyitong
 */
public class NetflixReader {
    private int row = 93713;
    private int col = 3561;
//    private int row = 1300;
//    private int col = 954;
    
    String path;
    DenseMatrix64F matrix = new DenseMatrix64F(row, col);
    boolean loaded = false;
    
    public NetflixReader(String path){
        this.path = path;
    }
    
    public DenseMatrix64F getData(){
        if (!loaded){
            load();
        }
        
        return matrix;
    }
    
    private void load(){
        try{
            BufferedReader br = new BufferedReader(new FileReader(new File(this.path)));
            while (br.ready()){
                String line = br.readLine();
                String[] tokens = line.split(" ");
                int uid = Integer.parseInt(tokens[0]);
                int mid = Integer.parseInt(tokens[1]);
                double score = Double.parseDouble(tokens[3]);
                
                // Set score to matrix
                int i = Dictionary.row().getID(uid);
                int j = Dictionary.col().getID(mid);
                if (i < row && j < col)
                    matrix.set(i, j, score);
            }
            loaded = true;
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
