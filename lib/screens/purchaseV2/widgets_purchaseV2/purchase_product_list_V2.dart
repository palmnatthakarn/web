import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_web_app/component/all/enhanced_dropdown_group.dart';
import 'package:flutter_web_app/models/barcode_item.dart';
import '../../../blocs/purchase/purchase_bloc.dart';
import '../../../blocs/purchase/purchase_event.dart';
import '../../../blocs/purchase/purchase_state.dart';
import '../../../component/all/tf.dart';
import '../../../component/all/add_item_dialog.dart';
import 'package:intl/intl.dart';

class PurchaseProductList_V2 extends StatefulWidget {
  const PurchaseProductList_V2({Key? key}) : super(key: key);

  @override
  State<PurchaseProductList_V2> createState() => _PurchaseProductListState();
}

class _PurchaseProductListState extends State<PurchaseProductList_V2> {
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

  // Helper method to safely access PurchaseBloc// แก้ไขฟังก์ชัน _getPurchaseBloc
  PurchaseBloc? _getPurchaseBloc() {
    try {
      print('🔍 [DEBUG] Getting PurchaseBloc, mounted: $mounted');
      // ใช้ context.read แทน context.watch เพื่อไม่ให้ rebuild
      if (mounted) {
        final bloc = context.read<PurchaseBloc>();
        print('✅ [DEBUG] PurchaseBloc obtained successfully');
        return bloc;
      }
      print('⚠️ [DEBUG] Widget not mounted, returning null');
      return null;
    } catch (e) {
      print('❌ [DEBUG] Error getting PurchaseBloc: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return BlocBuilder<PurchaseBloc, PurchaseState>(
        builder: (context, state) {
          final cartItems = state.cartItems ?? [];
          final items = state.items ?? [];
          // Debug information
          print('=== PurchaseProductList Debug ===');
          print('cartItems length: ${cartItems.length}');
          print('cartItems isEmpty: ${cartItems.isEmpty}');
          if (cartItems.isNotEmpty) {
            print('First item: ${cartItems[0]?.product?.name}');
          }
          print('================================');
          return Column(
            children: [
              // Header with action buttons and search
              _buildHeader(context, state),

              // Product table or empty state
              Flexible(
                child: cartItems.isEmpty
                    ? _buildEmptyState(context)
                    : _buildProductTable(context, state),
              ),
              // Summary info
              // if (cartItems.isNotEmpty) _buildSummaryInfo(state),
              // Bottom actions
              //  if (cartItems.isNotEmpty) _buildBottomActions(context, state),
            ],
          );
        },
      );
    } catch (e) {
      return const Center(
        child: Text(
          'PurchaseBloc not found in context',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, PurchaseState state) {
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
                    // First row: Search and Barcode
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
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.list_alt,
                                    color: Color(0xFF10B981)),
                                onPressed: () =>
                                    _showProductSelector(context, state),
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
                    // Second row: Dropdowns and Add button
                    Row(
                      children: [
                        Expanded(
                          child: EnhancedDropdownGroup.IconinDropdownGroup(
                            icon: Icons.warehouse_outlined,
                            color: Colors.blue,
                            options: const ['คลังหลัก', 'คลังสาขา'],
                            selectedValue: 0,
                            onChanged: (value) {},
                            hint: 'คลัง',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: EnhancedDropdownGroup.IconinDropdownGroup(
                            icon: Icons.location_on_outlined,
                            color: Colors.green,
                            options: const ['ชั้น A-01', 'ชั้น B-01'],
                            selectedValue: 0,
                            onChanged: (value) {},
                            hint: 'ที่เก็บ',
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print('🔴 [DEBUG] Add button pressed (Mobile)');
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
                      ],
                    ),
                  ],
                );
              }

              // Desktop layout
              return Row(
                children: [
                  // Search Field
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
                              icon: const Icon(Icons.list_alt,
                                  color: Color(0xFF10B981)),
                              onPressed: () =>
                                  _showProductSelector(context, state),
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

                  // Warehouse Dropdown
                  Expanded(
                    flex: 1,
                    child: EnhancedDropdownGroup.IconinDropdownGroup(
                      icon: Icons.warehouse_outlined,
                      color: Colors.blue,
                      options: const ['คลังหลัก', 'คลังสาขา'],
                      selectedValue: 0,
                      onChanged: (value) {},
                      hint: 'เลือกคลัง',
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Storage Location Dropdown
                  Expanded(
                    flex: 1,
                    child: EnhancedDropdownGroup.IconinDropdownGroup(
                      icon: Icons.location_on_outlined,
                      color: Colors.green,
                      options: const ['ชั้น A-01', 'ชั้น B-01'],
                      selectedValue: 0,
                      onChanged: (value) {},
                      hint: 'เลือกที่เก็บ',
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add button
                  Tooltip(
                    message: 'เพิ่มรายการสินค้า',
                    child: ElevatedButton(
                      onPressed: () {
                        print('🔴 [DEBUG] Add button pressed (Header)');
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

// ฟังก์ชันใหม่: คืนค่า DataRow2 สำหรับ footer
  DataRow2 buildSummaryFooterRow({
    required String label,
    required String value,
    bool isAmount = false,
    bool isDiscount = false,
  }) {
    return DataRow2(
      cells: [
        const DataCell(SizedBox()), // ช่องลำดับ (เว้นว่าง)
        const DataCell(SizedBox()), // ช่องบาร์โค้ด
        DataCell(Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151),
          ),
        )),
        const DataCell(SizedBox()), // ช่องจำนวน
        const DataCell(SizedBox()), // ช่องราคาต่อหน่วย
        const DataCell(SizedBox()), // ช่องส่วนลด
        DataCell(Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isAmount
                ? const Color(0xFF10B981)
                : isDiscount
                    ? Colors.red
                    : const Color(0xFF1F2937),
          ),
        )),
        const DataCell(SizedBox()), // ช่องจัดการ
      ],
    );
  }

  Widget _buildSummaryInfo(PurchaseState state) {
    final cartItems = state.cartItems ?? [];
    final totalItems = cartItems.fold<int>(0, (sum, item) {
      if (item != null) {
        return sum + (item.quantity ?? 0);
      }
      return sum;
    });
    final totalAmount = cartItems.fold<double>(0, (sum, item) {
      if (item != null) {
        return sum + ((item.finalPrice ?? 0.0) * (item.quantity ?? 0));
      }
      return sum;
    });
    final totalDiscount = cartItems.fold<double>(0, (sum, item) {
      if (item != null) {
        return sum + (item.totalDiscountAmount ?? 0.0);
      }
      return sum;
    });

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummary(
            label: 'รวม',
            //value: '$totalItems',
            color: Colors.black,
          ),
          _buildSummaryItem(
            icon: Icons.shopping_cart,
            label: 'จำนวนสินค้า',
            value: formatInteger(totalItems),
            color: const Color(0xFF6B7280),
          ),
          _buildSummaryItem(
            icon: Icons.discount,
            label: 'ส่วนลดรวม',
            value: totalDiscount > 0
                ? '${formatNumber(totalDiscount)}฿'
                : '-',
            color: totalDiscount > 0 ? Colors.red : const Color(0xFF9CA3AF),
          ),
          _buildSummaryItem(
            icon: Icons.attach_money,
            label: 'ยอดรวม',
            value: '${formatNumber(totalAmount)}฿',
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary({
    required String label,
    // required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icon(icon, color: color, size: 20),
          // const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.bold,
                ),
              ),

              /*Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),*/
            ],
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
              print('🔴 [DEBUG] Add first item button pressed (Empty state)');
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

  Widget _buildProductTable(BuildContext context, PurchaseState state) {
    final cartItems = state.cartItems ?? [];
    // Debug: แสดงจำนวน items
    print('Building table with ${cartItems.length} items');
    if (cartItems.isEmpty) {
      return _buildEmptyState(context);
    }
    // คำนวณยอดรวม
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
          // ตารางสินค้า
          Expanded(
            flex: 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12), // ✅ มุมบนโค้งมน
                ),
              ),
              clipBehavior: Clip.antiAlias, // ให้ตัดตามขอบโค้ง
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
                  // DataColumn2(label: Text('จัดการ'), size: ColumnSize.M),
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

                  String discountText = '-';
                  if (discount > 0) {
                    discountText = isPercentage
                        ? '${discount.toStringAsFixed(1)}%'
                        : '${discount.toStringAsFixed(2)}฿';
                  }

                  return DataRow2(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (index % 2 == 0) {
                          return Colors.grey.withOpacity(0.05);
                        }
                        return null; // Use default color for odd rows
                      },
                    ),
                    onSecondaryTapDown: (details) => _showDeleteConfirmation(
                        context,
                        index,
                        cartItem.product?.name ?? 'ไม่ระบุชื่อ'),
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
                          alignment:
                              Alignment.centerRight, // บังคับให้เนื้อหาอยู่ขวา
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
                      // DataCell(_buildActionButtons(context, index, cartItem)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Spacer(),
          // Footer: แสดงผลรวม
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
                  crossAxisAlignment: CrossAxisAlignment.start, // ✅ ชิดซ้าย
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

  Widget _buildActionButtons(
      BuildContext context, int index, CartItem cartItem) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 18, color: Color(0xFF10B981)),
          onPressed: () => _showEditItemDialog(context, index, cartItem),
          tooltip: 'แก้ไข',
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(
              context, index, cartItem.product?.name ?? 'ไม่ระบุชื่อ'),
          tooltip: 'ลบ',
        ),
      ],
    );
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

  void _showProductSelector(BuildContext context, PurchaseState state) {
    // Show product selector dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกสินค้า'),
        content: const SizedBox(
          width: 400,
          height: 300,
          child:
              Center(child: Text('Product selector will be implemented here')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
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
        customContent: StatefulBuilder(
          builder: (context, setState) {
            bool isPercentageDiscount = false;
            final discountController = TextEditingController(text: '0');

            return _buildDiscountField(
              discountController,
              isPercentageDiscount,
              (value) {
                setState(() {
                  isPercentageDiscount = value;
                });
              },
            );
          },
        ),
        onSave: (values) async {
          final discount = double.tryParse(values['discount'] ?? '0') ?? 0.0;
          final newProduct = ProductItem(
            code: (values['code'] ?? '').trim(),
            barcode: (values['barcode'] ?? '').trim(),
            name: (values['name'] ?? '').trim(),
            unit: (values['unit'] ?? 'ชิ้น').trim(),
            price: double.tryParse(values['price'] ?? '0') ?? 0.0,
            stock: 999,
          );
          final quantity = int.tryParse(values['quantity'] ?? '1') ?? 1;

          final bloc = _getPurchaseBloc();
          if (bloc != null) {
            bloc.add(PurchaseItemAdded(newProduct, quantity));

            if (discount > 0) {
              Future.delayed(const Duration(milliseconds: 200), () {
                final updatedState = bloc.state;
                final cartLength = updatedState.cartItems.length;
                if (cartLength > 0) {
                  final newIndex = cartLength - 1;
                  bloc.add(PurchaseDiscountChanged(
                    index: newIndex,
                    discount: discount,
                    isPercentageDiscount: false,
                  ));
                }
              });
            }
          }
        },
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, int index, CartItem cartItem) {
    final product = cartItem.product ?? ProductItem(code: '');
    if (product.code.isEmpty) return;

    final formKey = GlobalKey<FormState>();
    final controllers = {
      'barcode': TextEditingController(text: product.barcode ?? ''),
      'code': TextEditingController(text: product.code ?? ''),
      'name': TextEditingController(text: product.name ?? ''),
      'unit': TextEditingController(text: product.unit ?? 'ชิ้น'),
      'quantity':
          TextEditingController(text: (cartItem.quantity ?? 1).toString()),
      'price': TextEditingController(text: (product.price ?? 0.0).toString()),
      'discount':
          TextEditingController(text: (cartItem.discount ?? 0.0).toString()),
    };

    bool isPercentageDiscount = cartItem.isPercentageDiscount ?? false;

    void disposeEditControllers() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var controller in controllers.values) {
          try {
            controller.dispose();
          } catch (e) {
            // Controller already disposed, ignore
          }
        }
      });
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              SizedBox(width: 8),
              Text('แก้ไขรายการ'),
              SizedBox(width: 5),
              Icon(Icons.edit, color: Colors.black),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                             child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 40,
                              child: TextFieldBuilder.readOnlyTextField(
                                labelText: 'บาร์โค้ด',
                                value: (controllers['barcode'] ?? TextEditingController()).text,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 40,
                              child: TextFieldBuilder.readOnlyTextField(
                                labelText: 'รหัสสินค้า',
                                value: (controllers['code'] ?? TextEditingController()).text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFieldBuilder.simpleTf(
                        labelText: 'ชื่อสินค้า',
                        controller:
                            controllers['name'] ?? TextEditingController()),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldBuilder.simpleTf(
                              labelText: 'จำนวน',
                              controller: controllers['quantity'] ??
                                  TextEditingController()),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextFieldBuilder.simpleTf(
                                labelText: 'หน่วยนับ',
                                controller: controllers['unit'] ??
                                    TextEditingController())),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFieldBuilder.simpleTf(
                        labelText: 'ราคา',
                        controller:
                            controllers['price'] ?? TextEditingController()),
                    const SizedBox(height: 16),
                    _buildDiscountField(
                        controllers['discount'] ?? TextEditingController(),
                        isPercentageDiscount, (value) {
                      setState(() {
                        isPercentageDiscount = value;
                      });
                    }),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                disposeEditControllers();
              },
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  try {
                    final updatedProduct = ProductItem(
                      code: controllers['code']?.text.trim() ?? '',
                      barcode: controllers['barcode']?.text.trim() ?? '',
                      name: controllers['name']?.text.trim() ?? '',
                      price:
                          double.tryParse(controllers['price']?.text ?? '0') ??
                              0.0,
                      unit: controllers['unit']?.text.trim() ?? 'ชิ้น',
                      stock: product.stock ?? 999,
                    );
                    final quantity =
                        int.tryParse(controllers['quantity']?.text ?? '1') ?? 1;
                    final discount =
                        double.tryParse(controllers['discount']?.text ?? '0') ??
                            0.0;

                    final bloc = _getPurchaseBloc();
                    if (bloc != null) {
                      bloc.add(PurchaseItemUpdated(index, updatedProduct));
                      bloc.add(PurchaseQuantityChanged(index, quantity));
                      bloc.add(PurchaseDiscountChanged(
                        index: index,
                        discount: discount,
                        isPercentageDiscount: isPercentageDiscount,
                      ));
                    }
                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('แก้ไขรายการสำเร็จ'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );

                    disposeEditControllers();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เกิดข้อผิดพลาด: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    disposeEditControllers();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, int index, String itemName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบรายการ "$itemName" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                final bloc = _getPurchaseBloc();
                if (bloc != null) {
                  bloc.add(PurchaseItemRemoved(index));
                }
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ลบรายการสำเร็จ'),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เกิดข้อผิดพลาด: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }
  }

  Widget _buildDiscountField(TextEditingController controller,
      bool isPercentage, Function(bool) onTypeChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ],
                    decoration: InputDecoration(
                      labelText: 'ส่วนลด',
                      suffixText: isPercentage ? '%' : '฿',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ToggleButtons(
                  isSelected: [!isPercentage, isPercentage],
                  onPressed: (index) => onTypeChanged(index == 1),
                  borderRadius: BorderRadius.circular(8),
                  constraints:
                      const BoxConstraints(minWidth: 60, minHeight: 40),
                  children: const [
                    Text('฿'),
                    Text('%'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

