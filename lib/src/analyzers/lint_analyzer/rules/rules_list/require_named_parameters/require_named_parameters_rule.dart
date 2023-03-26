import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/lint_utils.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/rules/models/common_rule.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/rules/rule_utils.dart';
import 'package:xam_analyzer/src/utils/node_utils.dart';

part 'visitor.dart';

class RequireNamedParametersRule extends CommonRule {
  RequireNamedParametersRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );
  static const String ruleId = 'require-named-parameters';
  static const _warning =
      'Methods and constructors with more than one parameter should use named parameters.';
  static const _correctionMessage = 'XAM: Convert to named parameters.';

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.targetNodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node, source: source),
            message: _warning,
            replacement: _createReplacement(node),
          ),
        )
        .toList(growable: false);
  }

  Replacement? _createReplacement(AstNode node) {
    FormalParameterList parameters;
    String prefix;
    String suffix;
    if (node is MethodDeclaration) {
      if (node.parameters == null) return null;
      parameters = node.parameters!;
      prefix = '${node.returnType} ${node.name}';
      suffix = node.body.toSource();
    } else if (node is ConstructorDeclaration) {
      parameters = node.parameters;
      prefix = '${node.constKeyword?.stringValue ?? ''} ${node.returnType}';
      suffix = node.body.toSource();
    } else {
      return null;
    }

    final buffer = StringBuffer()..write('$prefix({');
    for (var i = 0; i < parameters.parameters.length; i++) {
      final parameter = parameters.parameters[i];
      if (parameter is! DefaultFormalParameter || !parameter.isNamed) {
        if (parameter is! DefaultFormalParameter || !parameter.isOptional) {
          buffer.write('required ');
        }
        buffer.write(parameter);
        if (i < parameters.parameters.length - 1) {
          buffer.write(', ');
        }
      } else {
        buffer.write(parameter);
        if (i < parameters.parameters.length - 1) {
          buffer.write(', ');
        }
      }
    }
    buffer
      ..write('}) ')
      ..write(suffix.replaceAll('{', '{\n').replaceAll('}', '\n}'));

    return Replacement(
      comment: _correctionMessage,
      replacement: buffer.toString(),
    );
  }
}
