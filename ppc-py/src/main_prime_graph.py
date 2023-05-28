def read_graph(file_name):
    with open(file_name, 'r') as f:
        lines = f.readlines()
        graph = [[] for _ in range(len(lines)+1)]
        for line in lines:
            edge = line.strip().replace('[','').replace(']','').split(',')
            graph[int(edge[0])].append(int(edge[1]))
        return graph

def is_prime(num):
    if num < 2:
        return False
    for i in range(2, int(num**0.5)+1):
        if num % i == 0:
            return False
    return True

def dfs(graph, start, end, path=[]):
    path = path + [start]
    if start == end:
        return [path]
    paths = []
    for node in graph[start]:
        if node not in path and is_prime(node):
            new_paths = dfs(graph, node, end, path)
            for p in new_paths:
                paths.append(p)
    return paths

graph = read_graph('input.text')
prime_paths = dfs(graph, 1, 6)

# for path in prime_paths:
print(prime_paths)

