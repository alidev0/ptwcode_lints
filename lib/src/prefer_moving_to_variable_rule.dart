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

    context.registry.addVariableDeclaration((node) {
      final block =
          node.thisOrAncestorMatching((p0) => p0 is BlockFunctionBody);

      final itemCode = node.toString().split('=').last.trim();
      if (!itemCode.toString().contains('.')) return;

      final item = _Item(
        itemCode,
        node.offset,
        block?.offset ?? 0,
        node.endToken,
      );

      all.add(item);

      _checkAndReport(all, reported, reporter);
    });

    context.registry.addArgumentList((node) {
      final block =
          node.thisOrAncestorMatching((p0) => p0 is BlockFunctionBody);

      for (Expression element in node.arguments) {
        if (!element.toString().contains('.')) continue;
        final item = _Item(
          element.toString(),
          element.offset,
          block?.offset ?? 0,
          element.endToken,
        );

        all.add(item);
      }

      _checkAndReport(all, reported, reporter);
    });
  }
}

class _Item {
  _Item(this.code, this.offset, this.parentOffset, this.endToken);

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
