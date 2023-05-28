import java.util.*;

public class Primer {
    public static void main(String[] args) {
        HashMap<Integer, List<Integer>> _graph = new HashMap<>();
        _graph.put(1, List.of(2));
        _graph.put(2, List.of(3,4));
        _graph.put(3, List.of());
        _graph.put(4, Arrays.asList(5,6));
        _graph.put(5, List.of(6));
        _graph.put(6, List.of(7));
        _graph.put(7, Arrays.asList(8, 9));
        _graph.put(8, List.of(2));
        _graph.put(9, List.of(10));
        _graph.put(10, Arrays.asList(11, 12));
        _graph.put(11, List.of(13,7));
        _graph.put(12, List.of(7));
        _graph.put(13, List.of(14));
        _graph.put(14, List.of(15,16));
        _graph.put(15, List.of(7));
        _graph.put(16, List.of(7));
//        _graph.put(17, List.of(7));
//        graph.addEdge(1, 2);
//        graph.addEdge(2, 3);
//        graph.addEdge(2, 4);
//        graph.addEdge(4, 5);
//        graph.addEdge(4, 6);
//        graph.addEdge(6, 7);
//        graph.addEdge(7, 8);
//        graph.addEdge(7, 9);
//        graph.addEdge(9, 10);
//        graph.addEdge(10, 11);
//        graph.addEdge(11, 17);
//        graph.addEdge(11, 13);
//        graph.addEdge(12, 17);
//        graph.addEdge(13, 14);
//        graph.addEdge(14, 15);
//        graph.addEdge(14, 16);
//        graph.addEdge(16, 17);
//        graph.addEdge(17, 7);
        find_prime_paths(_graph);
    }

    public static boolean is_prime_path(List<Integer> path, HashMap<Integer, List<Integer>> graph) {
        if (path.size() > 1 && Objects.equals(path.get(0), path.get(path.size() - 1))) {
            return true;
        } else return reach_head(path, graph) && reach_end(path, graph);
    }

    public static boolean reach_head(List<Integer> path, HashMap<Integer, List<Integer>> graph) {
        List<Integer> former_nodes = new ArrayList<>();
        for (Integer n : graph.keySet()) {
            List<Integer> edges = graph.get(n);
            if (edges.contains(path.get(0))) {
                former_nodes.add(n);
            }
        }
        for (Integer n : former_nodes) {
            if (!path.contains(n) || Objects.equals(n, path.get(path.size() - 1))) {
                return false;
            }
        }
        return true;
    }

    public static boolean reach_end(List<Integer> path, HashMap<Integer, List<Integer>> graph) {
        List<Integer> later_nodes = graph.get(path.get(path.size() - 1));
        for (Integer n : later_nodes) {
            if (!path.contains(n) || Objects.equals(n, path.get(0))) {
                return false;
            }
        }
        return true;
    }

    public static boolean extendable(List<Integer> path, HashMap<Integer, List<Integer>> graph) {
        return !is_prime_path(path, graph) && !reach_end(path, graph);
    }

    public static void find_simple_path(HashMap<Integer, List<Integer>> graph, List<List<Integer>> ex_paths, List<List<Integer>> paths) {
        List<List<Integer>> filtered_ex_paths = new ArrayList<>();
        for (List<Integer> p : ex_paths) {
            if (is_prime_path(p, graph)) {
                paths.add(p);
            } else if (extendable(p, graph)) {
                filtered_ex_paths.add(p);
            }
        }

        List<List<Integer>> new_ex_paths = new ArrayList<>();
        for (List<Integer> p : filtered_ex_paths) {
            int last_node = p.get(p.size() - 1);
            for (Integer nx : graph.get(last_node)) {
                if (!p.contains(nx) || Objects.equals(nx, p.get(0))) {
                    List<Integer> extended_path = new ArrayList<>(p);
                    extended_path.add(nx);
                    new_ex_paths.add(extended_path);
                }
            }
        }
        if (new_ex_paths.size() > 0) {
            find_simple_path(graph, new_ex_paths, paths);
        }
    }

    public static void find_prime_paths(HashMap<Integer, List<Integer>> graph) {
        List<List<Integer>> ex_paths = new ArrayList<>();
        for (Integer n : graph.keySet()) {
            ex_paths.add(Collections.singletonList(n));
        }

        List<List<Integer>> simple_paths = new ArrayList<>();
        find_simple_path(graph, ex_paths, simple_paths);
        simple_paths.sort((a, b) -> a.size() != b.size() ? Integer.compare(a.size(), b.size()) : Integer.compare(a.get(0), b.get(0)));
        for (List<Integer> p : simple_paths) {
            System.out.println(Collections.singletonList(p)
                    .toString()
                    .replaceAll("\\[", "")
                    .replaceAll("]", "")
            );
        }
    }
}
