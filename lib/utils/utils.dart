import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart' as html_parser;

final storageBox = GetStorage();

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
      "Try",
      "If you like this recipe",
      "This score is",
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

  static void saveToLocalStorage({required String key, required dynamic data}) {
    storageBox.write(
      key,
      data,
    );
  }

  static void clearLocalStorage() {
    storageBox.erase();
  }

  static dynamic getFomLocalStorage({required String key}) {
    return storageBox.read(key);
  }
}
