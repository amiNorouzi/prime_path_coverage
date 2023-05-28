<?php

function is_prime_path($path, $graph) {
    if (count($path) >= 2 && $path[0] === $path[count($path) - 1]) {
        return true;
    } else return reach_head($path, $graph) && reach_end($path, $graph);
}

function reach_head($path, $graph) {
    $former_nodes = array_filter(array_keys($graph), function ($n) use ($path, $graph) {
        return in_array($path[0], $graph[$n]);
    });
    foreach($former_nodes as $n) {
        if (!in_array((int)$n, $path) || $n === $path[count($path) - 1]) {
            return false;
        }
    }
    return true;
}

function reach_end($path, $graph) {
    $later_nodes = $graph[$path[count($path) - 1]];
    foreach($later_nodes as $n) {
        if (!in_array((int)$n, $path) || $n === $path[0]) {
            return false;
        }
    }
    return true;
}

function extendable($path, $graph) {
    return !(is_prime_path($path, $graph) || reach_end($path, $graph));
}

function find_simple_path($graph, &$ex_paths, &$paths) {
    $filtered_paths = [];
    foreach($ex_paths as $p){
        if(is_prime_path($p, $graph)){$paths[]=$p;}
        else if (extendable($p, $graph)){ $filtered_paths[] = $p; }
    }
    $ex_paths=$filtered_paths;
    $new_ex_paths = [];
    foreach ($ex_paths as $p) {
        foreach ($graph[$p[count($p)-1]] as $nx) {
            if (!in_array((int)$nx, $p) || $nx === $p[0]) {
                $new_ex_paths[] = array_merge($p, [(int)$nx]);
            }
        }
    }
    if (count($new_ex_paths) > 0) {
        find_simple_path($graph, $new_ex_paths, $paths);
    }
}

function find_prime_paths($graph) {
    $ex_paths = array_map(function($n){ return [(int)$n]; }, array_keys($graph));
    $simple_paths = [];
    find_simple_path($graph, $ex_paths, $simple_paths);
    usort($simple_paths, function ($a, $b) {
        if(count($a) == count($b)){
            if($a[0] == $b[0]) return 0;
            return ($a[0] < $b[0]) ? -1 : 1;
        }
        return (count($a) < count($b)) ? -1 : 1;
    });
    print_r($simple_paths);
}

$graph = [];
$handle = fopen("input.txt", "r");
if ($handle) {
    while (($line = fgets($handle)) !== false) {
        $lineNodes = json_decode($line);
        if (isset($graph[$lineNodes[0]])) {
            $graph[$lineNodes[0]][] = $lineNodes[1];
        } else {
            $graph[$lineNodes[0]] = [$lineNodes[1]];
        }
        if (!isset($graph[$lineNodes[1]])) $graph[$lineNodes[1]] = [];
    }
    fclose($handle);
}
find_prime_paths($graph);

?>
