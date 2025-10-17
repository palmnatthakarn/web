import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/purchase/purchase_bloc.dart';
import '../../../blocs/purchase/purchase_event.dart';
import '../../../blocs/purchase/purchase_state.dart';

class PurchaseHeader extends StatefulWidget {
  final Function() onAddNewItem;
  final Function(BuildContext, PurchaseState) onProductSelector;
  
  const PurchaseHeader({
    Key? key,
    required this.onAddNewItem,
    required this.onProductSelector,
  }) : super(key: key);

  @override
  State<PurchaseHeader> createState() => _PurchaseHeaderState();
}

class _PurchaseHeaderState extends State<PurchaseHeader> {
  final _searchController = TextEditingController();
  final _barcodeController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  PurchaseBloc? _getPurchaseBloc() {
    try {
      return context.read<PurchaseBloc>();
    } catch (e) {
      return null;
    }
  }

  void _handleBarcodeAdd() {
    final barcode = _barcodeController.text.trim();
    if (barcode.isNotEmpty) {
      final bloc = _getPurchaseBloc();
      if (bloc != null) {
        bloc.add(PurchaseBarcodeScanned(barcode));
      }
      _barcodeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Search Field
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาสินค้าด้วยชื่อหรือรหัส...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF10B981)),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  final bloc = _getPurchaseBloc();
                                  if (bloc != null) {
                                    bloc.add(const PurchaseSearchChanged(''));
                                  }
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.list_alt, color: Color(0xFF10B981)),
                              onPressed: () => widget.onProductSelector(context, state),
                              tooltip: 'เลือกจากรายการสินค้า',
                            ),
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        final bloc = _getPurchaseBloc();
                        if (bloc != null) {
                          bloc.add(PurchaseSearchChanged(value));
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Barcode Field
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        hintText: 'สแกนบาร์โค้ด...',
                        prefixIcon: const Icon(Icons.qr_code_scanner, color: Color(0xFF6B7280)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF10B981)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_circle, color: Color(0xFF10B981)),
                          onPressed: _handleBarcodeAdd,
                          tooltip: 'เพิ่มด้วยบาร์โค้ด',
                        ),
                      ),
                      onSubmitted: (value) => _handleBarcodeAdd(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add button
                  Tooltip(
                    message: 'เพิ่มรายการสินค้า',
                    child: ElevatedButton(
                      onPressed: widget.onAddNewItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}