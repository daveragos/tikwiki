import '../models/candidate_item.dart';
import '../models/user_interaction.dart';
import '../models/user_profile.dart';

class TelemetryWeights {
  const TelemetryWeights({
    this.upvote = 1.0,
    this.commentOpen = 4.0,
    this.bookmarkSave = 8.0,
    this.downvote = 10.0,
  });

  final double upvote;
  final double commentOpen;
  final double bookmarkSave;
  final double downvote;
}

class CandidateScore {
  const CandidateScore({
    required this.candidate,
    required this.categoryWeight,
    required this.engagementScore,
    required this.interactionScore,
    required this.preDiversityScore,
    required this.finalScore,
    this.diversityPenalized = false,
  });

  final AlgorithmicCandidate candidate;
  final double categoryWeight;
  final double engagementScore;
  final double interactionScore;
  final double preDiversityScore;
  final double finalScore;
  final bool diversityPenalized;

  double get score => finalScore;

  CandidateScore copyWith({
    AlgorithmicCandidate? candidate,
    double? categoryWeight,
    double? engagementScore,
    double? interactionScore,
    double? preDiversityScore,
    double? finalScore,
    bool? diversityPenalized,
  }) {
    return CandidateScore(
      candidate: candidate ?? this.candidate,
      categoryWeight: categoryWeight ?? this.categoryWeight,
      engagementScore: engagementScore ?? this.engagementScore,
      interactionScore: interactionScore ?? this.interactionScore,
      preDiversityScore: preDiversityScore ?? this.preDiversityScore,
      finalScore: finalScore ?? this.finalScore,
      diversityPenalized: diversityPenalized ?? this.diversityPenalized,
    );
  }
}

class ScoringEngine {
  const ScoringEngine({
    this.weights = const TelemetryWeights(),
    this.commentOpenThreshold = const Duration(seconds: 3),
    this.quickSkipThreshold = const Duration(seconds: 3),
  });

  final TelemetryWeights weights;
  final Duration commentOpenThreshold;
  final Duration quickSkipThreshold;

  CandidateScore scoreCandidate({
    required AlgorithmicCandidate candidate,
    required UserProfile userProfile,
    List<UserInteraction> interactions = const <UserInteraction>[],
  }) {
    final categoryWeight = userProfile.affinityFor(candidate.category);
    final engagementScore =
        (weights.upvote * candidate.rawUpvotes) +
        (weights.commentOpen * candidate.rawComments) +
        (weights.bookmarkSave * candidate.rawSaves);

    final interactionScore = _scoreInteractions(
      interactions.where((event) => event.candidateId == candidate.id),
    );
    final aggregateScore =
        categoryWeight * (engagementScore + interactionScore);

    return CandidateScore(
      candidate: candidate,
      categoryWeight: categoryWeight,
      engagementScore: engagementScore,
      interactionScore: interactionScore,
      preDiversityScore: aggregateScore,
      finalScore: aggregateScore,
    );
  }

  List<CandidateScore> scoreCandidates({
    required List<AlgorithmicCandidate> candidates,
    required UserProfile userProfile,
    List<UserInteraction> interactions = const <UserInteraction>[],
  }) {
    return candidates
        .map(
          (candidate) => scoreCandidate(
            candidate: candidate,
            userProfile: userProfile,
            interactions: interactions,
          ),
        )
        .toList(growable: false);
  }

  double _scoreInteractions(Iterable<UserInteraction> interactions) {
    var score = 0.0;

    for (final interaction in interactions) {
      switch (interaction.type) {
        case UserInteractionType.upvote:
          score += weights.upvote;
        case UserInteractionType.commentOpen:
          if (interaction.duration >= commentOpenThreshold) {
            score += weights.commentOpen;
          }
        case UserInteractionType.bookmarkSave:
          score += weights.bookmarkSave;
        case UserInteractionType.downvote:
          score -= weights.downvote;
        case UserInteractionType.quickSkip:
          if (interaction.duration < quickSkipThreshold) {
            score -= weights.downvote;
          }
      }
    }

    return score;
  }
}
