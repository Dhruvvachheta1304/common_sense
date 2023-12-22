class QuoteModel {
  final String id;
  final String quote;
  final int likes;

  QuoteModel({
    required this.id,
    required this.quote,
    this.likes = 0,
  });
}
