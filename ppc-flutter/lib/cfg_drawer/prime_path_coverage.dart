import 'dart:convert';
import 'dart:io';

import 'package:flow_graph/flow_graph.dart' show GraphNode;

import 'family_node.dart';

typedef GraphFamilyNode = GraphNode<FamilyNode>;

class Graph {
  final adjacencyList = <int, List<int>>{};

  Graph();

  Graph.from(GraphNode<FamilyNode> root) {
    _dfs(root, []);
  }

  Graph.fromTextFile(String path) {
    final file = File(path);
    final lines = file.readAsLinesSync();

    for (String line in lines) {
      final path = jsonDecode(line);
      addEdge(path[0], path[1]);
    }
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

  bool isPrimePath(List<int> path) =>
      (path.length > 1 && path[0] == path[path.length - 1]) ||
      (reachHead(path) && reachEnd(path));

  bool reachHead(List<int> path) {
    var formerNodes =
        adjacencyList.keys.where((n) => adjacencyList[n]!.contains(path[0]));
    for (int node in formerNodes) {
      if (!path.contains(node) || node == path[path.length - 1]) {
        return false;
      }
    }
    return true;
  }

  bool reachEnd(List<int> path) {
    var laterNodes = adjacencyList[path[path.length - 1]] ?? [];
    for (int node in laterNodes) {
      if (!path.contains(node) || node == path[0]) {
        return false;
      }
    }
    return true;
  }

  bool isExtendable(List<int> path) => !(isPrimePath(path) || reachEnd(path));

  void findSimplePaths(List<List<int>> exPaths, List<List<int>> paths) {
    final simplePaths = exPaths.where((p) => isPrimePath(p)).toList();
    paths.addAll(simplePaths);
    exPaths = exPaths.where((p) => isExtendable(p)).toList();
    var newExPaths = <List<int>>[];
    for (List<int> path in exPaths) {
      for (int node in adjacencyList[path.last]!) {
        if (!path.contains(node) || node == path[0]) {
          newExPaths.add([...path, node]);
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

  final pointersList = <int, GraphNode>{};
  final waitList = <List<int>>[];

  GraphNode<FamilyNode> draw() {
    final root = GraphNode<FamilyNode>(
      data: FamilyNode(name: 'Start'),
      isRoot: true,
    );
    final sortedKeys = adjacencyList.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    for (int i = 0; i < sortedKeys.length; i++) {
      int node = sortedKeys[i];
      var parents = findParent(node);
      for (var parent in parents) {
        if (parent == 'start' || int.parse(parent) < node) {
          if (parent == '3' && node == 1) print(node);
          addNode(root, parent, node, []);
        }
      }
    }

    for (var value in waitList) {
      var flag = true;
      for (int i in pointersList.keys) {
        if (pointersList[i]?.data.name == value[1].toString()) {
          pointersList[i]?.addNext(bildNode(value[1]));
          flag = false;
        }
      }
      if (flag) {
        pointersList[value[0]]?.addNext(bildNode(value[1]));
      }
      flag = true;
    }
    return root;
  }

  bildNode(node) => GraphNode<FamilyNode>(
        data: FamilyNode(
          name: node.toString(),
          multiParent: true,
          singleChild: false,
        ),
      );

  void addNode(
    GraphNode root,
    String parent,
    int node,
    List<GraphNode> visited,
  ) {
    if (parent == 'start') {
      final bn = bildNode(node);
      pointersList.addAll({node: bn});
      root.addNext(bn);
      return;
    }
    visited.add(root);

    for (final n in root.nextList) {
      if (parent == n.data!.name) {
        final bn = bildNode(node);
        pointersList.addAll({node: bn});
        n.addNext(bn);
        return;
      }

      if (!visited.contains(n)) {
        return addNode(n, parent, node, visited);
      }
    }
    waitList.add([int.parse(parent), node]);
  }

  List<String> findParent(int node) {
    final parents = <String>[];
    adjacencyList.forEach((par, children) {
      if (children.contains(node)) parents.add(par.toString());
    });

    if (parents.isEmpty) {
      parents.add('start');
    }
    return parents;
  }
}

void main() {
  final graph = Graph();
  graph.addEdge(1, 2);
  graph.addEdge(2, 3);
  graph.addEdge(2, 4);
  graph.addEdge(4, 5);
  graph.addEdge(4, 6);
  graph.addEdge(6, 7);
  graph.addEdge(7, 8);
  graph.addEdge(7, 9);
  graph.addEdge(9, 10);
  graph.addEdge(10, 11);
  graph.addEdge(11, 17);
  graph.addEdge(11, 13);
  graph.addEdge(12, 17);
  graph.addEdge(13, 14);
  graph.addEdge(14, 15);
  graph.addEdge(14, 16);
  graph.addEdge(16, 17);
  graph.addEdge(17, 7);

  print(graph.getPrimePathsString());
}
