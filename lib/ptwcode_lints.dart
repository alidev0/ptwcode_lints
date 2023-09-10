import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/prefer_moving_to_variable_rule.dart';

/// This is the entrypoint of our custom linter
PluginBase createPlugin() => _PTWCodeLinters();

/// A class is used to list all the assists/lints defined by ptwcode_lints plugin.
class _PTWCodeLinters extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        PreferMovingToVariableRule(),
      ];
}
