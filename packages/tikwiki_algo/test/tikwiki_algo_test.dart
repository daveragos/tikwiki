import 'package:test/test.dart';
import 'package:tikwiki_algo/tikwiki_algo.dart';

void main() {
  group('ScoringEngine', () {
    test('applies telemetry weights, thresholds, and category affinity', () {
      const candidate = AlgorithmicCandidate(
        id: 'quantum-1',
        title: 'Quantum Entanglement',
        category: 'QuantumPhysics',
        rawUpvotes: 5,
        rawComments: 1,
        rawSaves: 1,
      );
      const profile = UserProfile(
        categoryAffinities: <String, double>{'QuantumPhysics': 2.0},
      );
      const interactions = <UserInteraction>[
        UserInteraction.upvote(candidateId: 'quantum-1'),
        UserInteraction.commentOpen(
          candidateId: 'quantum-1',
          duration: Duration(seconds: 2),
        ),
        UserInteraction.commentOpen(
          candidateId: 'quantum-1',
          duration: Duration(seconds: 3),
        ),
        UserInteraction.bookmarkSave(candidateId: 'quantum-1'),
        UserInteraction.quickSkip(
          candidateId: 'quantum-1',
          duration: Duration(seconds: 2),
        ),
      ];

      const scoringEngine = ScoringEngine();
      final score = scoringEngine.scoreCandidate(
        candidate: candidate,
        userProfile: profile,
        interactions: interactions,
      );

      expect(score.engagementScore, equals(17.0));
      expect(score.interactionScore, equals(3.0));
      expect(score.preDiversityScore, equals(40.0));
      expect(score.finalScore, equals(40.0));
    });
  });

  group('FeedRanker', () {
    const ranker = FeedRanker();

    test('sources a 60/40 mix when the caller limits the candidate pool', () {
      final rawPool = <AlgorithmicCandidate>[
        const AlgorithmicCandidate(
          id: '1',
          title: 'Quantum Foam',
          category: 'Science',
        ),
        const AlgorithmicCandidate(
          id: '2',
          title: 'Particle Zoo',
          category: 'Science',
        ),
        const AlgorithmicCandidate(
          id: '3',
          title: 'Mughal Kitchens',
          category: 'Cooking',
        ),
        const AlgorithmicCandidate(
          id: '4',
          title: 'Roman Roads',
          category: 'History',
        ),
        const AlgorithmicCandidate(
          id: '5',
          title: 'French Sauces',
          category: 'Cooking',
        ),
        const AlgorithmicCandidate(
          id: '6',
          title: 'Nebulae',
          category: 'Science',
        ),
      ];
      const profile = UserProfile(
        categoryAffinities: <String, double>{
          'Science': 1.8,
          'History': 1.3,
          'Cooking': 0.4,
        },
      );

      final sourced = ranker.sourceCandidates(
        rawPool: rawPool,
        userProfile: profile,
        maxCandidates: 5,
      );

      expect(sourced, hasLength(5));
      expect(
        sourced.map((candidate) => candidate.id),
        equals(const <String>['1', '2', '4', '3', '5']),
      );
    });

    test('drops seen candidates before ranking the feed', () {
      final rawPool = <AlgorithmicCandidate>[
        const AlgorithmicCandidate(
          id: 'seen',
          title: 'Already Read',
          category: 'History',
          rawUpvotes: 100,
        ),
        const AlgorithmicCandidate(
          id: 'fresh',
          title: 'Fresh Find',
          category: 'History',
          rawUpvotes: 10,
        ),
      ];
      const profile = UserProfile(
        seenArticleIds: <String>{'seen'},
        categoryAffinities: <String, double>{'History': 1.5},
      );

      final rankedFeed = ranker.generateOptimizedFeed(
        rawPool: rawPool,
        userProfile: profile,
      );

      expect(rankedFeed, hasLength(1));
      expect(rankedFeed.single.id, equals('fresh'));
    });

    test('reranks adjacent categories with diversity attenuation', () {
      final rawPool = <AlgorithmicCandidate>[
        const AlgorithmicCandidate(
          id: 'history-1',
          title: 'Roman Empire',
          category: 'History',
          rawUpvotes: 100,
        ),
        const AlgorithmicCandidate(
          id: 'history-2',
          title: 'Byzantine Court',
          category: 'History',
          rawUpvotes: 90,
        ),
        const AlgorithmicCandidate(
          id: 'science-1',
          title: 'Exoplanets',
          category: 'Science',
          rawUpvotes: 80,
        ),
      ];
      const profile = UserProfile(
        categoryAffinities: <String, double>{'History': 1.0, 'Science': 1.0},
      );

      final rankedFeed = ranker.rankFeed(
        rawPool: rawPool,
        userProfile: profile,
      );

      expect(
        rankedFeed.map((entry) => entry.candidate.id),
        equals(const <String>['history-1', 'science-1', 'history-2']),
      );
      expect(rankedFeed[2].diversityPenalized, isFalse);
    });
  });
}
