import 'package:flutter/material.dart';
import '../../../blocs/creditor/creditor_state.dart';

class CreditorDetailDialog extends StatelessWidget {
  final Function(CreditorItem) onEdit;
  final CreditorItem item;
  const CreditorDetailDialog({
    super.key,
    required this.item,
    required this.onEdit,
  });

  Widget _buildDetailField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAddressFields(String? addresses) {
    if (addresses == null || addresses.isEmpty) {
      return [_buildDetailField('ที่อยู่', '-')];
    }

    final addressList = addresses.split('; ');
    return addressList.asMap().entries.map((entry) {
      final index = entry.key;
      final address = entry.value;
      return Column(
        children: [
          _buildDetailField('ที่อยู่เอกสารภาษี ${index + 1}', address),
          if (index < addressList.length - 1) const SizedBox(height: 8),
        ],
      );
    }).toList();
  }

  // Helper method to get person type display text
  String _getPersonTypeText(int? personType) {
    switch (personType) {
      case 0:
        return 'บุคคลธรรมดา';
      case 1:
        return 'นิติบุคคล';
      default:
        return 'บุคคลธรรมดา';
    }
  }

  // Helper method to get tax ID label based on person type
  String _getTaxIdLabel(int? personType) {
    switch (personType) {
      case 0:
        return 'เลขที่ผู้เสียภาษี';
      case 1:
        return 'เลขที่บัตรประจำตัวประชาชน';
      default:
        return 'เลขที่ผู้เสียภาษี';
    }
  }

  // Helper method to get branch display text
  String _getBranchText(String? branch) {
    if (branch == null || branch.isEmpty) {
      return 'สาขา';
    }
    return branch;
  }

  @override
  Widget build(BuildContext context) {
    // Debug logs
    print('=== CreditorDetailDialog Debug ===');
    print('item.personType: ${item.personType}');
    print('item.branch: ${item.branch}');
    print('item.branchNumber: ${item.branchNumber}');
    print('PersonType text: ${_getPersonTypeText(item.personType)}');
    print('Branch text: ${_getBranchText(item.branch)}');
    print('================================');
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.newspaper, color: Colors.grey),
          SizedBox(width: 8),
          Text('รายละเอียดเจ้าหนี้'),
        ],
      ),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ข้อมูลเจ้าหนี้
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ข้อมูลเจ้าหนี้',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 144,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person,
                                  size: 48, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                'รูปเจ้าหนี้',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child:
                                          _buildDetailField('รหัส', item.code)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: _buildDetailField(
                                          'ชื่อ', item.name ?? '-')),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailField(
                                      'ประเภท',
                                      _getPersonTypeText(item.personType),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildDetailField(
                                        _getTaxIdLabel(item.personType),
                                        item.taxId ?? '-'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildDetailField(
                                          'สาขา', _getBranchText(item.branch))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildDetailField(
                                        'หมายเลขสาขา', item.branchNumber ?? '-'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                            child:
                                _buildDetailField('อีเมล', item.email ?? '-')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDetailField(
                            'จำนวนวันเครดิต',
                            item.creditLimit?.toString() ?? '-',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('ข้อมูลติดต่อ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildDetailField('ชื่อ', item.name ?? '-'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: _buildDetailField(
                                    'เบอร์หลัก', item.phone ?? '-')),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDetailField(
                                  'เบอร์สำรอง', item.contactPerson ?? '-'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ..._buildAddressFields(item.address),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          label: const Text('ปิด'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            onEdit(item);
          },
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('แก้ไข'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}