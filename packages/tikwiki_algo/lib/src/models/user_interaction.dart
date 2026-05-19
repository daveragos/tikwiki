enum UserInteractionType {
  upvote,
  commentOpen,
  bookmarkSave,
  downvote,
  quickSkip,
}

class UserInteraction {
  const UserInteraction({
    required this.candidateId,
    required this.type,
    this.duration = Duration.zero,
  });

  const UserInteraction.upvote({required String candidateId})
    : this(candidateId: candidateId, type: UserInteractionType.upvote);

  const UserInteraction.commentOpen({
    required String candidateId,
    Duration duration = Duration.zero,
  }) : this(
         candidateId: candidateId,
         type: UserInteractionType.commentOpen,
         duration: duration,
       );

  const UserInteraction.bookmarkSave({required String candidateId})
    : this(candidateId: candidateId, type: UserInteractionType.bookmarkSave);

  const UserInteraction.downvote({required String candidateId})
    : this(candidateId: candidateId, type: UserInteractionType.downvote);

  const UserInteraction.quickSkip({
    required String candidateId,
    Duration duration = Duration.zero,
  }) : this(
         candidateId: candidateId,
         type: UserInteractionType.quickSkip,
         duration: duration,
       );

  final String candidateId;
  final UserInteractionType type;
  final Duration duration;
}
