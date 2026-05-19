import 'scoring_engine.dart';

class DiversityFilter {
  const DiversityFilter({this.attenuationFactor = 0.45})
    : assert(attenuationFactor > 0 && attenuationFactor <= 1);

  final double attenuationFactor;

  List<CandidateScore> apply(List<CandidateScore> scoredCandidates) {
    if (scoredCandidates.length < 2) {
      return List<CandidateScore>.unmodifiable(scoredCandidates);
    }

    final remaining = List<CandidateScore>.from(scoredCandidates)
      ..sort(
        (left, right) =>
            right.preDiversityScore.compareTo(left.preDiversityScore),
      );
    final rankedFeed = <CandidateScore>[];
    String? previousCategory;

    while (remaining.isNotEmpty) {
      var bestIndex = 0;
      var bestAdjustedScore = double.negativeInfinity;

      for (var index = 0; index < remaining.length; index++) {
        final candidateScore = remaining[index];
        final adjustedScore = _adjustedScore(candidateScore, previousCategory);

        if (adjustedScore > bestAdjustedScore) {
          bestAdjustedScore = adjustedScore;
          bestIndex = index;
        }
      }

      final selected = remaining.removeAt(bestIndex);
      final diversityPenalized =
          selected.candidate.category == previousCategory;
      rankedFeed.add(
        selected.copyWith(
          finalScore: bestAdjustedScore,
          diversityPenalized: diversityPenalized,
        ),
      );
      previousCategory = selected.candidate.category;
    }

    return List<CandidateScore>.unmodifiable(rankedFeed);
  }

  double _adjustedScore(
    CandidateScore candidateScore,
    String? previousCategory,
  ) {
    if (candidateScore.candidate.category != previousCategory) {
      return candidateScore.preDiversityScore;
    }

    return candidateScore.preDiversityScore * attenuationFactor;
  }
}
