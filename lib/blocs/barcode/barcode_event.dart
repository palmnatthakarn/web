import '../../models/barcode_item.dart';

abstract class BarcodeEvent {
  const BarcodeEvent();
}

class BarcodeInitialized extends BarcodeEvent {
  const BarcodeInitialized();
}

class BarcodeSearchChanged extends BarcodeEvent {
  final String query;
  const BarcodeSearchChanged(this.query);
}

class BarcodeLeftPanelDragged extends BarcodeEvent {
  final double dx;
  const BarcodeLeftPanelDragged(this.dx);
}

class BarcodeItemSelected extends BarcodeEvent {
  final BarcodeItem item;
  const BarcodeItemSelected(this.item);
}

class BarcodeProductTypeChanged extends BarcodeEvent {
  final int value; // 1 ปกติ, 2 ส่วนผสม, 3 บริการ
  const BarcodeProductTypeChanged(this.value);
}

class BarcodeProduceTypeChanged extends BarcodeEvent {
  final int value; // 1 มีการผลิต, 2 ไม่มีการผลิต
  const BarcodeProduceTypeChanged(this.value);
}
