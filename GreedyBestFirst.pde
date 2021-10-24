ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Node> visitedNodes = new ArrayList<Node>();
ArrayList<State> states = new ArrayList<State>();
int goalIndex = 0;
State initalState = new State(4, 4, "L");
State goalState = new State(0, 0, "R");
ArrayList<Integer> status = new ArrayList<Integer>();

void setup() {
  size(350, 700); //size of the window
  background(255);
  frameRate(30);

  //add root
  states.add(initalState);
  nodes.add(new Node(initalState, 0, -1, false, 0));
  status.add(0);
  int size = 0;
  while (true) {
    boolean flag = false;
    Node cur = nodes.get(0);

    for (int j = 0; j < visitedNodes.size(); j++) {
      if (cur.getState().isEqual(visitedNodes.get(j).getState())) {
        //parent1 = i;
        flag = true;
        break;
      }
    }
    println("--------");
    print("Current state: ");
    nodes.get(0).getState().printState();
    if (nodes.get(0).getState().isEqual(goalState)) {
      goalIndex = 0;
      println("GOAL STATE");
      nodes.get(0).setVisited(true);
      visitedNodes.add(nodes.get(0));
      nodes.remove(0);
      break;
    }
    //if valid
    if (nodes.get(0).getState().isValid()) {

      //if not visited
      if (!flag) {

        State[] nextStates = nodes.get(0).getState().nextStates();
        Node parNode = nodes.get(0);
        for (int j = 0; j < nextStates.length; j++) {
          //visit the node
          nodes.add(new Node(nextStates[j], ++size, parNode.getID(), false, parNode.getDepth()+1));
        }
      } else {
        println("Visited Before");
      }
    } else {
      println("Not a valid state");
    }
    nodes.get(0).setVisited(true);
    visitedNodes.add(nodes.get(0));
    nodes.remove(0);
    nodes = bubbleSort(nodes);
    println("--------");
  }
  //Visualizing the graph on GUI

  //Graph Legend:
  //LIGHT BLUE: Root node
  //RED: Not a valid node
  //BLUE: Previously visited node
  //BLACK: Node with children
  //GRAY: A node on the answer path
  //GREEN: Goal node


  int n = visitedNodes.size();
  for (int i = 0; i < n-1; i++)
    for (int j = 0; j < n-i-1; j++)
      if (visitedNodes.get(j).getID() > visitedNodes.get(j+1).getID())
      {
        // swap arr[j+1] and arr[j]
        Node temp = visitedNodes.get(j);
        visitedNodes.set(j, visitedNodes.get(j+1));
        visitedNodes.set(j+1, temp);
      }



  int v = 1;
  int y = 0;
  int[] parentNodeNumber = new int[visitedNodes.size()];
  parentNodeNumber[0] = -1;
  for (int x = 1; x < visitedNodes.size(); x++) {
    boolean flag = false;
    State cur = visitedNodes.get(x).getState();

    for (int i = 0; i < x; i++) {
      if (cur.isEqual(visitedNodes.get(i).getState())) {
        flag = true;
      }
    }
    if (visitedNodes.get(x).getState().isValid()) {
      if (!flag) {

        status.add(0);
      } else {
        status.add(2);
      }
    } else {
      status.add(-1);
    }

    for (int k = 0; k < x; k++) {
      if (visitedNodes.get(x).getState().getParent().isEqual(visitedNodes.get(k).getState())) {
        parentNodeNumber[x] = k;
        break;
      }
    }
  }
  fill(0);
  ArrayList<Integer> rowIndex = new ArrayList<Integer>();
  for (int i = 0; i < visitedNodes.size(); i++) {
    //nodes.get(i).printState();

    if (i!=0) {
      if (visitedNodes.get(i).getDepth() == visitedNodes.get(i-1).getDepth()) {
        y++;
      } else {
        v++;
        y =0;
        rowIndex.add(i);
      }
      int parentIndex = parentNodeNumber[i];
      int li = 0;
      for (int x = 1; x < rowIndex.size(); x++) {
        if (parentIndex < rowIndex.get(x)) {
          li = parentIndex - rowIndex.get(x -1);
          break;
        }
      }

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

      if (i == visitedNodes.size()-1) {
        stroke(color(0, 150, 0));
        fill(color(0, 150, 0));
      } else if (path.contains(i)) {
        fill(color(100, 100, 100));
        stroke(color(0, 150, 0));
      } else if (status.get(i) == 2) {
        fill(color(0, 0, 256));
      } else if (status.get(i) == -1) {
        fill(color(256, 0, 0));
      } else {
        fill(0);
      }

      line(30+(li*50)+25, 40+((v-1)*50) + 5, 30+(y*50) + 25, 30+(v*50)-20);
      textSize(9);

      text("A* score: "+visitedNodes.get(i).getCost(), 30+(y*50), 15+(v*50));

      textSize(14);

      text(visitedNodes.get(i).getState().stateString(), 30+(y*50), 30+(v*50));
      textSize(9);

      int a = visitedNodes.get(i).getState().getH() == -1 ? 0  :visitedNodes.get(i).getState().getH();
      text("h score: "+a, 30+(y*50), 45+(v*50));
    } else {
      fill(color(0, 150, 200));
      textSize(9);

      text("A* score: "+visitedNodes.get(i).getCost(), 30, 15+(v*50));
      textSize(14);

      text(visitedNodes.get(i).getState().stateString(), 30, 30+(v*50));
      textSize(9);
      int a = visitedNodes.get(i).getState().getH() == -1 ? 0  :visitedNodes.get(i).getState().getH();
      text("h score: "+a, 30, 45+(v*50));
    }
  }
  int total = visitedNodes.size();
  fill(0);
  textSize(14);
  text("Visited Nodes: "+total, width - 120, height - 20);
}


ArrayList<Node> bubbleSort(ArrayList<Node> arr)
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
