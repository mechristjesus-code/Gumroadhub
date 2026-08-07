class WordGenie {
  Future<String> enhanceText(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    return "WordGenie enhanced: $text (improved flow & vocabulary)";
  }

  Future<String> getWritingSuggestion(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    return "WordGenie Suggestion: Try adding more descriptive adjectives in this section.";
  }
}
