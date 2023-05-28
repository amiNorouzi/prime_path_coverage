import fs from 'fs';
import * as readline from "readline";

function is_prime_path(path, graph) {
    if (path.length >= 2 && path[0] === path[path.length - 1]) {
        return true;
    } else return reach_head(path, graph) && reach_end(path, graph);
}

function reach_head(path, graph) {
    let former_nodes = Object.keys(graph).filter(n => graph[n].indexOf(path[0]) !== -1);
    for (let n of former_nodes) {
        if (!path.includes(parseInt(n)) || n === path[path.length - 1]) {
            return false;
        }
    }
    return true;
}

function reach_end(path, graph) {
    let later_nodes = graph[path[path.length - 1]];
    for (let n of later_nodes) {
        if (!path.includes(parseInt(n)) || n === path[0]) {
            return false;
        }
    }
    return true;
}

function extendable(path, graph) {
    return !(is_prime_path(path, graph) || reach_end(path, graph));
}

function find_simple_path(graph, ex_paths, paths) {
    paths.push(...ex_paths.filter(p => is_prime_path(p, graph)));
    ex_paths = ex_paths.filter(p => extendable(p, graph));
    let new_ex_paths = [];
    for (let p of ex_paths) {
        for (let nx of graph[p[p.length - 1]]) {
            if (!p.includes(parseInt(nx)) || nx === p[0]) {
                new_ex_paths.push([...p, parseInt(nx)]);
            }
        }
    }
    if (new_ex_paths.length > 0) {
        find_simple_path(graph, new_ex_paths, paths);
    }
}

function find_prime_paths(graph) {
    let ex_paths = Object.keys(graph).map(n => [parseInt(n)]);
    let simple_paths = [];
    find_simple_path(graph, ex_paths, simple_paths);
    let prime_paths = simple_paths.sort((a, b) => (a.length - b.length) || a[0] - b[0]);
    console.log(prime_paths);
}

async function main() {
    let graph = {};
    const fileStream = fs.createReadStream('input.txt');
    const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity
    });
    for await (const line of rl) {
        const lineNodes = JSON.parse(line);
        if (graph[lineNodes[0]]) {
            graph[lineNodes[0]].push(lineNodes[1])
        } else {
            graph[lineNodes[0]] = [lineNodes[1]]
        }
        if (!graph[lineNodes[1]]) graph[lineNodes[1]] = []
    }
    find_prime_paths(graph);
}

main()
