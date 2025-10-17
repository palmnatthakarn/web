import '../blocs/debtor/debtor_state.dart';

class DebtorRepository {
  // Mock data for demonstration
  Future<List<DebtorItem>> fetchDebtors() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      DebtorItem(
        code: 'D001',
        name: 'บริษัท ABC จำกัด',
        address: '123 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110',
        phone: '02-123-4567',
        email: 'contact@abc.com',
        taxId: '0105558888999',
        contactPerson: 'นายสมชาย ใจดี',
        createdDate: DateTime(2024, 1, 15),
        creditLimit: 500000,
        currentBalance: 150000,
        personType: 1, // นิติบุคคล
        branch: 'สำนักงานใหญ่',
        branchNumber: '00000',
      ),
      DebtorItem(
        code: 'D002',
        name: 'ร้านค้าปลีก XYZ',
        address: '456 ถนนพระราม 4 แขวงพระโขนง เขตคลองเตย กรุงเทพฯ 10110',
        phone: '02-987-6543',
        email: 'xyz@shop.com',
        taxId: '0105559999888',
        contactPerson: 'นางสาวสมหญิง รักดี',
        createdDate: DateTime(2024, 2, 20),
        creditLimit: 300000,
        currentBalance: 85000,
        personType: 1,
        branch: 'สำนักงานใหญ่',
        branchNumber: '00000',
      ),
      DebtorItem(
        code: 'D003',
        name: 'นายสมปอง รุ่งเรือง',
        address: '789 ถนนพระราม 9 แขวงห้วยขวาง เขตห้วยขวาง กรุงเทพฯ 10310',
        phone: '081-234-5678',
        email: 'sompong@email.com',
        taxId: '1234567890123',
        contactPerson: 'นายสมปอง รุ่งเรือง',
        createdDate: DateTime(2024, 3, 10),
        creditLimit: 100000,
        currentBalance: 25000,
        personType: 2, // บุคคลธรรมดา
      ),
      DebtorItem(
        code: 'D004',
        name: 'ห้างหุ้นส่วน DEF',
        address: '321 ถนนเพชรบุรี แขวงทุ่งพญาไท เขตราชเทวี กรุงเทพฯ 10400',
        phone: '02-555-6666',
        email: 'def@partnership.com',
        taxId: '0205557777666',
        contactPerson: 'นายวิชัย ชัยชนะ',
        createdDate: DateTime(2024, 4, 5),
        creditLimit: 750000,
        currentBalance: 320000,
        personType: 1,
        branch: 'สำนักงานใหญ่',
        branchNumber: '00000',
      ),
      DebtorItem(
        code: 'D005',
        name: 'บริษัท GHI จำกัด (มหาชน)',
        address: '999 ถนนสาทร แขวงยานนาวา เขตสาทร กรุงเทพฯ 10120',
        phone: '02-777-8888',
        email: 'info@ghi.co.th',
        taxId: '0107550000111',
        contactPerson: 'นางสาวพิมพ์ใจ สุขสันต์',
        createdDate: DateTime(2024, 5, 12),
        creditLimit: 1000000,
        currentBalance: 450000,
        personType: 1,
        branch: 'สำนักงานใหญ่',
        branchNumber: '00000',
      ),
    ];
  }

  Future<void> addDebtor(DebtorItem debtor) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Implement actual database insertion
  }

  Future<void> updateDebtor(String code, DebtorItem debtor) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Implement actual database update
  }

  Future<void> deleteDebtor(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Implement actual database deletion
  }
}
