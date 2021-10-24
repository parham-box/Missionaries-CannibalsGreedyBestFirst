//Declaring variables
//unvisited nodesvariable
ArrayList<Node> nodes = new ArrayList<Node>();
//visited nodes variable
ArrayList<Node> visitedNodes = new ArrayList<Node>();
//the initial state of the game
State initalState = new State(3, 3, "L");
//the initial state of the game
State goalState = new State(0, 0, "R");
ArrayList<Integer> status = new ArrayList<Integer>();

void setup() {
  size(350, 700); //size of the window
  background(255);//setting white background
  //A* Algorith:
  //add root
  nodes.add(new Node(initalState, 0, -1, false, 0));
  /*Add status of root.
   
   0 is nodes with children,
   1 is goal node,
   -1 is not valid nodes,
   2 is already visited nodes
   */
  status.add(0);
  //counter
  int size = 0;
  //loop until the algorithm finds the answer
  while (true) {
    //to check if node is already visited
    //if flag is true node has been visited before
    boolean flag = false;
    Node cur = nodes.get(0);
    for (int j = 0; j < visitedNodes.size(); j++) {
      if (cur.getState().isEqual(visitedNodes.get(j).getState())) {
        flag = true;
        break;
      }
    }
    //printing current node
    println("--------");
    print("Current state: ");
    nodes.get(0).getState().printState();
    //if current node is goal
    if (nodes.get(0).getState().isEqual(goalState)) {
      println("GOAL STATE");
      //node is visited
      nodes.get(0).setVisited(true);
      //add it visited nodes
      visitedNodes.add(nodes.get(0));
      //remove it from unvisited nodes
      nodes.remove(0);
      break;
    }
    //if current node is valid
    if (nodes.get(0).getState().isValid()) {

      //if current node is not visited
      if (!flag) {

        State[] nextStates = nodes.get(0).getState().nextStates();
        Node parNode = nodes.get(0);
        for (int j = 0; j < nextStates.length; j++) {
          //visit the node
          //add children to unvisited nodes
          nodes.add(new Node(nextStates[j], ++size, parNode.getID(), false, parNode.getDepth()+1));
        }
      } else {
        //aready visited node
        println("Visited Before");
      }
    } else {
      //not a valid state
      println("Not a valid state");
    }
    //node is visited
    nodes.get(0).setVisited(true);
    //add it visited nodes
    visitedNodes.add(nodes.get(0));
    //remove it from unvisited nodes
    nodes.remove(0);
    //sort the nodes base on f(n)
    nodes = sortNode(nodes);
    println("--------");
  }
  //Visualizing the graph on GUI

  //Graph Legend:
  //LIGHT BLUE: Root node
  //RED: Not a valid node
  //BLUE: Previously visited node
  //BLACK: Node with children
  //GREEN: Path node

  //sort the visited nodes base on their ID
  int n = visitedNodes.size();
  for (int i = 0; i < n-1; i++)
    for (int j = 0; j < n-i-1; j++)
      if (visitedNodes.get(j).getID() > visitedNodes.get(j+1).getID())
      {
        Node temp = visitedNodes.get(j);
        visitedNodes.set(j, visitedNodes.get(j+1));
        visitedNodes.set(j+1, temp);
      }

  //helpers to show the search tree coordinates
  int v = 1;
  int y = 0;
  //an array with id of each nodes parent in the array
  int[] parentNodeNumber = new int[visitedNodes.size()];
  //root node does not have a parent
  parentNodeNumber[0] = -1;
  //for every visited node
  for (int x = 1; x < visitedNodes.size(); x++) {
    boolean flag = false;
    State cur = visitedNodes.get(x).getState();
    //add state of each node
    for (int i = 0; i < x; i++) {
      if (cur.isEqual(visitedNodes.get(i).getState())) {
        flag = true;
      }
    }
    //go through all the visited nodes and assign the status
    if (visitedNodes.get(x).getState().isValid()) {
      if (!flag) {

        status.add(0);
      } else {
        status.add(2);
      }
    } else {
      status.add(-1);
    }
    //to find parent index
    for (int k = 0; k < x; k++) {
      if (visitedNodes.get(x).getState().getParent().isEqual(visitedNodes.get(k).getState())) {
        parentNodeNumber[x] = k;
        //break so that it select the first of the same node
        break;
      }
    }
  }
  //color of forground is black
  fill(0);
  ArrayList<Integer> rowIndex = new ArrayList<Integer>();
  for (int i = 0; i < visitedNodes.size(); i++) {
    //if not inital state
    if (i!=0) {
      //find if depth is different
      if (visitedNodes.get(i).getDepth() == visitedNodes.get(i-1).getDepth()) {
        //if items are in the same row
        //move items in same row to right everytime
        y++;
      } else {
        //if item is in a new row
        //go down
        v++;
        //start from the left
        y =0;
        rowIndex.add(i);
      }
      int parentIndex = parentNodeNumber[i];
      //find what number parents is in, in the previous row by subtracting its index from last the last item in previous row
      int li = 0;
      for (int x = 1; x < rowIndex.size(); x++) {
        if (parentIndex < rowIndex.get(x)) {
          li = parentIndex - rowIndex.get(x -1);
          break;
        }
      }
      //find path from inital state to goal state
      ArrayList<Integer> path = new ArrayList<Integer>();
      path.add(visitedNodes.size()-1);
      int parent = parentNodeNumber[visitedNodes.size()-1];
      path.add(parent);

      while (true) {
        if (parent != -1) {
          parent = parentNodeNumber[parent];
          path.add(parent);
        } else {
          break;
        }
      }

      stroke(0);
      //assign different color to each state
      if (i == visitedNodes.size()-1) {
        stroke(color(0, 150, 0));
        fill(color(0, 150, 0));
      } else if (path.contains(i)) {
        fill(color(0, 150, 0));
        stroke(color(0, 150, 0));
      } else if (status.get(i) == 2) {
        fill(color(0, 0, 256));
      } else if (status.get(i) == -1) {
        fill(color(256, 0, 0));
      } else {
        fill(0);
      }

      line(30+(li*50)+25, 30+((v-1)*50) + 13, 30+(y*50) + 25, 30+(v*50)-15);
      //show f(n)

      textSize(14);

      text(visitedNodes.get(i).getState().stateString(), 30+(y*50), 30+(v*50));
      textSize(9);

      int a = visitedNodes.get(i).getState().getH() == -1 ? 0  :visitedNodes.get(i).getState().getH();
      text("f(n)=h(n)="+a, 30+(y*50), 40+(v*50));
    } else {
      fill(color(0, 150, 200));
      textSize(14);
      text(visitedNodes.get(i).getState().stateString(), 30, 30+(v*50));
      textSize(9);
      int a = visitedNodes.get(i).getState().getH() == -1 ? 0  :visitedNodes.get(i).getState().getH();
      text("f(n)=h(n)="+a, 30, 40+(v*50));
    }
  }
  int total = visitedNodes.size();
  fill(0);
  textSize(14);
  text("Visited Nodes: "+total, width - 120, height - 20);
}


ArrayList<Node> sortNode(ArrayList<Node> arr)
{
  int n = arr.size();
  for (int i = 0; i < n-1; i++)
    for (int j = 0; j < n-i-1; j++)
      if (arr.get(j).getCost() > arr.get(j+1).getCost())
      {
        // swap arr[j+1] and arr[j]
        Node temp = arr.get(j);
        arr.set(j, arr.get(j+1));
        arr.set(j+1, temp);
      }
  return arr;
}
