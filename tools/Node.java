public class Node{
    int id;
    int rating;
    Node (int id, int rating){
        this.id = id;
        this.rating = rating;
    } 
    public String toString(){
        return id+":"+rating;
    }
}