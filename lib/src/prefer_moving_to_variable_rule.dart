import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final _name = 'prefer_moving_to_variable';
final _message =
    'Prefer moving repeated invocations to variable and use it instead.';
final _code = LintCode(name: _name, problemMessage: _message);

/// an extended class of DartLintRule to implement prefer_moving_to_variable rule
class PreferMovingToVariableRule extends DartLintRule {
  PreferMovingToVariableRule() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final expressions = <Expression>{};

    context.registry.addExpression((Expression node) {
      if (node.parent is PropertyAccess) return;
      if (node.parent is AssignmentExpression) return;

      if (node is PrefixedIdentifier || node is PropertyAccess) {
        final parent = node.parent?.parent;
        if (parent is FunctionExpression) {
          final params =
              parent.parameters?.parameterElements.map((el) => el?.name) ?? [];
          if (params.contains(node.beginToken.lexeme)) return;
        }

        final target1 = node is PropertyAccess ? node.realTarget : null;

        List<AstNode> funs1 = [];
        node.thisOrAncestorMatching((p0) {
          if (p0 is BlockFunctionBody) funs1.add(p0);
          if (p0 is ExpressionFunctionBody) funs1.add(p0);
          return false;
        });
        final function1 = funs1.lastOrNull;

        expressions.add(node);
        for (var expr in expressions) {
          if (expr == node) continue;
          if ('$expr' != '$node') continue;

          if (expr is PrefixedIdentifier && node is PrefixedIdentifier) {
            if (expr.staticElement != node.staticElement) continue;
          }

          if (expr is PropertyAccess && node is PropertyAccess) {
            if (expr.propertyName.staticElement !=
                node.propertyName.staticElement) {
              continue;
            }
          }

          final target2 = expr is PropertyAccess ? expr.realTarget : null;
          if (target1 != target2) continue;

          List<AstNode> funs2 = [];
          expr.thisOrAncestorMatching((p0) {
            if (p0 is BlockFunctionBody) funs2.add(p0);
            if (p0 is ExpressionFunctionBody) funs2.add(p0);
            return false;
          });
          if (function1?.offset != funs2.lastOrNull?.offset) continue;

          print('==> match: $node - $expr');
          reporter.atToken(expr.endToken, code);
          reporter.atToken(node.endToken, code);
        }
      }
    });
  }
}
