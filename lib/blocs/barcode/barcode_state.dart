import '../../models/barcode_item.dart';

enum BarcodeStatus { initial, loading, loaded, failure }

class BarcodeState {
  final BarcodeStatus status;
  final List<BarcodeItem> items;
  final String query;
  final double leftPanelWidth;
  final double minPanelWidth;
  final double maxPanelWidth;
  final BarcodeItem? selected;
  final int productTypeGroup; // 1,2,3
  final int produceGroup; // 1,2
  final String? error;

  const BarcodeState({
    this.status = BarcodeStatus.initial,
    this.items = const [],
    this.query = '',
    this.leftPanelWidth = 0, // 0 means use responsive calculation
    this.minPanelWidth = 300,
    this.maxPanelWidth = 600,
    this.selected,
    this.productTypeGroup = 1,
    this.produceGroup = 1,
    this.error,
  });

  List<BarcodeItem> get filtered {
    if (query.trim().isEmpty) return items;
    final q = query.trim().toLowerCase();
    return items
        .where((e) =>
            e.code.toLowerCase().contains(q) ||
            (e.name?.toLowerCase() ?? '').contains(q))
        .toList();
  }

  BarcodeState copyWith({
    BarcodeStatus? status,
    List<BarcodeItem>? items,
    String? query,
    double? leftPanelWidth,
    double? minPanelWidth,
    double? maxPanelWidth,
    BarcodeItem? selected,
    int? productTypeGroup,
    int? produceGroup,
    String? error,
    bool clearSelected = false,
  }) {
    return BarcodeState(
      status: status ?? this.status,
      items: items ?? this.items,
      query: query ?? this.query,
      leftPanelWidth: leftPanelWidth ?? this.leftPanelWidth,
      minPanelWidth: minPanelWidth ?? this.minPanelWidth,
      maxPanelWidth: maxPanelWidth ?? this.maxPanelWidth,
      selected: clearSelected ? null : (selected ?? this.selected),
      productTypeGroup: productTypeGroup ?? this.productTypeGroup,
      produceGroup: produceGroup ?? this.produceGroup,
      error: error,
    );
  }
}
