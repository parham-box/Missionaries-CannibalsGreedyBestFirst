class Node {
  //state of the node
  State state;
  //id of the node in the array
  private int ID;
  //id of the parent of the node in the array
  private int parentID;
  //is the node expanded
  private boolean visited;
  // depth of the node
  private int depth;
  //constructor
  Node(State state, int id, int parentID, boolean visited, int depth) {
    this.state = state;
    this.ID = id;
    this.parentID = parentID;
    this.visited = visited;
    this.depth = depth;
  }
  //getters
  public boolean getVisited() {
    return this.visited;
  }
  public State getState() {
    return this.state;
  }
  public int getID() {
    return this.ID;
  }
  public int getParentID() {
    return this.parentID;
  }
  public int getDepth() {
    return this.depth;
  }
  public int getCost() {
    //f(n)=h(n)
    return this.state.getH();
  }

  //setters
  public void setVisited(boolean visited) {
    this.visited = visited;
  }
}
