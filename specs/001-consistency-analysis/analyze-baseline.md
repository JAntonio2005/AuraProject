# Analyze Baseline

## Metadata
- Date: 2026-04-08 13:24:25
- Command: flutter analyze

## Output

Analyzing repo proyecto Aura...                                 

warning - Unused import: 'package:hive_flutter/hive_flutter.dart' - lib\main.dart:4:8 - unused_import
warning - The value of the field '_accessToken' isn't used - lib\src\core\routes\services\auth_service.dart:21:11 - unused_field
warning - The value of the field '_accessToken' isn't used - lib\src\core\routes\services\auth_services_original.dart:21:11 - unused_field
warning - The exception variable 'e' isn't used, so the 'catch' clause can be removed - lib\src\core\routes\services\breeds_service.dart:43:30 - unused_catch_clause
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:21:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:28:7 - avoid_print
   info - The argument type 'int' isn't related to 'String' - lib\src\core\routes\services\history_service.dart:28:36 - collection_methods_unrelated_type
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:72:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:74:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:76:7 - avoid_print
warning - The value of the field '_lastResult' isn't used - lib\src\features\capture\presentation\pages\capture_page.dart:30:3 - unused_field
   info - Unnecessary braces in a string interpolation - lib\src\features\capture\presentation\pages\capture_page.dart:117:37 - unnecessary_brace_in_string_interps
warning - Duplicate import - lib\src\features\collection\presentation\pages\collection_page.dart:8:8 - duplicate_import
   info - Don't use 'BuildContext's across async gaps - lib\src\features\collection\presentation\pages\collection_page.dart:117:7 - use_build_context_synchronously
   info - Angle brackets will be interpreted as HTML - lib\src\features\result\presentation\pages\breed_detail_page.dart:28:12 - unintended_html_in_doc_comment
warning - Unnecessary cast - lib\src\features\result\presentation\pages\breed_detail_page.dart:37:45 - unnecessary_cast
   info - Unnecessary use of 'toList' in a spread - lib\src\features\result\presentation\pages\prediction_detail_page.dart:130:18 - unnecessary_to_list_in_spreads
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\src\widgets\slow_bg.dart:123:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\src\widgets\slow_bg.dart:133:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\src\widgets\slow_bg.dart:134:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\src\widgets\slow_bg.dart:135:34 - deprecated_member_use

flutter : 21 issues found. (ran in 3.5s)
En línea: 1 Carácter: 288
+ ... nsistency-analysis/analyze-baseline.md"; flutter analyze 2>&1 | Tee-O ...
+                                              ~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (21 issues found. (ran in 3.5s):St 
   ring) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError
 
