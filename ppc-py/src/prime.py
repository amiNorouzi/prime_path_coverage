from collections import deque

#method
def find_prime_paths(graph, start, end):
    paths = []
    queue = deque([(start, [start])])
    while queue:
        (vertex, path) = queue.popleft()
        for neighbor in graph[vertex] - set(path):
            if neighbor == end:
                paths.append(path + [neighbor])
            else:
                queue.append((neighbor, path + [neighbor]))
    prime_paths = []
    for path in paths:
        is_prime = True
        for i in range(len(path) - 2):
            if path[i+1] not in graph[path[i]] or path[i+1] in path[i+2:]:
                is_prime = False
                break
        if is_prime:
            prime_paths.append(path)
    return prime_paths


#test
graph = {0: {1, 4}, 1: {2, 5}, 2: {3}, 3: {1}, 4: {4, 6}, 5: {6}, 6: {}}

prime_paths = find_prime_paths(graph, 0, 6)
print(prime_paths)
