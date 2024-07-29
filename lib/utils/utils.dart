import 'package:html/parser.dart' as html_parser;

class Utils {
  static String removeHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  static String clearSummaryText(
    String summary,
  ) {
    int earliestIndex = -1;
    List<String> targetPhrases = [
      "Users who liked this recipe also liked",
      "Similar recipes",
      "very similar to this recipe"
    ];
    for (String phrase in targetPhrases) {
      int targetIndex = summary.indexOf(phrase);
      if (targetIndex != -1 &&
          (earliestIndex == -1 || targetIndex < earliestIndex)) {
        earliestIndex = targetIndex;
      }
    }
    String processedHtmlData;
    if (earliestIndex != -1) {
      processedHtmlData = summary.substring(0, earliestIndex);
    } else {
      processedHtmlData = summary;
    }
    return processedHtmlData;
  }
}
