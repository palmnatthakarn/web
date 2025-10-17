class BarcodeItem {
  final String code;
  final String? name;
  final String? unit;
  final double? price;
  final int? stock;

  const BarcodeItem({
    required this.code,
    this.name,
    this.unit,
    this.price,
    this.stock,
  });
}

class ProductItem {
  final String code;
  final String? barcode;
  final String? name;
  final String? unit;
  final double? price;
  final int? stock;

  const ProductItem({
    required this.code,
    this.barcode,
    this.name,
    this.unit,
    this.price,
    this.stock,
  });
}
