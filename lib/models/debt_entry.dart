import 'package:flutter/foundation.dart';

enum DebtType {
  creditCard,
  loan;

  String get displayName {
    switch (this) {
      case creditCard:
        return 'Credit Card';
      case loan:
        return 'Loan';
    }
  }
}

@immutable
class DebtEntry {
  final String id;
  final DebtType type;
  final String label;
  final double amount;

  const DebtEntry({
    required this.id,
    required this.type,
    required this.label,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.index,
    'label': label,
    'amount': amount,
  };

  factory DebtEntry.fromMap(Map<String, dynamic> map) => DebtEntry(
    id: map['id'] as String? ?? '',
    type: DebtType.values[(map['type'] as int?) ?? 0],
    label: map['label'] as String? ?? '',
    amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
  );

  DebtEntry copyWith({
    String? id,
    DebtType? type,
    String? label,
    double? amount,
  }) => DebtEntry(
    id: id ?? this.id,
    type: type ?? this.type,
    label: label ?? this.label,
    amount: amount ?? this.amount,
  );
}
