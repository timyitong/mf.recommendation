/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package recomexp;
import java.util.*;
/**
 *
 * @author timyitong
 */
public class Dictionary {
    private static Dictionary rowDictionary  = new Dictionary();
    private static Dictionary columnDictionary = new Dictionary();
    private HashMap<Integer, Integer> map = new HashMap<Integer, Integer>();
    private int index = 0;
    
    private Dictionary(){}
    
    public int getID(int key){
        Integer val = map.get(key);
        if (val == null){
            val = new Integer(index++);
            map.put(key, val);
        }
        return val.intValue();
    }
    
    public static Dictionary row(){
        return rowDictionary;
    }
    
    public static Dictionary col(){
        return columnDictionary;
    }
}
