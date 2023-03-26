part of 'require_named_parameters_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _targetNodes = <AstNode>[];

  Iterable<AstNode> get targetNodes => _targetNodes;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    if (_hasMoreThanOneParameter(node.parameters) &&
        !_allParametersNamed(node.parameters)) {
      _targetNodes.add(node);
    }
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    super.visitConstructorDeclaration(node);

    if (_hasMoreThanOneParameter(node.parameters) &&
        !_allParametersNamed(node.parameters)) {
      _targetNodes.add(node);
    }
  }

  bool _hasMoreThanOneParameter(FormalParameterList? parameters) {
    return (parameters?.parameters ?? []).length > 1;
  }

  bool _allParametersNamed(FormalParameterList? parameters) {
    return (parameters?.parameters ?? <FormalParameter>[])
        .every((parameter) => parameter.isNamed);
  }
}
