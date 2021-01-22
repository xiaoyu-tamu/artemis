import 'package:gql/ast.dart';

/// adds type name resolving to all schema types
class AppendTypename extends TransformingVisitor {
  /// type name value
  final String typeName;

  /// adds type name resolving to all schema types
  AppendTypename(this.typeName);

  @override
  InlineFragmentNode visitInlineFragmentNode(InlineFragmentNode node) {
    if (node.selectionSet == null) {
      return node;
    }

    return InlineFragmentNode(
      typeCondition: node.typeCondition,
      directives: node.directives,
      selectionSet: SelectionSetNode(
        selections: <SelectionNode>[
          FieldNode(name: NameNode(value: typeName)),
          ...node.selectionSet.selections.where((element) =>
              (element is! FieldNode) ||
              (element is FieldNode && element.name.value != typeName))
        ],
      ),
    );
  }

  @override
  FieldNode visitFieldNode(FieldNode node) {
    if (node.selectionSet == null) {
      return node;
    }

    return FieldNode(
      name: node.name,
      alias: node.alias,
      arguments: node.arguments,
      directives: node.directives,
      selectionSet: SelectionSetNode(
        selections: <SelectionNode>[
          FieldNode(name: NameNode(value: typeName)),
          ...node.selectionSet.selections.where((element) =>
              (element is! FieldNode) ||
              (element is FieldNode && element.name.value != typeName))
        ],
      ),
    );
  }
}
