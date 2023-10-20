import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final _name = 'prefer_moving_to_variable';
final _message =
    'Prefer moving repeated invocations to variable and use it instead.';
final _code = LintCode(name: _name, problemMessage: _message);

/// an extended class of DartLintRule to implement prefer_moving_to_variable rule
class PreferMovingToVariableRule extends DartLintRule {
  PreferMovingToVariableRule() : super(code: _code);

  void _checkAndReport(
    List<_Item> all,
    List<_Item> reported,
    ErrorReporter reporter,
  ) {
    for (var el1 in all) {
      final length = all.where((el2) => el2.hasSameRef(el1)).length;

      if (length > 1) {
        final isReported = reported.where((el2) => el2.isSame(el1)).isNotEmpty;

        if (!isReported) {
          reporter.reportErrorForToken(code, el1.endToken);
          reported.add(el1);
        }
      }
    }
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    List<_Item> all = [];
    List<_Item> reported = [];

    context.registry.addExpression((node) {
      if (!node.toString().contains('.')) return;
      if (node.toString().contains(') {')) return;
      if (node.toString().contains('=')) return;
      if (node.toString().contains('=>')) return;
      if (node.toString().contains(':')) return;
      if (node.toString().contains('(')) return;
      if (node.toString().startsWith('..')) return;

      final closestBlock = node.thisOrAncestorMatching(
          (p0) => p0 is ExpressionStatement || p0 is FunctionExpression);

      final cond1 =
          closestBlock?.toString().contains('(${node.beginToken})') ?? false;
      if (cond1) return;

      if (closestBlock != null) {
        for (String char in ['=', '+=', '-=']) {
          if (closestBlock.toString().contains('$node $char')) return;
        }
      }

      final childEntities = closestBlock?.childEntities ?? [];
      if (childEntities.isNotEmpty) {
        final item = childEntities.first.toString().trim();
        final el = item.replaceAll('(', '').replaceAll(')', '');
        if (el.isNotEmpty) {
          final cond2 = item.contains('$el.');
          if (cond2) return;
        }
      }

      BlockFunctionBody? block2;
      node.thisOrAncestorMatching((p0) {
        if (p0 is BlockFunctionBody) block2 = p0;
        return false;
      });
      if (block2 == null) return;

      final cond3 = block2?.toString().contains('$node.') ?? false;
      if (cond3) return;

      final res = double.tryParse(node.toString());
      if (res != null) return;

      // print('===> node');
      // print(node);
      // print(closestBlock);
      // print(block2);

      final item = _Item(
        code: node.toString(),
        offset: node.offset,
        parentOffset: block2?.offset ?? 0,
        endToken: node.endToken,
      );

      all.add(item);

      _checkAndReport(all, reported, reporter);
    });

    /// addVariableDeclaration
    // context.registry.addVariableDeclaration((node) {
    //   final block =
    //       node.thisOrAncestorMatching((p0) => p0 is BlockFunctionBody);

    //   final itemCode = node.toString().split('=').last.trim();
    //   if (!itemCode.toString().contains('.')) return;

    //   final item = _Item(
    //     code: itemCode,
    //     offset: node.offset,
    //     parentOffset: block?.offset ?? 0,
    //     endToken: node.endToken,
    //   );

    //   all.add(item);

    //   _checkAndReport(all, reported, reporter);
    // });

    /// addArgumentList
    // context.registry.addArgumentList((node) {
    //   final block =
    //       node.thisOrAncestorMatching((p0) => p0 is BlockFunctionBody);

    //   for (Expression element in node.arguments) {
    //     if (!element.toString().contains('.')) continue;

    //     final item = _Item(
    //       code: element.toString(),
    //       offset: node.offset,
    //       parentOffset: block?.offset ?? 0,
    //       endToken: node.endToken,
    //     );

    //     all.add(item);
    //   }

    //   _checkAndReport(all, reported, reporter);
    // });
  }
}

class _Item {
  _Item({
    required this.code,
    required this.offset,
    required this.parentOffset,
    required this.endToken,
  });

  final String code;
  final int offset;
  final int parentOffset;
  final Token endToken;

  bool hasSameRef(_Item item) {
    return code == item.code && parentOffset == item.parentOffset;
  }

  bool isSame(_Item item) {
    return code == item.code &&
        parentOffset == item.parentOffset &&
        offset == item.offset;
  }
}
