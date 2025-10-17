import '../blocs/creditor/creditor_state.dart';

class CreditorRepository {
  Future<List<CreditorItem>> fetchCreditors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<void> saveCreditor(CreditorItem creditor) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // บันทึกข้อมูลเจ้าหนี้
  }

  Future<void> deleteCreditor(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // ลบข้อมูลเจ้าหนี้
  }
}