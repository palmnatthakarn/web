import '../models/barcode_item.dart';

class BarcodeRepository {
  Future<List<BarcodeItem>> fetchItems() async {
    // mock data
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(25, (i) {
      return BarcodeItem(
        code: 'P${(1000 + i)}',
        name: 'สินค้า ${i + 1}',
        unit: 'ชิ้น',
        price: 50 + i * 3.5,
        stock: 10 + i,
      );
    });
  }
}
