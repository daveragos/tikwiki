# tikwiki_algo

A pure Dart ranking engine for the Tikwiki feed. The package handles candidate
sourcing, historical de-duplication, telemetry-based scoring, and category
diversity attenuation without depending on Flutter widgets or backend services.

## Pipeline

`FeedRanker` runs a four-stage recommendation pipeline:

1. `sourceCandidates()`
   Builds a 60/40 blend of in-network and exploration items when the caller
   provides a `maxCandidates` limit. Categories with affinity scores greater
   than or equal to `1.0` are treated as in-network by default.
2. Seen ledger filter
   Drops any item whose `id` already exists in `UserProfile.seenArticleIds`.
3. `ScoringEngine`
   Applies the weighted score equation:

   `categoryWeight * ((1 * upvotes) + (4 * comments) + (8 * saves) + interactionAdjustments)`

   Personal interactions can add or subtract score with the default weights:

   - `upvote`: `+1.0`
   - `commentOpen >= 3s`: `+4.0`
   - `bookmarkSave`: `+8.0`
   - `downvote`: `-10.0`
   - `quickSkip < 3s`: `-10.0`
4. `DiversityFilter`
   Applies a `0.45` attenuation factor to same-category candidates competing
   for adjacent positions, then greedily reranks the final feed to spread
   topics out.

## Core types

- `AlgorithmicCandidate`
- `UserProfile`
- `UserInteraction`
- `ScoringEngine`
- `DiversityFilter`
- `FeedRanker`

## Usage

```dart
import 'package:tikwiki_algo/tikwiki_algo.dart';

void main() {
  const profile = UserProfile(
    seenArticleIds: <String>{'rome-1'},
    categoryAffinities: <String, double>{
      'Science': 1.8,
      'History': 1.2,
      'Cooking': 0.4,
    },
  );

  final candidates = <AlgorithmicCandidate>[
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
  ];

  const ranker = FeedRanker();
  final feed = ranker.generateOptimizedFeed(
    rawPool: candidates,
    userProfile: profile,
    interactions: const <UserInteraction>[
      UserInteraction.commentOpen(
        candidateId: 'nebula-1',
        duration: Duration(seconds: 5),
      ),
    ],
  );

  print(feed.map((candidate) => candidate.title).toList());
}
```

See [example/tikwiki_algo_example.dart](example/tikwiki_algo_example.dart) for a
full runnable example.
