import '../utils/format.dart';
import 'meetup.dart';

sealed class Countdown {
  const Countdown();

  factory Countdown.of(Meetup meetup, DateTime now) {
    if (now.isBefore(meetup.startsAt)) {
      return Upcoming(meetup.startsAt.difference(now));
    }
    if (now.isBefore(meetup.endsAt)) {
      return Started(now.difference(meetup.startsAt));
    }
    return const Ended();
  }

  String get label => switch (this) {
    Upcoming(:final left) => 'Starts in ${formatDuration(left)}',
    Started(:final ago) => 'Started ${formatDuration(ago)} ago',
    Ended() => 'Ended',
  };
}

final class Upcoming extends Countdown {
  const Upcoming(this.left);
  final Duration left;
}

final class Started extends Countdown {
  const Started(this.ago);
  final Duration ago;
}

final class Ended extends Countdown {
  const Ended();
}
