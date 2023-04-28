class Graph {
  final adjacencyList = <int, List<int>>{};

  void addEdge(int u, int v) {
    if (adjacencyList[u] == null) {
      adjacencyList.addAll({u: []});
    }
    if (adjacencyList[v] == null) {
      adjacencyList.addAll({v: []});
    }
    adjacencyList[u]!.add(v);
    adjacencyList[v]!.add(u);
  }

  bool isPrimePath(List<int> path) {
    for (int i = 1; i < path.length; i++) {
      if (!adjacencyList[path[i - 1]]!.contains(path[i])) {
        return false;
      }
    }
    return true;
  }

  String getPrimePaths(int source, int destination) {
    List<List<int>> primePaths = [];

    bool dfs(List<int> path, int current) {
      if (current == destination) {
        if (isPrimePath(path)) {
          primePaths.add(List<int>.from(path));
        }
        return true;
      }

      bool found = false;
      for (int neighbor in adjacencyList[current]!) {
        if (!path.contains(neighbor)) {
          path.add(neighbor);
          if (dfs(path, neighbor)) {
            found = true;
          }
          path.removeLast();
        }
      }

      return found;
    }

    dfs([source], source);
    primePaths.sort((a, b) => a.length.compareTo(b.length));
    var strPrimePaths = '';
    for (final path in primePaths) {
      strPrimePaths += '${path.join(' -> ')}  Length: ${path.length - 1}\n';
    }

    return strPrimePaths;
  }

  @override
  String toString() {
    return adjacencyList.toString();
  }
}
