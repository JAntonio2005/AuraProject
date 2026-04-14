# Analyze Final

## Metadata
- Date: 2026-04-08 13:27:11
- Command: flutter analyze
- Baseline Issues: 21
- Final Issues: 12
- Target (SC-002): <= 4 (or documented backlog)

## Error Severity Check
- Analyzer output contains no error - diagnostics (only warning/info in current run).

## Output
Analyzing repo proyecto Aura...                                 

warning - The value of the field '_accessToken' isn't used - lib\src\core\routes\services\auth_service.dart:21:11 - unused_field
warning - The value of the field '_accessToken' isn't used - lib\src\core\routes\services\auth_services_original.dart:21:11 - unused_field
warning - The exception variable 'e' isn't used, so the 'catch' clause can be removed - lib\src\core\routes\services\breeds_service.dart:43:30 - unused_catch_clause
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:21:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:30:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:75:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:77:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:79:7 - avoid_print
   info - Unnecessary braces in a string interpolation - lib\src\features\capture\presentation\pages\capture_page.dart:114:37 - unnecessary_brace_in_string_interps
   info - Don't use 'BuildContext's across async gaps - lib\src\features\collection\presentation\pages\collection_page.dart:116:7 - use_build_context_synchronously
   info - Angle brackets will be interpreted as HTML - lib\src\features\result\presentation\pages\breed_detail_page.dart:28:12 - unintended_html_in_doc_comment
   info - Unnecessary use of 'toList' in a spread - lib\src\features\result\presentation\pages\prediction_detail_page.dart:130:18 - unnecessary_to_list_in_spreads

flutter : 12 issues found. (ran in 3.1s)
En línea: 1 Carácter: 68
+ ... el/OneDrive/Desktop/repo proyecto Aura"; flutter analyze 2>&1 | Tee-O ...
+                                              ~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (12 issues found. (ran in 3.1s):St 
   ring) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError
 
