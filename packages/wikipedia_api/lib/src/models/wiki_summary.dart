class WikiSummary {
  final String id;
  final String title;
  final String displayTitle;
  final String extract;
  final String? thumbnailUrl;
  final String? categoryHint;

  const WikiSummary({
    required this.id,
    required this.title,
    required this.displayTitle,
    required this.extract,
    this.thumbnailUrl,
    this.categoryHint,
  });

  factory WikiSummary.fromJson(
    Map<String, dynamic> json, {
    String? categoryHint,
  }) {
    final pageIdVal = json['pageid'] ?? json['id'];
    final String id = pageIdVal?.toString() ?? '';

    final String title = json['title'] as String? ?? '';
    final String displayTitle = json['displaytitle'] as String? ?? title;
    final String extract = json['extract'] as String? ?? '';

    String? thumbUrl;
    final thumbnailObj = json['thumbnail'];
    if (thumbnailObj is Map) {
      thumbUrl = thumbnailObj['source'] as String?;
    }

    return WikiSummary(
      id: id,
      title: title,
      displayTitle: displayTitle,
      extract: extract,
      thumbnailUrl: thumbUrl,
      categoryHint: categoryHint ?? json['categoryHint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageid': int.tryParse(id) ?? id,
      'title': title,
      'displaytitle': displayTitle,
      'extract': extract,
      if (thumbnailUrl != null) 'thumbnail': {'source': thumbnailUrl},
      if (categoryHint != null) 'categoryHint': categoryHint,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiSummary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          displayTitle == other.displayTitle &&
          extract == other.extract &&
          thumbnailUrl == other.thumbnailUrl &&
          categoryHint == other.categoryHint;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      displayTitle.hashCode ^
      extract.hashCode ^
      thumbnailUrl.hashCode ^
      categoryHint.hashCode;

  @override
  String toString() {
    return 'WikiSummary(id: $id, title: $title, displayTitle: $displayTitle, extract: $extract, thumbnailUrl: $thumbnailUrl, categoryHint: $categoryHint)';
  }
}
