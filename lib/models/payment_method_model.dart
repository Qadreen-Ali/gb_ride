class PaymentMethodModel {
  final String id;
  final String userId;
  final String type; // 'card', 'wallet', 'cash', 'bank_transfer'
  final String? cardLast4;
  final String? bankName;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    this.cardLast4,
    this.bankName,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert JSON from Supabase to PaymentMethodModel
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? 'cash',
      cardLast4: json['card_last4'],
      bankName: json['bank_name'],
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert PaymentMethodModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'card_last4': cardLast4,
      'bank_name': bankName,
      'is_default': isDefault,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with method for updates
  PaymentMethodModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? cardLast4,
    String? bankName,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      cardLast4: cardLast4 ?? this.cardLast4,
      bankName: bankName ?? this.bankName,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper to get display name
  String getDisplayName() {
    switch (type) {
      case 'card':
        return 'Card •••• $cardLast4';
      case 'bank_transfer':
        return '$bankName Transfer';
      case 'wallet':
        return 'Wallet';
      case 'cash':
        return 'Cash';
      default:
        return type;
    }
  }

  @override
  String toString() =>
      'PaymentMethodModel(id: $id, type: $type, isDefault: $isDefault)';
}
