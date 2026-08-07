class Ebook {
  final String id;
  final String title;
  String content;
  String format; // e.g., 'Kindle', 'Standard'

  Ebook({required this.id, required this.title, required this.content, this.format = 'Standard'});
}
