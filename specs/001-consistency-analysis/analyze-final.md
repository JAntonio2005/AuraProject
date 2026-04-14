# Analyze Final

## Metadata
- Date: 2026-04-14
- Command: flutter analyze
- Baseline Issues: 21
- Final Issues: 15
- Target (SC-002): <= 4 (or documented backlog)

## Error Severity Check
- Analyzer output contains no error - diagnostics (only warning/info in current run).

## Output
Analyzing repo proyecto Aura...                                 

   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:21:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:30:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:75:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:77:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\src\core\routes\services\history_service.dart:79:7 - avoid_print
   info - Unnecessary braces in a string interpolation - lib\src\features\capture\presentation\pages\capture_page.dart:114:37 - unnecessary_brace_in_string_interps
   info - Don't use 'BuildContext's across async gaps - lib\src\features\collection\presentation\pages\collection_page.dart:116:7 - use_build_context_synchronously
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead - lib\src\features\institutions\presentation\pages\institutions_page.dart:452:19 - deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead - lib\src\features\institutions\presentation\pages\institutions_page.dart:454:19 - deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead - lib\src\features\institutions\presentation\pages\institutions_page.dart:498:19 - deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead - lib\src\features\institutions\presentation\pages\institutions_page.dart:500:19 - deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead - lib\src\features\institutions\presentation\pages\institutions_page.dart:516:19 - deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead - lib\src\features\institutions\presentation\pages\institutions_page.dart:518:19 - deprecated_member_use
   info - Angle brackets will be interpreted as HTML - lib\src\features\result\presentation\pages\breed_detail_page.dart:28:12 - unintended_html_in_doc_comment
   info - Unnecessary use of 'toList' in a spread - lib\src\features\result\presentation\pages\prediction_detail_page.dart:130:18 - unnecessary_to_list_in_spreads

15 issues found. (ran in 3.2s)
 
