class FamilyNode {
  FamilyNode({
    required this.name,
    this.singleChild = true,
    this.multiParent = false,
  });

  String name;
  bool singleChild;
  bool multiParent;
}
