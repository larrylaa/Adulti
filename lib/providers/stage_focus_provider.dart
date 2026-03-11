import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StageFocus { vault, desk, shadow, watch }

final stageFocusProvider = StateProvider<StageFocus?>((ref) => null);
