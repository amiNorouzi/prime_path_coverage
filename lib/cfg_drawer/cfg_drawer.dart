import 'package:flow_graph/flow_graph.dart' hide Graph;
import 'package:flutter/material.dart';
import 'package:prime_path_coverage/cfg_drawer/prime_path_coverage.dart';
import 'package:prime_path_coverage/functional_style/functional_style.dart';
import 'package:prime_path_coverage/utils/string_extension.dart';

import 'family_node.dart';

class CFGDrawer extends StatefulWidget {
  const CFGDrawer({super.key});

  @override
  State<CFGDrawer> createState() => _CFGDrawerState();
}

class _CFGDrawerState extends State<CFGDrawer> {
  late GraphNode<FamilyNode> root;
  Axis direction = Axis.vertical;
  bool centerLayout = true;
  int nodeCounter = 0;

  @override
  void initState() {
    root = GraphNode<FamilyNode>(data: FamilyNode(name: 'Start'), isRoot: true);
    super.initState();
  }

  final p8 = const SizedBox(width: 8);
  final vDivider32 = const VerticalDivider(indent: 18, endIndent: 18);

  //? Build
  @override
  Widget build(context) {
    return Scaffold(
      appBar: buildAppBar,
      body: Row(
        children: [
          buildSidebar,
          const VerticalDivider(),
          buildDraggableFlowGraphView,
        ],
      ),
    );
  }

  //? GraphView
  Expanded get buildDraggableFlowGraphView {
    return Expanded(
      flex: 2,
      child: StatefulBuilder(
        builder: (context, setter) {
          return DraggableFlowGraphView<FamilyNode>(
            root: root,
            direction: direction,
            centerLayout: centerLayout,
            willConnect: (node) {
              if (node.data?.singleChild == true) {
                if (node.nextList.length == 1) {
                  return false;
                } else {
                  return true;
                }
              } else if (node.data != null && !node.data!.singleChild) {
                return true;
              }
              return false;
            },
            willAccept: (node) {
              return node.data?.multiParent == true;
            },
            builder: (context, node) {
              return Container(
                color: Colors.white60,
                padding: const EdgeInsets.all(16),
                child: Text(
                  (node.data as FamilyNode).name,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),
              );
            },
            nodeSecondaryMenuItems: (node) {
              return [
                PopupMenuItem(
                  child: const Text('Delete'),
                  onTap: () {
                    setter(() {
                      node.deleteSelf();
                    });
                  },
                )
              ];
            },
            onEdgeColor: (n1, n2) {
              if (n1.data?.singleChild == true &&
                  n2.data?.multiParent == true) {
                return Colors.blueAccent;
              } else {
                return Colors.grey;
              }
            },
          );
        },
      ),
    );
  }

  //? SideBar
  int from = 0;
  int to = 0;
  Graph graph = Graph();

  void printPPC(
    List<GraphNode> nextList, [
    Graph? graphBuilder,
  ]) {
    graphBuilder ??= Graph();
    for (final node in nextList) {
      if (node.nextList.isNotEmpty) {
        for (final childNode in node.nextList) {
          graphBuilder.addEdge(
            int.parse(node.data.name),
            int.parse(childNode.data.name),
          );
        }
        printPPC(node.nextList, graphBuilder);
      }
    }
    setState(() => graph = graphBuilder!);
  }

  Expanded get buildSidebar {
    return Expanded(
      child: ListView(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(16),
        children: [
          multiParentNode,
          const Divider(),
          Row(
            children: [
              FunctionalStyle.textFiled.outlined
                  .label('from')
                  .onChange((value) {
                    if (value.isNotEmpty) from = value.parsInt;
                  })
                  .margin(20.edgeInsetsAll)
                  .expanded
                  .render,
              FunctionalStyle.textFiled.outlined
                  .label('to')
                  .onChange((value) {
                    if (value.isNotEmpty) to = value.parsInt;
                  })
                  .margin(20.edgeInsetsAll)
                  .expanded
                  .render,
              Icons.check.button.onPressed(() => printPPC(root.nextList)).render
            ],
          ),
          graph.getPrimePaths(from, to).text.render
        ],
      ),
    );
  }

  //? AppBar
  AppBar get buildAppBar {
    return AppBar(
      title: 'Draggable Flow'.text.render,
      actions: [
        Row(
          children: [
            Radio<Axis>(
              value: Axis.horizontal,
              groupValue: direction,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    direction = value;
                  });
                }
              },
            ),
            p8,
            'Horizontal'.text.render,
            const SizedBox(width: 16),
            Radio<Axis>(
              value: Axis.vertical,
              groupValue: direction,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    direction = value;
                  });
                }
              },
            ),
            p8,
            'Portrait'.text.render,
            vDivider32,
            Switch(
              value: centerLayout,
              onChanged: (b) {
                setState(() {
                  centerLayout = b;
                });
              },
            ),
            p8,
            'Middle layout'.text.render,
            vDivider32,
            'Reset'.button.onPressed(() {
              setState(() => root.clearAllNext());
              nodeCounter = 0;
            }).render,
            const SizedBox(width: 32),
          ],
        )
      ],
    );
  }

  //? Node
  Widget get multiParentNode {
    final node = Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      child: const Icon(Icons.panorama_wide_angle),
    );

    return Row(
      children: [
        Padding(
          padding: 16.edgeInsetsX,
          child: Draggable<GraphNodeFactory<FamilyNode>>(
            data: GraphNodeFactory(
              dataBuilder: () => FamilyNode(
                name: (nodeCounter++).toString(),
                multiParent: true,
                singleChild: false,
              ),
            ),
            feedback: Card(
              elevation: 6,
              child: node,
            ),
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.all(8),
              child: node,
            ),
          ),
        ),
      ],
    );
  }
}
