import 'package:flow_graph/flow_graph.dart';

import 'family_node.dart';

typedef GraphFamilyNode = GraphNode<FamilyNode>;

class Graph {
  final adjacencyList = <int, List<int>>{};

  Graph();

  Graph.from(GraphNode<FamilyNode> root) {
    _dfs(root, []);
  }

  void _dfs(GraphFamilyNode root, List<GraphFamilyNode> visited) {
    visited.add(root);

    for (dynamic node in root.nextList) {
      addEdge(int.parse(root.data!.name), int.parse(node.data!.name));
      if (!visited.contains(node)) {
        _dfs(node, visited);
      }
    }
  }

  void addEdge(int source, int destination) {
    if (adjacencyList[source] == null) {
      adjacencyList.addAll({source: []});
    }
    if (adjacencyList[destination] == null) {
      adjacencyList.addAll({destination: []});
    }
    adjacencyList[source]!.add(destination);
  }

  bool isPrimePath(List<int> path) {
    if (path.length > 1 && path[0] == path[path.length - 1]) {
      return true;
    } else if (reachHead(path) && reachEnd(path)) {
      return true;
    } else {
      return false;
    }
  }

  bool reachHead(List<int> path) {
    var formerNodes =
        adjacencyList.keys.where((n) => adjacencyList[n]!.contains(path[0]));
    for (var n in formerNodes) {
      if (!path.contains(n) || n == path[path.length - 1]) {
        return false;
      }
    }
    return true;
  }

  bool reachEnd(List<int> path) {
    var laterNodes = adjacencyList[path[path.length - 1]] ?? [];
    for (var n in laterNodes) {
      if (!path.contains(n) || n == path[0]) {
        return false;
      }
    }
    return true;
  }

  bool isExtendable(List<int> path) => !(isPrimePath(path) || reachEnd(path));

  void findSimplePaths(List<List<int>> exPaths, List<List<int>> paths) {
    var simplePaths = exPaths.where((p) => isPrimePath(p)).toList();
    paths.addAll(simplePaths);
    exPaths = exPaths.where((p) => isExtendable(p)).toList();
    var newExPaths = <List<int>>[];
    for (var p in exPaths) {
      for (var nx in adjacencyList[p.last]!) {
        if (!p.contains(nx) || nx == p[0]) {
          newExPaths.add([...p, nx]);
        }
      }
    }
    if (newExPaths.isNotEmpty) {
      findSimplePaths(newExPaths, paths);
    }
  }

  List<List<int>> findPrimePaths() {
    final exPaths = adjacencyList.keys.map((n) => [n]).toList();
    final primePaths = <List<int>>[];
    findSimplePaths(exPaths, primePaths);
    return primePaths;
  }

  String getPrimePathsString() {
    final primePaths = findPrimePaths();
    var strPrimePaths = '';
    for (final path in primePaths) {
      strPrimePaths += '${path.join(' ↣ ')}  Length: ${path.length - 1}\n';
    }

    return strPrimePaths;
  }


  @override
  String toString() {
    return adjacencyList.toString();
  }
}

void main() {
  final graph = Graph();
  graph.addEdge(0, 1);
  graph.addEdge(0, 4);
  graph.addEdge(1, 2);
  graph.addEdge(1, 5);
  graph.addEdge(2, 3);
  graph.addEdge(3, 1);
  graph.addEdge(4, 4);
  graph.addEdge(4, 6);
  graph.addEdge(5, 6);

  print(graph.getPrimePathsString());
}
