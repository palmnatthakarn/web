import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../blocs/debtor/debtor_bloc.dart';
import '../../../blocs/debtor/debtor_event.dart';
import '../../../blocs/debtor/debtor_state.dart';
import 'debtor_header.dart';
import 'debtor_detail_dialog.dart';
import 'add_debtor_dialog.dart';
import 'edit_debtor_dialog.dart';

class DebtorRightPanel extends StatefulWidget {
  const DebtorRightPanel({super.key});

  @override
  State<DebtorRightPanel> createState() => _DebtorRightPanelState();
}

class _DebtorRightPanelState extends State<DebtorRightPanel> {
  void _showAddNewDebtorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<DebtorBloc>(),
        child: const AddDebtorDialog(),
      ),
    );
  }

  void _showEditDebtorDialog(BuildContext context, DebtorItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<DebtorBloc>(),
        child: EditDebtorDialog(item: item),
      ),
    );
  }

  void _showDebtorDetailDialog(BuildContext outerContext, DebtorItem item) {
    showDialog(
      context: outerContext,
      builder: (dialogCtx) => DebtorDetailDialog(
        item: item,
        onEdit: (item) => _showEditDebtorDialog(outerContext, item),
      ),
    );
  }

  void _deleteDebtor(BuildContext context, DebtorItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบลูกหนี้ "${item.name}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              final bloc = context.read<DebtorBloc>();
              final currentItems = List<DebtorItem>.from(bloc.state.items);
              currentItems.removeWhere((i) => i.code == item.code);
              bloc.add(const DebtorClearAll());
              for (final newItem in currentItems) {
                bloc.add(DebtorItemAdded(newItem));
              }
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ลบลูกหนี้สำเร็จ'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<DebtorBloc, DebtorState>(
        builder: (context, state) {
          return Column(
            children: [
              DebtorHeader(
                onAddNewItem: () => _showAddNewDebtorDialog(context),
              ),
              Expanded(
                child: state.items.isEmpty
                    ? _buildEmptyState(context)
                    : _buildDebtorTable(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'ยังไม่มีข้อมูลลูกหนี้',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'เพิ่มลูกหนี้ใหม่ด้วยการคลิกปุ่มเพิ่ม',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddNewDebtorDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('เพิ่มลูกหนี้แรก'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtorTable(BuildContext context, DebtorState state) {
    final debtors = state.filtered;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        headingRowColor:
            WidgetStateProperty.all(const Color.fromARGB(255, 217, 236, 254)),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
        columns: const [
          DataColumn2(label: Center(child: Text('ลำดับ')), size: ColumnSize.S),
          DataColumn2(
              label: Center(child: Text('รหัสลูกหนี้')), size: ColumnSize.S),
          DataColumn2(
              label: Center(child: Text('ชื่อลูกหนี้')), size: ColumnSize.M),
          DataColumn2(
              label: Center(child: Text('เบอร์โทรศัพท์')), size: ColumnSize.M),
          DataColumn2(
              label: Center(child: Text('ยอดคงเหลือ')), size: ColumnSize.M),
          DataColumn2(
            label: Center(child: Text('ที่อยู่')),
            size: ColumnSize.L,
            fixedWidth: 250,
          ),
          DataColumn2(
              label: Center(child: Text('')),
              size: ColumnSize.S,
              fixedWidth: 50),
        ],
        rows: debtors.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return DataRow2(
            color: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (index % 2 == 0) {
                  return Colors.grey.withOpacity(0.05);
                }
                return null;
              },
            ),
            onTap: () => _showDebtorDetailDialog(context, item),
            cells: [
              DataCell(Center(child: Text('${index + 1}'))),
              DataCell(Center(child: Text(item.code))),
              DataCell(Text(item.name ?? '')),
              DataCell(Center(child: Text(item.phone ?? ''))),
              DataCell(Center(
                  child:
                      Text(item.currentBalance?.toStringAsFixed(2) ?? '0.00'))),
              DataCell(Text(item.address ?? '')),
              DataCell(
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => _deleteDebtor(context, item),
                    tooltip: 'ลบ',
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
