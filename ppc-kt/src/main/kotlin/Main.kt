import java.io.File

fun isPrimePath(path: List<Int>, graph: Map<Int, List<Int>>): Boolean {
    return if (path.size >= 2 && path[0] == path[path.size - 1]) {
        true
    } else reachHead(path, graph) && reachEnd(path, graph)
}

fun reachHead(path: List<Int>, graph: Map<Int, List<Int>>): Boolean {
    val formerNodes = graph.filterValues { it.contains(path[0]) }.keys
    for (n in formerNodes) {
        if (!path.contains(n) || n == path[path.size - 1]) {
            return false
        }
    }
    return true
}

fun reachEnd(path: List<Int>, graph: Map<Int, List<Int>>): Boolean {
    val laterNodes = graph[path[path.size - 1]]
    for (n in laterNodes!!) {
        if (!path.contains(n) || n == path[0]) {
            return false
        }
    }
    return true
}

fun extendable(path: List<Int>, graph: Map<Int, List<Int>>): Boolean {
    return !(isPrimePath(path, graph) || reachEnd(path, graph))
}

fun findSimplePath(graph: Map<Int, List<Int>>, exPaths: MutableList<List<Int>>, paths: MutableList<List<Int>>) {
    paths.addAll(exPaths.filter { isPrimePath(it, graph) })
    exPaths.retainAll { extendable(it, graph) }
    val newExPaths = mutableListOf<List<Int>>()
    for (p in exPaths) {
        for (nx in graph[p[p.size - 1]]!!) {
            if (!p.contains(nx) || nx == p[0]) {
                newExPaths.add(p + nx)
            }
        }
    }
    if (newExPaths.isNotEmpty()) {
        findSimplePath(graph, newExPaths, paths)
    }
}

fun findPrimePaths(graph: Map<Int, List<Int>>) {
    val exPaths = graph.keys.map { listOf(it) }.toMutableList()
    val simplePaths = mutableListOf<List<Int>>()
    findSimplePath(graph, exPaths, simplePaths)
    val primePaths = simplePaths.sortedWith(compareBy({ it.size }, { it[0] }))
    println(primePaths)
}

fun main() {
    val graph = mutableMapOf<Int, MutableList<Int>>()
    File("input.text").useLines { lines ->
        lines.forEach { line ->
            val lineNodes = line.split(",").map { it.toInt() }
            if (graph[lineNodes[0]] != null) {
                graph[lineNodes[0]]!!.add(lineNodes[1])
            } else {
                graph[lineNodes[0]] = mutableListOf(lineNodes[1])
            }
            if (graph[lineNodes[1]] == null) graph[lineNodes[1]] = mutableListOf()
        }
    }
    findPrimePaths(graph)
}
