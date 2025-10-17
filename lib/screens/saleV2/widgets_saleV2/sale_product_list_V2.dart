import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/component/all/enhanced_dropdown_group.dart';
import 'package:flutter_web_app/models/barcode_item.dart';
import '../../../blocs/sale/sale_bloc.dart';
import '../../../blocs/sale/sale_event.dart';
import '../../../blocs/sale/sale_state.dart';
import '../../../component/all/tf.dart';
import '../../../component/all/add_item_dialog.dart';
import '../../../component/all/edit_item_dialog.dart';
import 'package:intl/intl.dart';

class SaleProductListV2 extends StatefulWidget {
  const SaleProductListV2({Key? key}) : super(key: key);

  @override
  State<SaleProductListV2> createState() => _SaleProductListState();
}

class _SaleProductListState extends State<SaleProductListV2> {
  final _searchController = TextEditingController();
  final _barcodeController = TextEditingController();
  
  // ฟังก์ชันจัดรูปแบบตัวเลขด้วยเครื่องหมายจุลภาค
  String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(number);
  }
  
  String formatInteger(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  @override
  void dispose() {
    try {
      _searchController.dispose();
    } catch (e) {
      // Controller already disposed
    }
    try {
      _barcodeController.dispose();
    } catch (e) {
      // Controller already disposed
    }
    super.dispose();
  }

  SaleBloc? _getSaleBloc() {
    try {
      if (mounted) {
        final bloc = context.read<SaleBloc>();
        return bloc;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          final cartItems = state.cartItems ?? [];
          return Column(
            children: [
              _buildHeader(context, state),
              Flexible(
                child: cartItems.isEmpty
                    ? _buildEmptyState(context)
                    : _buildProductTable(context, state),
              ),
            ],
          );
        },
      );
    } catch (e) {
      return const Center(
        child: Text(
          'SaleBloc not found in context',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, SaleState state) {
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;

              if (isMobile) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'ค้นหาสินค้า...',
                              prefixIcon: const Icon(Icons.search,
                                  color: Color(0xFF6B7280)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFF10B981)),
                              ),
                            ),
                            onChanged: (value) {
                              final bloc = _getSaleBloc();
                              if (bloc != null) {
                                bloc.add(SaleSearchChanged(value));
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _barcodeController,
                            decoration: InputDecoration(
                              hintText: 'บาร์โค้ด',
                              prefixIcon: const Icon(Icons.qr_code_scanner,
                                  color: Color(0xFF6B7280)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFF10B981)),
                              ),
                            ),
                            onSubmitted: (value) => _handleBarcodeAdd(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _showAddNewItemDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.add, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาสินค้าด้วยชื่อหรือรหัส...',
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF6B7280)),
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
                          borderSide:
                              const BorderSide(color: Color(0xFF10B981)),
                        ),
                      ),
                      onChanged: (value) {
                        final bloc = _getSaleBloc();
                        if (bloc != null) {
                          bloc.add(SaleSearchChanged(value));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        hintText: 'สแกนบาร์โค้ด...',
                        prefixIcon: const Icon(Icons.qr_code_scanner,
                            color: Color(0xFF6B7280)),
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
                          borderSide:
                              const BorderSide(color: Color(0xFF10B981)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Color(0xFF10B981)),
                          onPressed: () => _handleBarcodeAdd(),
                          tooltip: 'เพิ่มด้วยบาร์โค้ด',
                        ),
                      ),
                      onSubmitted: (value) => _handleBarcodeAdd(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Tooltip(
                    message: 'เพิ่มรายการสินค้า',
                    child: ElevatedButton(
                      onPressed: () {
                        _showAddNewItemDialog(context);
                      },
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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'ยังไม่มีรายการสินค้า',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'เพิ่มสินค้าด้วยการค้นหา สแกนบาร์โค้ด หรือเพิ่มรายการใหม่',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showAddNewItemDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('เพิ่มรายการแรก'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTable(BuildContext context, SaleState state) {
    final cartItems = state.cartItems ?? [];
    if (cartItems.isEmpty) {
      return _buildEmptyState(context);
    }

    double grandTotal = 0;
    double totalDiscount = 0;

    for (var item in cartItems) {
      if (item?.product != null) {
        final qty = item?.quantity ?? 1;
        final price = item?.product?.price ?? 0.0;
        final discount = item?.discount ?? 0.0;
        final isPercentage = item?.isPercentageDiscount ?? false;

        final finalPrice = item?.finalPrice ?? price;
        grandTotal += finalPrice * qty;
        totalDiscount +=
            isPercentage ? (price * qty * discount / 100) : discount;
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: DataTable2(
                columnSpacing: 5,
                horizontalMargin: 30,
                minWidth: 600,
                headingRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 217, 236, 254)),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
                columns: const [
                  DataColumn2(
                      label: Center(child: Text('ลำดับ')), size: ColumnSize.S),
                  DataColumn2(
                      label: Center(child: Text('บาร์โค้ด')),
                      size: ColumnSize.S),
                  DataColumn2(
                      label: Center(child: Text('รายละเอียดสินค้า')),
                      size: ColumnSize.L),
                  DataColumn2(
                      label: Center(child: Text('จำนวน')), size: ColumnSize.S),
                  DataColumn2(
                      label: Center(child: Text('ราคา')), size: ColumnSize.S),
                  DataColumn2(
                      label: Center(child: Text('ส่วนลด')), size: ColumnSize.S),
                  DataColumn2(
                      label: Center(child: Text('ราคารวม')),
                      size: ColumnSize.M),
                ],
                rows: cartItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final cartItem = entry.value;

                  if (cartItem == null || cartItem.product == null) {
                    return DataRow2(
                      cells: List.generate(7, (i) => const DataCell(Text('-'))),
                    );
                  }

                  final product = cartItem.product ?? ProductItem(code: '');
                  final quantity = cartItem.quantity ?? 1;
                  final price = product.price ?? 0.0;
                  final discount = cartItem.discount ?? 0.0;
                  final isPercentage = cartItem.isPercentageDiscount ?? false;
                  final finalPrice = cartItem.finalPrice ?? price;
                  final total = finalPrice * quantity;

                  return DataRow2(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (index % 2 == 0) {
                          return Colors.grey.withOpacity(0.05);
                        }
                        return null;
                      },
                    ),
                    onTap: () {
                      _showEditItemDialog(context, index, cartItem);
                    },
                    cells: [
                      DataCell(Center(child: Text('${index + 1}'))),
                      DataCell(Center(child: Text(product.barcode ?? '-'))),
                      DataCell(Text(
                          '${product.code ?? '-'}  ${product.name ?? '-'}')),
                      DataCell(
                        Center(
                            child: Text('${formatInteger(quantity)} ${product.unit ?? 'ชิ้น'}')),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('${formatNumber(price)}฿'),
                        ),
                      ),
                      DataCell(Center(
                        child: Text(
                          discount > 0 ? (isPercentage
                              ? '${formatNumber(discount)}%'
                              : '${formatNumber(discount)}฿') : '-',
                          style: TextStyle(
                            color: discount > 0 ? Colors.red : Colors.grey,
                            fontWeight: discount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      )),
                      DataCell(Center(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${formatNumber(total)}฿',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รวมทั้งหมด: ${cartItems.length} รายการ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    if (totalDiscount > 0)
                      Text('ส่วนลดรวม: ${formatNumber(totalDiscount)} บาท',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent,
                          )),
                  ],
                ),
                Text(
                  'ยอดรวม: ${formatNumber(grandTotal)} บาท',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleBarcodeAdd() {
    final barcode = _barcodeController.text.trim();
    if (barcode.isNotEmpty) {
      final bloc = _getSaleBloc();
      if (bloc != null) {
        bloc.add(SaleBarcodeScanned(barcode));
      }
      _barcodeController.clear();
    }
  }

  void _showAddNewItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: 'เพิ่มรายการใหม่',
        fields: [
          AddItemField.row(
            key: 'row1',
            fields: [
              AddItemField(key: 'barcode', label: 'บาร์โค้ด', flex: 2),
              AddItemField(key: 'code', label: 'รหัสสินค้า', flex: 2),
            ],
          ),
          AddItemField(
            key: 'name',
            label: 'ชื่อสินค้า',
            validator: (v) => v?.isEmpty == true ? 'กรุณากรอกชื่อสินค้า' : null,
          ),
          AddItemField.row(
            key: 'row2',
            fields: [
              AddItemField(
                key: 'quantity',
                label: 'จำนวน',
                defaultValue: '1',
                keyboardType: TextInputType.number,
                validator: (v) => v?.isEmpty == true ? 'กรุณากรอกจำนวน' : null,
              ),
              AddItemField(
                key: 'unit',
                label: 'หน่วยนับ',
                defaultValue: 'ชิ้น',
              ),
            ],
          ),
          AddItemField(
            key: 'price',
            label: 'ราคา',
            keyboardType: TextInputType.number,
            validator: (v) => v?.isEmpty == true ? 'กรุณากรอกราคา' : null,
          ),
        ],
        onSave: (values) async {
          final newProduct = ProductItem(
            code: (values['code'] ?? '').trim(),
            barcode: (values['barcode'] ?? '').trim(),
            name: (values['name'] ?? '').trim(),
            unit: (values['unit'] ?? 'ชิ้น').trim(),
            price: double.tryParse(values['price'] ?? '0') ?? 0.0,
            stock: 999,
          );
          final quantity = int.tryParse(values['quantity'] ?? '1') ?? 1;

          final bloc = _getSaleBloc();
          if (bloc != null) {
            bloc.add(SaleItemAdded(newProduct, quantity));
          }
        },
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, int index, CartItem cartItem) {
    // Implementation similar to purchase edit dialog
    // Using existing EditItemDialog component
  }
}