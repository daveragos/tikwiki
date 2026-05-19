class WikiFullContent {
  final String id;
  final String title;
  final String rawHtmlBody;
  final String mobileUrl;

  const WikiFullContent({
    required this.id,
    required this.title,
    required this.rawHtmlBody,
    required this.mobileUrl,
  });

  factory WikiFullContent.fromHtml(
    String htmlBody, {
    required String title,
    required String mobileUrl,
  }) {
    final pageIdRegExp = RegExp(
      r'<meta[^>]+property="mw:pageId"[^>]+content="([^"]+)"',
    );
    final altPageIdRegExp = RegExp(
      r'<meta[^>]+content="([^"]+)"[^>]+property="mw:pageId"',
    );

    var id = '';
    var match = pageIdRegExp.firstMatch(htmlBody);
    if (match != null) {
      id = match.group(1) ?? '';
    } else {
      match = altPageIdRegExp.firstMatch(htmlBody);
      if (match != null) {
        id = match.group(1) ?? '';
      }
    }

    final titleRegExp = RegExp(r'<title>([^<]+)</title>');
    var parsedTitle = title;
    final titleMatch = titleRegExp.firstMatch(htmlBody);
    if (titleMatch != null) {
      parsedTitle = titleMatch.group(1) ?? title;
    }

    return WikiFullContent(
      id: id,
      title: parsedTitle,
      rawHtmlBody: htmlBody,
      mobileUrl: mobileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'rawHtmlBody': rawHtmlBody,
      'mobileUrl': mobileUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiFullContent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          rawHtmlBody == other.rawHtmlBody &&
          mobileUrl == other.mobileUrl;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ rawHtmlBody.hashCode ^ mobileUrl.hashCode;

  @override
  String toString() {
    return 'WikiFullContent(id: $id, title: $title, mobileUrl: $mobileUrl)';
  }
}
