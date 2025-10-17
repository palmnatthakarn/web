import '../models/barcode_item.dart';

class ProductRepository {
  Future<List<ProductItem>> fetchItems() async {
    // mock data
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(25, (i) {
      return ProductItem(
        code: 'P${(1000 + i)}',
        barcode: '${8850000000000 + i}', // Mock barcode (13 digits)
        name: i < 20 ? 'สินค้า ${i + 1}' : null,
        unit: i < 22 ? 'ชิ้น' : null,
        price: i < 23 ? 50 + i * 3.5 : null,
        stock: i < 24 ? 10 + i : null,
      );
    });
  }
}
