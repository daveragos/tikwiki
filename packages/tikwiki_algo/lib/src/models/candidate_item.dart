class AlgorithmicCandidate {
  const AlgorithmicCandidate({
    required this.id,
    required this.title,
    required this.category,
    this.rawUpvotes = 0,
    this.rawComments = 0,
    this.rawSaves = 0,
  });

  final String id;
  final String title;
  final String category;
  final int rawUpvotes;
  final int rawComments;
  final int rawSaves;

  AlgorithmicCandidate copyWith({
    String? id,
    String? title,
    String? category,
    int? rawUpvotes,
    int? rawComments,
    int? rawSaves,
  }) {
    return AlgorithmicCandidate(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      rawUpvotes: rawUpvotes ?? this.rawUpvotes,
      rawComments: rawComments ?? this.rawComments,
      rawSaves: rawSaves ?? this.rawSaves,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlgorithmicCandidate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          category == other.category &&
          rawUpvotes == other.rawUpvotes &&
          rawComments == other.rawComments &&
          rawSaves == other.rawSaves;

  @override
  int get hashCode =>
      Object.hash(id, title, category, rawUpvotes, rawComments, rawSaves);

  @override
  String toString() {
    return 'AlgorithmicCandidate('
        'id: $id, '
        'title: $title, '
        'category: $category, '
        'rawUpvotes: $rawUpvotes, '
        'rawComments: $rawComments, '
        'rawSaves: $rawSaves'
        ')';
  }
}
