import 'package:hive/hive.dart';

import '../../domain/entities/line_item.dart';

class LineItemModel {
  String id;
  String description;
  int quantity;
  double unitPrice;

  LineItemModel({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  factory LineItemModel.fromEntity(LineItem item) => LineItemModel(
    id: item.id,
    description: item.description,
    quantity: item.quantity,
    unitPrice: item.unitPrice,
  );

  LineItem toEntity() => LineItem(
    id: id,
    description: description,
    quantity: quantity,
    unitPrice: unitPrice,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'quantity': quantity,
    'unit_price': unitPrice,
  };

  factory LineItemModel.fromJson(Map<String, dynamic> json) => LineItemModel(
    id: json['id'] as String,
    description: json['description'] as String,
    quantity: json['quantity'] as int,
    unitPrice: (json['unit_price'] as num).toDouble(),
  );
}

class LineItemModelAdapter extends TypeAdapter<LineItemModel> {
  @override
  final int typeId = 2;

  @override
  LineItemModel read(BinaryReader reader) {
    return LineItemModel(
      id: reader.readString(),
      description: reader.readString(),
      quantity: reader.readInt(),
      unitPrice: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, LineItemModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.description);
    writer.writeInt(obj.quantity);
    writer.writeDouble(obj.unitPrice);
  }
}
