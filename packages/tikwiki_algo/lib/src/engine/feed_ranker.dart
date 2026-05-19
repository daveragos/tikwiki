import 'dart:math' as math;

import '../models/candidate_item.dart';
import '../models/user_interaction.dart';
import '../models/user_profile.dart';
import 'diversity_filter.dart';
import 'scoring_engine.dart';

class FeedRanker {
  const FeedRanker({
    this.scoringEngine = const ScoringEngine(),
    this.diversityFilter = const DiversityFilter(),
    this.inNetworkRatio = 0.6,
    this.affinityThreshold = 1.0,
  }) : assert(inNetworkRatio > 0 && inNetworkRatio < 1);

  final ScoringEngine scoringEngine;
  final DiversityFilter diversityFilter;
  final double inNetworkRatio;
  final double affinityThreshold;

  List<AlgorithmicCandidate> generateOptimizedFeed({
    required List<AlgorithmicCandidate> rawPool,
    required UserProfile userProfile,
    List<UserInteraction> interactions = const <UserInteraction>[],
    int? maxCandidates,
  }) {
    return rankFeed(
      rawPool: rawPool,
      userProfile: userProfile,
      interactions: interactions,
      maxCandidates: maxCandidates,
    ).map((entry) => entry.candidate).toList(growable: false);
  }

  List<CandidateScore> rankFeed({
    required List<AlgorithmicCandidate> rawPool,
    required UserProfile userProfile,
    List<UserInteraction> interactions = const <UserInteraction>[],
    int? maxCandidates,
  }) {
    final sourced = sourceCandidates(
      rawPool: rawPool,
      userProfile: userProfile,
      maxCandidates: maxCandidates,
    );
    final deduplicated = sourced
        .where((candidate) => !userProfile.hasSeen(candidate.id))
        .toList(growable: false);
    final scored =
        scoringEngine.scoreCandidates(
          candidates: deduplicated,
          userProfile: userProfile,
          interactions: interactions,
        )..sort(
          (left, right) =>
              right.preDiversityScore.compareTo(left.preDiversityScore),
        );

    return diversityFilter.apply(scored);
  }

  List<AlgorithmicCandidate> sourceCandidates({
    required List<AlgorithmicCandidate> rawPool,
    required UserProfile userProfile,
    int? maxCandidates,
  }) {
    final effectiveLimit = switch (maxCandidates) {
      null => rawPool.length,
      final value when value <= 0 => 0,
      final value => math.min(value, rawPool.length),
    };

    if (effectiveLimit == 0) {
      return const <AlgorithmicCandidate>[];
    }

    final inNetwork = <AlgorithmicCandidate>[];
    final exploration = <AlgorithmicCandidate>[];

    for (final candidate in rawPool) {
      if (_isInNetwork(candidate, userProfile)) {
        inNetwork.add(candidate);
      } else {
        exploration.add(candidate);
      }
    }

    var desiredInNetwork = (effectiveLimit * inNetworkRatio).round();
    desiredInNetwork = math.min(desiredInNetwork, inNetwork.length);

    var desiredExploration = effectiveLimit - desiredInNetwork;
    desiredExploration = math.min(desiredExploration, exploration.length);

    final sourced = <AlgorithmicCandidate>[
      ...inNetwork.take(desiredInNetwork),
      ...exploration.take(desiredExploration),
    ];

    if (sourced.length < effectiveLimit) {
      sourced.addAll(
        [
          ...inNetwork.skip(desiredInNetwork),
          ...exploration.skip(desiredExploration),
        ].take(effectiveLimit - sourced.length),
      );
    }

    return List<AlgorithmicCandidate>.unmodifiable(sourced);
  }

  bool _isInNetwork(AlgorithmicCandidate candidate, UserProfile userProfile) {
    final affinity = userProfile.categoryAffinities[candidate.category];
    return affinity != null && affinity >= affinityThreshold;
  }
}
