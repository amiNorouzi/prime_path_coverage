class Graph:

    def __init__(self):
        self.edges = {}

    def read_from_file(self, src):
        with open(src, 'r', encoding='utf-8') as graphFile:
            while True:
                s = graphFile.readline().strip().split()
                if len(s) < 2:
                    break

                if s[0] not in self.edges:
                    self.edges[s[0]] = []

                if s[1] not in self.edges:
                    self.edges[s[1]] = []

                self.edges[s[0]].append(s[1])

    def is_prime_path(self, path):
        if len(path) > 1 and path[0] == path[-1]:
            return True
        elif self.reach_head(path) and self.reach_end(path):
            return True
        else:
            return False

    def reach_head(self, path):
        former_nodes = filter(lambda n: path[0] in self.edges[n], self.edges.keys())
        for n in former_nodes:
            if n not in path or n == path[-1]:
                return False
        return True

    def reach_end(self, path):
        later_nodes = self.edges[path[-1]]
        for n in later_nodes:
            if n not in path or n == path[0]:
                return False
        return True

    def extendable(self, path):
        if self.is_prime_path(path) or self.reach_end(path):
            return False
        else:
            return True

    def find_simple_path(self, ex_paths, paths):
        paths.extend(filter(lambda p: self.is_prime_path(p), ex_paths))
        ex_paths = filter(lambda p: self.extendable(p), ex_paths)
        new_ex_paths = []
        for p in ex_paths:
            for nx in self.edges[p[-1]]:
                if nx not in p or nx == p[0]:
                    new_ex_paths.append(p + (nx,))
        if len(new_ex_paths) > 0:
            self.find_simple_path(new_ex_paths, paths)

    def find_prime_paths(self):
        ex_paths = [(n,) for n in self.edges.keys()]
        simple_paths = []
        self.find_simple_path(ex_paths, simple_paths)
        prime_paths = sorted(simple_paths, key=lambda a: (len(a), a))
        return prime_paths


if __name__ == "__main__":
    graph = Graph()
    graph.read_from_file('2.text')
    _prime_paths = graph.find_prime_paths()
    print(len(_prime_paths))
    for p in _prime_paths:
        print(list(p))
