import 'package:html_unescape/html_unescape.dart';

class HtmlUtils {
  HtmlUtils._();

  static final _unescape = HtmlUnescape();

  static String stripTags(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return 'No description available.';
    
    var text = htmlString;
    
    // Replace <br> with newlines
    text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    
    // Replace block closing tags with newlines
    text = text.replaceAll(RegExp(r'</(p|div|h[1-6]|li|tr|section|article)>', caseSensitive: false), '\n');
    
    // Remove ALL HTML tags - run until no more tags found
    var previous = '';
    while (previous != text) {
      previous = text;
      text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    }
    
    // Decode all HTML entities
    text = _unescape.convert(text);
    
    // Clean up whitespace
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.replaceAll(RegExp(r'\n\s*\n+'), '\n\n');
    text = text.trim();
    
    return text.isEmpty ? 'No description available.' : text;
  }
}