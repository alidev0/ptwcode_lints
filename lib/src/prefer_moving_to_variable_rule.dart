import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
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
    registry.addVariableDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final PreferMovingToVariableRule rule;
  final expressions = <Expression>{};
  final initializers = <LocalVariableElement, Expression>{};

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final element = node.declaredFragment?.element;
    final initializer = node.initializer;
    if (element is LocalVariableElement &&
        element.isFinal &&
        initializer != null) {
      initializers[element] = initializer;
    }
  }

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
          if (!_sameTarget(expr.prefix, node.prefix)) continue;
        }

        if (expr is PropertyAccess && node is PropertyAccess) {
          if (expr.propertyName.element != node.propertyName.element) {
            continue;
          }
          if (!_sameTarget(expr.target, node.target)) continue;
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

  // Matching property names can refer to different local variables, even when
  // those variables share the same name in separate callbacks.
  bool _sameTarget(Expression? first, Expression? second) {
    first = _resolveTarget(first);
    second = _resolveTarget(second);
    if (identical(first, second)) return true;
    if (first == null || second == null) return first == second;
    if (first is SimpleIdentifier && second is SimpleIdentifier) {
      return first.element != null && first.element == second.element;
    }
    if (first is PrefixedIdentifier && second is PrefixedIdentifier) {
      return first.element?.baseElement == second.element?.baseElement &&
          _sameTarget(first.prefix, second.prefix);
    }
    if (first is PropertyAccess && second is PropertyAccess) {
      return first.propertyName.element?.baseElement ==
              second.propertyName.element?.baseElement &&
          _sameTarget(first.target, second.target);
    }
    if (first is ParenthesizedExpression && second is ParenthesizedExpression) {
      return _sameTarget(first.expression, second.expression);
    }
    return (first is ThisExpression && second is ThisExpression) ||
        (first is SuperExpression && second is SuperExpression);
  }

  // Follow final local aliases, while keeping separate allocations distinct.
  Expression? _resolveTarget(Expression? target) {
    final visited = <Element>{};
    while (true) {
      if (target is ParenthesizedExpression) {
        target = target.expression;
        continue;
      }
      if (target is! SimpleIdentifier) return target;
      final element = target.element;
      if (element is! LocalVariableElement || !visited.add(element)) {
        return target;
      }
      final initializer = initializers[element];
      if (initializer == null) return target;
      target = initializer;
    }
  }
}
