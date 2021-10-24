class Node {
  State state;
  private int ID;
  private int parentID;
  private boolean visited;
  private int depth;
  Node(State state, int id, int parentID, boolean visited, int depth) {
    this.state = state;
    this.ID = id;
    this.parentID = parentID;
    this.visited = visited;
    this.depth = depth;
  }
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
  public void setVisited(boolean visited) {
    this.visited = visited;
  }
  public int getCost() {
    return this.state.getH();
  }
}
