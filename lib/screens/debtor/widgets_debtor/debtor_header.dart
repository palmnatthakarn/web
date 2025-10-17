import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/debtor/debtor_bloc.dart';
import '../../../blocs/debtor/debtor_event.dart';
import '../../../blocs/debtor/debtor_state.dart';

class DebtorHeader extends StatefulWidget {
  final Function() onAddNewItem;

  const DebtorHeader({
    Key? key,
    required this.onAddNewItem,
  }) : super(key: key);

  @override
  State<DebtorHeader> createState() => _DebtorHeaderState();
}

class _DebtorHeaderState extends State<DebtorHeader> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DebtorBloc? _getDebtorBloc() {
    try {
      return context.read<DebtorBloc>();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtorBloc, DebtorState>(
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
                        hintText: 'ค้นหาลูกหนี้ด้วยชื่อหรือรหัส...',
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
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  final bloc = _getDebtorBloc();
                                  if (bloc != null) {
                                    bloc.add(const DebtorSearchChanged(''));
                                  }
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        final bloc = _getDebtorBloc();
                        if (bloc != null) {
                          bloc.add(DebtorSearchChanged(value));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add New Button
                  Tooltip(
                    message: 'เพิ่มลูกหนี้ใหม่',
                    child: ElevatedButton.icon(
                      onPressed: widget.onAddNewItem,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('เพิ่มลูกหนี้'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Summary Info
              Row(
                children: [
                  _buildSummaryCard(
                    'ลูกหนี้ทั้งหมด',
                    '${state.items.length} ราย',
                    Icons.people,
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    'ยอดรวม',
                    '${_calculateTotalBalance(state.items).toStringAsFixed(2)} บาท',
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalBalance(List<DebtorItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.currentBalance ?? 0.0));
  }
}
