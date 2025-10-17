import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_web_app/models/barcode_item.dart';
import '../../../blocs/purchase/purchase_bloc.dart';
import '../../../blocs/purchase/purchase_event.dart';
import '../../../blocs/purchase/purchase_state.dart';
import '../../../component/all/tf.dart';
import 'purchase_header.dart';

class PurchaseProductList extends StatefulWidget {
  const PurchaseProductList({Key? key}) : super(key: key);

  @override
  State<PurchaseProductList> createState() => _PurchaseProductListState();
}

class _PurchaseProductListState extends State<PurchaseProductList> {

  // Helper method to safely access PurchaseBloc
  PurchaseBloc? _getPurchaseBloc() {
    try {
      return context.read<PurchaseBloc>();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return BlocBuilder<PurchaseBloc, PurchaseState>(
        builder: (context, state) {
          if (state == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = state.cartItems ?? [];
          final items = state.items ?? [];

          return Column(
            children: [
              // Header with action buttons and search
              PurchaseHeader(
                onAddNewItem: () => _showAddNewItemDialog(context),
                onProductSelector: _showProductSelector,
              ),

              // Summary info
              if (cartItems.isNotEmpty) _buildSummaryInfo(state),

              // Product table or empty state
              Expanded(
                child: cartItems.isEmpty
                    ? _buildEmptyState(context)
                    : _buildProductTable(context, state),
              ),

              // Bottom actions
              if (cartItems.isNotEmpty) _buildBottomActions(context, state),
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



  Widget _buildSummaryInfo(PurchaseState state) {
    final cartItems = state.cartItems ?? [];
    final totalItems =
        cartItems.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
    final totalAmount = cartItems.fold<double>(
        0, (sum, item) => sum + (item.finalPrice * (item.quantity ?? 0)));
    final totalDiscount = cartItems.fold<double>(
        0, (sum, item) => sum + item.totalDiscountAmount);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
              'จำนวนรายการ', '${cartItems.length}', Icons.inventory),
          _buildSummaryItem('จำนวนสินค้า', '$totalItems', Icons.shopping_cart),
          if (totalDiscount > 0)
            _buildSummaryItem('ส่วนลดรวม',
                '${totalDiscount.toStringAsFixed(2)}฿', Icons.discount,
                isDiscount: true),
          _buildSummaryItem('ยอดรวม', '${totalAmount.toStringAsFixed(2)}฿',
              Icons.attach_money,
              isAmount: true),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon,
      {bool isAmount = false, bool isDiscount = false}) {
    return Row(
      children: [
        Icon(icon,
            color: isAmount
                ? const Color(0xFF10B981)
                : isDiscount
                    ? Colors.red
                    : const Color(0xFF6B7280),
            size: 20),
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
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAmount
                    ? const Color(0xFF10B981)
                    : isDiscount
                        ? Colors.red
                        : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
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
            onPressed: () => _showAddNewItemDialog(context),
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
    child: DataTable2(
      columnSpacing: 8,
      horizontalMargin: 30,
      minWidth: 600,
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
      columns: const [
        DataColumn2(label: Text('ลำดับ'), size: ColumnSize.S),
        DataColumn2(label: Text('บาร์โค้ด'), size: ColumnSize.M),
        DataColumn2(label: Text('รายละเอียดสินค้า'), size: ColumnSize.M),
        DataColumn2(label: Text('จำนวน'), size: ColumnSize.M),
        DataColumn2(label: Text('ราคาต่อหน่วย'), size: ColumnSize.M),
        DataColumn2(label: Text('ส่วนลด'), size: ColumnSize.M),
        DataColumn2(label: Text('ราคารวม'), size: ColumnSize.M),
        DataColumn2(label: Text('จัดการ'), size: ColumnSize.M),
      ],
      rows: cartItems.asMap().entries.map((entry) {
        final index = entry.key;
        final cartItem = entry.value;

        // แถวว่าง: ต้องมี 8 cell เท่าหัวตาราง
        if (cartItem == null || cartItem.product == null) {
          return DataRow2(
            cells: List.generate(8, (i) => const DataCell(Text('-'))),
          );
        }

        final product = cartItem.product!;
        final quantity = cartItem.quantity ?? 1;
        final price = product.price ?? 0.0;
        final discount = cartItem.discount ?? 0.0;
        final isPercentage = cartItem.isPercentageDiscount ?? false;
        final finalPrice = cartItem.finalPrice;
        final total = finalPrice * quantity;

        String discountText = '-';
        if (discount > 0) {
          discountText = isPercentage 
            ? '${discount.toStringAsFixed(1)}%' 
            : '${discount.toStringAsFixed(2)}฿';
        }

        // จำนวน cell ต้อง = 8 ตาม columns ที่กำหนดไว้
        return DataRow2(
          cells: [
            DataCell(Text('${index + 1}')), // ลำดับ
            DataCell(Text(product.barcode ?? '-')), // บาร์โค้ด
            DataCell(Text('${product.code ?? '-'} ${product.name ?? '-'}')), // รายละเอียดสินค้า
            DataCell(Text('$quantity ${product.unit ?? 'ชิ้น'}')), // จำนวน (รวมหน่วย)
            DataCell(Text('${price.toStringAsFixed(2)}฿')), // ราคาต่อหน่วย
            DataCell(
              Text(
                discountText, // ส่วนลด
                style: TextStyle(
                  color: discount > 0 ? Colors.red : Colors.grey,
                  fontWeight: discount > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              )
            ),
            DataCell(
              Text(
                '${total.toStringAsFixed(2)}฿',
                style: const TextStyle(fontWeight: FontWeight.w600),
              )
            ), // ราคารวม
            DataCell(_buildActionButtons(context, index, cartItem)), // จัดการ
          ],
        );
      }).toList(),
    ),
  );
}

  Widget _buildQuantityControls(
    BuildContext context, {
    int? index,
    required int quantity,
    void Function(int)? onChanged,
  }) {
    void _handleChange(int newQty) {
      if (index != null) {
        final bloc = _getPurchaseBloc();
        if (bloc != null) {
          bloc.add(PurchaseQuantityChanged(index, newQty));
        }
      } else {
        if (onChanged != null) onChanged(newQty);
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: quantity > 1 ? () => _handleChange(quantity - 1) : null,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.remove,
                size: 16,
                color: quantity > 1
                    ? const Color(0xFF6B7280)
                    : Colors.grey.shade400,
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          InkWell(
            onTap: () => _handleChange(quantity + 1),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.add,
                size: 16,
                color: Color(0xFF6B7280),
              ),
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

  Widget _buildBottomActions(BuildContext context, PurchaseState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => _showClearAllConfirmation(context),
            icon: const Icon(Icons.clear_all, color: Colors.red),
            label:
                const Text('ล้างทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Save as draft functionality
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('บันทึกร่าง'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Process purchase functionality
                },
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('ดำเนินการซื้อ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
    final formKey = GlobalKey<FormState>();
    final controllers = {
      'barcode': TextEditingController(),
      'code': TextEditingController(),
      'name': TextEditingController(),
      'unit': TextEditingController(text: 'ชิ้น'),
      'quantity': TextEditingController(text: '1'),
      'price': TextEditingController(),
      'discount': TextEditingController(text: '0'),
    };

    bool isPercentageDiscount = false;

    void disposeControllers() {
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
          title: const Text('เพิ่มรายการใหม่'),
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
                          child: TextFieldBuilder.simpleTf(
                              labelText: 'บาร์โค้ด', controller: controllers['barcode']!),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFieldBuilder.simpleTf(
                              labelText: 'รหัสสินค้า', controller: controllers['code']!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFieldBuilder.simpleTf(
                        labelText: 'ชื่อสินค้า', controller: controllers['name']!),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldBuilder.simpleTf(
                              labelText: 'จำนวน', controller: controllers['quantity']!),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextFieldBuilder.simpleTf(
                                labelText: 'หน่วยนับ', controller: controllers['unit']!)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFieldBuilder.simpleTf(
                        labelText: 'ราคาต่อหน่วย', controller: controllers['price']!),
                    const SizedBox(height: 16),
                    _buildDiscountField(
                        controllers['discount']!, isPercentageDiscount,
                        (value) {
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
                disposeControllers();
              },
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  try {
                    final newProduct = ProductItem(
                      code: controllers['code']!.text.trim(),
                      barcode: controllers['barcode']!.text.trim(),
                      name: controllers['name']!.text.trim(),
                      unit: controllers['unit']!.text.trim(),
                      price: double.tryParse(controllers['price']!.text) ?? 0.0,
                      stock: 999,
                    );
                    final quantity =
                        int.tryParse(controllers['quantity']!.text) ?? 1;
                    final discount =
                        double.tryParse(controllers['discount']!.text) ?? 0.0;

                    final bloc = _getPurchaseBloc();
                    if (bloc != null) {
                      bloc.add(PurchaseItemAdded(newProduct, quantity));

                      // เพิ่มส่วนลดถ้ามี
                      if (discount > 0) {
                        // หา index ของรายการที่เพิ่งเพิ่ม (รายการสุดท้าย)
                        final currentState = bloc.state;
                        final lastIndex =
                            (currentState.cartItems?.length ?? 1) - 1;

                        bloc.add(PurchaseDiscountChanged(
                          index: lastIndex,
                          discount: discount,
                          isPercentageDiscount: isPercentageDiscount,
                        ));
                      }
                    }
                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('เพิ่มรายการสำเร็จ'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );

                    disposeControllers();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เกิดข้อผิดพลาด: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    disposeControllers();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: const Text('เพิ่ม'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, int index, CartItem cartItem) {
    if (cartItem.product == null) return;

    final formKey = GlobalKey<FormState>();
    final product = cartItem.product!;
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
                          child: _buildReadOnlyTextField(
                            'บาร์โค้ด',
                            controllers['barcode']!,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _buildReadOnlyTextField(
                            'รหัสสินค้า',
                            controllers['code']!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFieldBuilder.simpleTf(
                        labelText: 'ชื่อสินค้า', controller: controllers['name']!),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldBuilder.simpleTf(
                              labelText: 'จำนวน', controller: controllers['quantity']!),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextFieldBuilder.simpleTf(
                                labelText: 'หน่วยนับ', controller: controllers['unit']!)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFieldBuilder.simpleTf(
                        labelText: 'ราคาต่อหน่วย', controller: controllers['price']!),
                    const SizedBox(height: 16),
                    _buildDiscountField(
                        controllers['discount']!, isPercentageDiscount,
                        (value) {
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
                      code: controllers['code']!.text.trim(),
                      barcode: controllers['barcode']!.text.trim(),
                      name: controllers['name']!.text.trim(),
                      price: double.tryParse(controllers['price']!.text) ?? 0.0,
                      unit: controllers['unit']!.text.trim(),
                      stock: product.stock ?? 999,
                    );
                    final quantity =
                        int.tryParse(controllers['quantity']!.text) ?? 1;
                    final discount =
                        double.tryParse(controllers['discount']!.text) ?? 0.0;

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

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยืนยันการล้างทั้งหมด'),
        content: const Text('ต้องการล้างรายการทั้งหมดหรือไม่?'),
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
                  bloc.add(const PurchaseClearAll());
                }
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ล้างรายการทั้งหมดสำเร็จ'),
                    backgroundColor: Colors.orange,
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
            child: const Text('ล้างทั้งหมด'),
          ),
        ],
      ),
    );
  }

  // Helper methods for form fields
  Widget _buildReadOnlyTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981)),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityField(TextEditingController controller,
      {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (required)
            RichText(
              text: const TextSpan(
                text: 'จำนวน',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: required ? null : 'จำนวน',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF10B981)),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกจำนวน';
              }
              final qty = int.tryParse(value);
              if (qty == null || qty <= 0) {
                return 'จำนวนต้องมากกว่า 0';
              }
              return null;
            },
          ),
        ],
      ),
    );
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
}
