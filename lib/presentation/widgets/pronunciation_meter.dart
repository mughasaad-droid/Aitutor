import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PronunciationMeter extends StatelessWidget {
  final double score;
  final String feedback;

  const PronunciationMeter({
    super.key,
    required this.score,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getScoreColor(score);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 36,
            lineWidth: 5,
            percent: score / 10,
            center: Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            progressColor: color,
            backgroundColor: color.withOpacity(0.15),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pronunciation Score',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feedback,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    if (score >= 4) return Colors.deepOrange;
    return Colors.red;
  }
}
