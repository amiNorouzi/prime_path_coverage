
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;

class Graph {
    private final List<Vertex> vertices;
    private final List<Edge> edges;

    public Graph() {
        vertices = new ArrayList<>();
        edges = new ArrayList<>();
    }

    public void addVertex(Vertex v) {
        vertices.add(v);
    }

    public void addEdge(Edge e) {
        edges.add(e);
    }

    public List<Vertex> getVertices() {
        return vertices;
    }

    public List<Edge> getEdges() {
        return edges;
    }
}


class Edge {
    private final Vertex v1;
    private final Vertex v2;
    private final int weight;

    public Edge(Vertex v1, Vertex v2, int weight) {
        this.v1 = v1;
        this.v2 = v2;
        this.weight = weight;
    }

    public Vertex getV1() {
        return v1;
    }

    public Vertex getV2() {
        return v2;
    }

    public int getWeight() {
        return weight;
    }
}


class Vertex {
    private final String name;

    public Vertex(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}


public class Main {
    public static void main(String[] args) {
        Graph graph = new Graph();

        try (BufferedReader br = new BufferedReader(new FileReader("input.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(" ");
                String name1 = parts[0];
                String name2 = parts[1];
                int weight = 1;

                Vertex v1 = new Vertex(name1);
                Vertex v2 = new Vertex(name2);

                if (!graph.getVertices().contains(v1)) {
                    graph.addVertex(v1);
                }

                if (!graph.getVertices().contains(v2)) {
                    graph.addVertex(v2);
                }

                graph.addEdge(new Edge(v1, v2, weight));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<Edge> edges = findMinimumSpanningTree(graph);
        for (Edge e : edges) {
            System.out.println(e.getV1().getName() + " - " + e.getV2().getName());
        }
    }

    private static List<Edge> findMinimumSpanningTree(Graph graph) {
        List<Edge> result = new ArrayList<>();
        PriorityQueue<Edge> pq = new PriorityQueue<>((e1, e2) -> e1.getWeight() - e2.getWeight());
        Vertex start = graph.getVertices().get(0);

        pq.addAll(graph.getEdges());

        while (!pq.isEmpty() && result.size() < graph.getVertices().size() - 1) {
            Edge e = pq.remove();
            Vertex v1 = e.getV1();
            Vertex v2 = e.getV2();

            if (!v1.equals(v2)) {
                if (v1.equals(start)) {
                    start = v2;
                }

                result.add(e);
                mergeVertices(graph, v1, v2);
            }
        }

        return result;
    }

    private static void mergeVertices(Graph graph, Vertex v1, Vertex v2) {
        for (int i = 0; i < graph.getEdges().size(); i++) {
            Edge e = graph.getEdges().get(i);
            Vertex ev1 = e.getV1();
            Vertex ev2 = e.getV2();

            if ((ev1.equals(v1) && ev2.equals(v2)) || (ev1.equals(v2) && ev2.equals(v1))) {
                graph.getEdges().remove(e);
                i--;
            } else if (ev1.equals(v2)) {
                e = new Edge(v1, ev2, e.getWeight());
                graph.getEdges().set(i, e);
            } else if (ev2.equals(v2)) {
                e = new Edge(ev1, v1, e.getWeight());
                graph.getEdges().set(i, e);
            }
        }

        graph.getVertices().remove(v2);
    }
}
