import 'package:flutter/material.dart';
import '../../../blocs/debtor/debtor_state.dart';
import 'package:intl/intl.dart';

class DebtorDetailDialog extends StatelessWidget {
  final DebtorItem item;
  final Function(DebtorItem)? onEdit;

  const DebtorDetailDialog({
    Key? key,
    required this.item,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'รายละเอียดลูกหนี้',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.code,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection('ข้อมูลทั่วไป', [
                      _buildInfoRow('รหัสลูกหนี้', item.code),
                      _buildInfoRow('ชื่อลูกหนี้', item.name ?? '-'),
                      _buildInfoRow('ประเภท',
                          item.personType == 1 ? 'นิติบุคคล' : 'บุคคลธรรมดา'),
                      if (item.personType == 1) ...[
                        _buildInfoRow('สาขา', item.branch ?? '-'),
                        _buildInfoRow('เลขที่สาขา', item.branchNumber ?? '-'),
                      ],
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection('ข้อมูลการติดต่อ', [
                      _buildInfoRow('ที่อยู่', item.address ?? '-'),
                      _buildInfoRow('เบอร์โทรศัพท์', item.phone ?? '-'),
                      _buildInfoRow('อีเมล', item.email ?? '-'),
                      _buildInfoRow(
                          'เลขประจำตัวผู้เสียภาษี', item.taxId ?? '-'),
                      _buildInfoRow('ผู้ติดต่อ', item.contactPerson ?? '-'),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection('ข้อมูลทางการเงิน', [
                      _buildInfoRow('วงเงินเครดิต',
                          '${item.creditLimit?.toStringAsFixed(2) ?? '0.00'} บาท'),
                      _buildInfoRow('ยอดคงเหลือ',
                          '${item.currentBalance?.toStringAsFixed(2) ?? '0.00'} บาท',
                          valueColor: Colors.green),
                      _buildInfoRow(
                        'วันที่สร้าง',
                        item.createdDate != null
                            ? DateFormat('dd/MM/yyyy').format(item.createdDate!)
                            : '-',
                      ),
                    ]),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ปิด'),
                  ),
                  const SizedBox(width: 12),
                  if (onEdit != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onEdit!(item);
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('แก้ไข'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
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

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? const Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
