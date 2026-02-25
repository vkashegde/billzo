import 'package:equatable/equatable.dart';

class LineItem extends Equatable {
  final String id;
  final String description;
  final int quantity;
  final double unitPrice;

  const LineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  LineItem copyWith({
    String? id,
    String? description,
    int? quantity,
    double? unitPrice,
  }) {
    return LineItem(
      id: id ?? this.id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [id, description, quantity, unitPrice];
}
