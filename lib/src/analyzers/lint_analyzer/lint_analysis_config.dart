import 'package:glob/glob.dart';

import 'package:xam_analyzer/src/analyzers/lint_analyzer/rules/models/rule.dart';

/// Represents converted lint config which contains parsed entities.

class LintAnalysisConfig {

  const LintAnalysisConfig(
    this.globalExcludes,
    this.codeRules,
    this.rulesExcludes,
    this.rootFolder,
    this.analysisOptionsPath,
  );
  final Iterable<Glob> globalExcludes;
  final Iterable<Rule> codeRules;
  final Iterable<Glob> rulesExcludes;
  final String rootFolder;
  final String? analysisOptionsPath;

  Map<String, Object?> toJson() => {
        'rules': codeRules.map((rule) => rule.toJson()).toList(),
        'rules-excludes': rulesExcludes.map((glob) => glob.pattern).toList(),
        'analysis-options-path': analysisOptionsPath,
      };
}
