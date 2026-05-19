class WikiCategoryBundle {
  final String categoryName;
  final List<String> associatedTitles;

  const WikiCategoryBundle({
    required this.categoryName,
    required this.associatedTitles,
  });

  factory WikiCategoryBundle.fromJson(Map<String, dynamic> json) {
    final categoryName = json['categoryName'] as String? ?? '';
    final associatedTitles =
        (json['associatedTitles'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    return WikiCategoryBundle(
      categoryName: categoryName,
      associatedTitles: associatedTitles,
    );
  }

  Map<String, dynamic> toJson() {
    return {'categoryName': categoryName, 'associatedTitles': associatedTitles};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiCategoryBundle &&
          runtimeType == other.runtimeType &&
          categoryName == other.categoryName &&
          _listEquals(associatedTitles, other.associatedTitles);

  @override
  int get hashCode => categoryName.hashCode ^ associatedTitles.hashCode;

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'WikiCategoryBundle(categoryName: $categoryName, associatedTitles: $associatedTitles)';
  }
}
