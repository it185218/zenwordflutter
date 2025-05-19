import 'package:zenwordflutter/data/model/performance.dart';

// Compute skill score using the performance from completed levels
double computeSkillScore(List<Performance> history, {int sampleSize = 5}) {
  if (history.isEmpty) return 0.0;

  final recent = history.take(sampleSize);
  double totalScore = 0;

  for (var perf in recent) {
    final accuracy = perf.completionRate;
    final speed =
        perf.durationSeconds > 0
            ? (perf.avgFoundLength / perf.durationSeconds)
            : 0;
    totalScore += (accuracy * 0.7 + speed * 0.3);
  }

  return totalScore / recent.length;
}
