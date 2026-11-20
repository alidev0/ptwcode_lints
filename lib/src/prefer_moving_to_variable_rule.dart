import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

final _name = 'prefer_moving_to_variable';
final _message =
    'Prefer moving repeated invocations to variable and use it instead.';
final _code = LintCode(_name, _message);

/// Reports repeated property accesses within the same function.
class PreferMovingToVariableRule extends AnalysisRule {
  PreferMovingToVariableRule() : super(name: _name, description: _message);

  @override
  LintCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addPrefixedIdentifier(this, visitor);
    registry.addPropertyAccess(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final PreferMovingToVariableRule rule;
  final expressions = <Expression>{};

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) => _check(node);

  @override
  void visitPropertyAccess(PropertyAccess node) => _check(node);

  void _check(Expression node) {
    if (node.parent is PropertyAccess) return;
    if (node.parent is AssignmentExpression) return;
    if (node.parent is MethodInvocation) return;
    if (node.parent is FunctionExpressionInvocation) return;
    if (node.parent is FormalParameterDefaultClause) return;

    if (node is PrefixedIdentifier || node is PropertyAccess) {
      final parent2 = node.parent?.parent;
      if (parent2 is FunctionExpression) {
        final params =
            parent2.parameters?.parameterFragments.map(
              (el) => el?.element.name,
            ) ??
            [];
        if (params.contains(node.beginToken.lexeme)) return;
      }

      for (var item in node.childEntities) {
        if (item is IndexExpression) return;
      }

      final prefix = node is PrefixedIdentifier ? node.prefix : null;
      final statements = node.thisOrAncestorOfType<Block>()?.statements ?? [];
      for (final statement in statements) {
        if (statement is VariableDeclarationStatement) {
          for (final variable in statement.variables.variables) {
            if (variable.declaredFragment?.element == prefix?.element) {
              if (variable.initializer is IndexExpression) return;
            }
          }
        }
      }

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
          if (expr.element == null) continue;
          if (node.element == null) continue;
          if (expr.element != node.element) continue;
        }

        if (expr is PropertyAccess && node is PropertyAccess) {
          if (expr.propertyName.element != node.propertyName.element) {
            continue;
          }
        }

        List<AstNode> funs2 = [];
        expr.thisOrAncestorMatching((p0) {
          if (p0 is BlockFunctionBody) funs2.add(p0);
          if (p0 is ExpressionFunctionBody) funs2.add(p0);
          return false;
        });
        if (function1?.offset != funs2.lastOrNull?.offset) continue;

        print('==> match: $node - $expr');
        rule.reportAtToken(expr.endToken);
        rule.reportAtToken(node.endToken);
      }
    }
  }
}
