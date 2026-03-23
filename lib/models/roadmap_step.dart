import 'package:flutter/foundation.dart';

import 'mission.dart';

@immutable
class RoadmapStep {
  final String id;
  final String title;
  final String summary;
  final String whyItMatters;
  final String actionLabel;
  final String resourceHint;
  final MissionPriority priority;

  const RoadmapStep({
    required this.id,
    required this.title,
    required this.summary,
    required this.whyItMatters,
    required this.actionLabel,
    required this.resourceHint,
    required this.priority,
  });
}
