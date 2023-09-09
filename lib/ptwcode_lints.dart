import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/prefer_moving_to_variable_rule.dart';

PluginBase createPlugin() => _PTWCodeLinters();

class _PTWCodeLinters extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        PreferMovingToVariableRule(),
      ];
}
