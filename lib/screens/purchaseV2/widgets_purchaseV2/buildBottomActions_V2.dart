import 'package:flutter/material.dart';

class BottomActions_V2 {
  static Widget buildBottomActions(BuildContext context, GlobalKey<FormState> formKey) {
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
            label: const Text('ล้างทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _saveDraft(context),
                icon: const Icon(Icons.save_outlined),
                label: const Text('บันทึกร่าง'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _submitForm(context, formKey),
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('ดำเนินการซื้อ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยืนยันการล้างทั้งหมด'),
        content: const Text(
            'ต้องการลบรายการทั้งหมดหรือไม่? การดำเนินการนี้ไม่สามารถย้อนกลับได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ล้างรายการทั้งหมดสำเร็จ'),
                  backgroundColor: Colors.orange,
                ),
              );
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

  static void _saveDraft(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกแบบร่างเรียบร้อยแล้ว'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  static void _submitForm(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งข้อมูลเรียบร้อยแล้ว'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}