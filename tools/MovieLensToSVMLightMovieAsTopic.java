import java.io.*;
import java.util.*;


public class MovieLensToSVMLightMovieAsTopic{
    public static void main(String argv[]){
        run(argv[0]);
    }

    public static void run(String file){
        HashMap <Integer, ArrayList<Node>> map = new HashMap <Integer, ArrayList<Node>> ();

        try{
            BufferedReader br = new BufferedReader(new FileReader(new File(file)));
            String line = null;
            int max_id = Integer.MIN_VALUE;
            while (br.ready()){
                line = br.readLine();
                String[] tokens = line.split("\t");
                int user_id = Integer.parseInt(tokens[0]);
                ArrayList<Node> vec = map.get(user_id);
                if (vec == null){
                    vec = new ArrayList<Node>();
                    map.put(user_id, vec);
                }
                Node n = new Node(Integer.parseInt(tokens[1]), Integer.parseInt(tokens[2]));
                vec.add(n);
                max_id = Math.max(max_id, user_id);
            }
            for (int i = 1; i <= max_id; i++){
                ArrayList<Node> vec = map.get(i);
                if (vec != null){
                    StringBuilder s = new StringBuilder();
                    for (Node n: vec){
                        s.append(n.toString()+" ");
                    }
                    System.out.println(s.toString().trim());
                }else{
                    System.out.println("");
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}