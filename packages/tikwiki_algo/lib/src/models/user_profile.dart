class UserProfile {
  const UserProfile({
    this.seenArticleIds = const <String>{},
    this.categoryAffinities = const <String, double>{},
  });

  final Set<String> seenArticleIds;
  final Map<String, double> categoryAffinities;

  double affinityFor(String category, {double fallback = 1.0}) {
    return categoryAffinities[category] ?? fallback;
  }

  bool hasSeen(String articleId) => seenArticleIds.contains(articleId);
}
