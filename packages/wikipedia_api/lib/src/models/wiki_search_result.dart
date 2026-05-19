class WikiSearchResult {
  final String title;
  final int pageId;
  final String? descriptionSnippet;
  final String? tinyThumbnailUrl;

  const WikiSearchResult({
    required this.title,
    required this.pageId,
    this.descriptionSnippet,
    this.tinyThumbnailUrl,
  });

  factory WikiSearchResult.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final pageId = json['id'] as int? ?? json['pageid'] as int? ?? 0;
    final descriptionSnippet = json['description'] as String? ?? json['excerpt'] as String?;
    
    String? thumbUrl;
    final thumbnailObj = json['thumbnail'];
    if (thumbnailObj is Map) {
      final rawUrl = thumbnailObj['url'] as String?;
      if (rawUrl != null) {
        if (rawUrl.startsWith('//')) {
          thumbUrl = 'https:$rawUrl';
        } else {
          thumbUrl = rawUrl;
        }
      }
    }

    return WikiSearchResult(
      title: title,
      pageId: pageId,
      descriptionSnippet: descriptionSnippet,
      tinyThumbnailUrl: thumbUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': pageId,
      if (descriptionSnippet != null) 'description': descriptionSnippet,
      if (tinyThumbnailUrl != null)
        'thumbnail': {
          'url': tinyThumbnailUrl,
        },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiSearchResult &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          pageId == other.pageId &&
          descriptionSnippet == other.descriptionSnippet &&
          tinyThumbnailUrl == other.tinyThumbnailUrl;

  @override
  int get hashCode =>
      title.hashCode ^
      pageId.hashCode ^
      descriptionSnippet.hashCode ^
      tinyThumbnailUrl.hashCode;

  @override
  String toString() {
    return 'WikiSearchResult(title: $title, pageId: $pageId, descriptionSnippet: $descriptionSnippet, tinyThumbnailUrl: $tinyThumbnailUrl)';
  }
}
