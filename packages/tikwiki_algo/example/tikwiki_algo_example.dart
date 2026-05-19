import 'package:tikwiki_algo/tikwiki_algo.dart';

void main() {
  const userProfile = UserProfile(
    seenArticleIds: <String>{'rome-1'},
    categoryAffinities: <String, double>{
      'Science': 1.8,
      'History': 1.2,
      'Cooking': 0.4,
    },
  );

  final rawPool = <AlgorithmicCandidate>[
    const AlgorithmicCandidate(
      id: 'rome-1',
      title: 'Roman Republic',
      category: 'History',
      rawUpvotes: 10,
      rawComments: 4,
      rawSaves: 2,
    ),
    const AlgorithmicCandidate(
      id: 'nebula-1',
      title: 'Nebula Formation',
      category: 'Science',
      rawUpvotes: 14,
      rawComments: 3,
      rawSaves: 5,
    ),
    const AlgorithmicCandidate(
      id: 'bread-1',
      title: 'Sourdough Starter',
      category: 'Cooking',
      rawUpvotes: 8,
      rawComments: 1,
      rawSaves: 1,
    ),
  ];

  const ranker = FeedRanker();
  final feed = ranker.generateOptimizedFeed(
    rawPool: rawPool,
    userProfile: userProfile,
    interactions: const <UserInteraction>[
      UserInteraction.commentOpen(
        candidateId: 'nebula-1',
        duration: Duration(seconds: 5),
      ),
    ],
  );

  for (final candidate in feed) {
    print('${candidate.category}: ${candidate.title}');
  }
}
