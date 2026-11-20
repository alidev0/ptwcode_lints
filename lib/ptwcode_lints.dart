import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/prefer_moving_to_variable_rule.dart';

/// The analyzer plugin for ptwcode_lints.
class PTWCodeLinters extends Plugin {
  @override
  String get name => 'ptwcode_lints';

  @override
  void register(PluginRegistry registry) {
    registry.registerLintRule(PreferMovingToVariableRule());
  }
}
