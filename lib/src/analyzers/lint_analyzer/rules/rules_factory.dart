import 'package:xam_analyzer/src/analyzers/lint_analyzer/rules/models/rule.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/rules/rules_list/no_empty_block/no_empty_block_rule.dart';
import 'package:xam_analyzer/src/analyzers/lint_analyzer/rules/rules_list/require_named_parameters/require_named_parameters_rule.dart';

final _implementedRules = <String, Rule Function(Map<String, Object>)>{
  NoEmptyBlockRule.ruleId: NoEmptyBlockRule.new,
  RequireNamedParametersRule.ruleId: RequireNamedParametersRule.new,
};

Iterable<String> get allRuleIds => _implementedRules.keys;

Iterable<Rule> getRulesById(Map<String, Map<String, Object>> rulesConfig) =>
    List.unmodifiable(_implementedRules.keys
        .where((id) => rulesConfig.keys.contains(id))
        .map<Rule>((id) => _implementedRules[id]!(rulesConfig[id]!)),);
