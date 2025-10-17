
enum CreditorStatus { initial, loading, loaded, failure }

class CreditorItem {
  final String code;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final String? taxId;
  final String? contactPerson;
  final DateTime? createdDate;
  final double? creditLimit;
  final double? currentBalance;
  final int? personType;
  final String? branch;
  final String? branchNumber;
  final List<String>? images;

  const CreditorItem({
    required this.code,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.taxId,
    this.contactPerson,
    this.createdDate,
    this.creditLimit,
    this.currentBalance,
    this.personType,
    this.branch,
    this.branchNumber,
    this.images,
  });

  CreditorItem copyWith({
    String? code,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? taxId,
    String? contactPerson,
    DateTime? createdDate,
    double? creditLimit,
    double? currentBalance,
    int? personType,
    String? branch,
    String? branchNumber,
    List<String>? images,
  }) {
    return CreditorItem(
      code: code ?? this.code,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
      contactPerson: contactPerson ?? this.contactPerson,
      createdDate: createdDate ?? this.createdDate,
      creditLimit: creditLimit ?? this.creditLimit,
      currentBalance: currentBalance ?? this.currentBalance,
      personType: personType ?? this.personType,
      branch: branch ?? this.branch,
      branchNumber: branchNumber ?? this.branchNumber,
      images: images ?? this.images,
    );
  }
}

class CreditorState {
  final CreditorStatus status;
  final List<CreditorItem> items;
  final String query;
  final double leftPanelWidth;
  final double minPanelWidth;
  final double maxPanelWidth;
  final CreditorItem? selected;
  final String? error;

  // Form fields
  final String creditorName;
  final String creditorCode;
  final String address;
  final String phone;
  final String email;
  final String taxId;
  final String contactPerson;
  final String remarks;
  final DateTime createdDate;
  final double creditLimit;
  final double currentBalance;
  final List<String> selectedImages;

  const CreditorState({
    this.status = CreditorStatus.initial,
    this.items = const [],
    this.query = '',
    this.leftPanelWidth = 400,
    this.minPanelWidth = 300,
    this.maxPanelWidth = 600,
    this.selected,
    this.error,
    this.creditorName = '',
    this.creditorCode = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.taxId = '',
    this.contactPerson = '',
    this.remarks = '',
    required this.createdDate,
    this.creditLimit = 0.0,
    this.currentBalance = 0.0,
    this.selectedImages = const [],
  });

  List<CreditorItem> get filteredItems {
    return items
        .where((e) =>
            e.code.toLowerCase().contains(query.toLowerCase()) ||
            (e.name?.toLowerCase() ?? '').contains(query.toLowerCase()))
        .toList();
  }

  CreditorState copyWith({
    CreditorStatus? status,
    List<CreditorItem>? items,
    String? query,
    double? leftPanelWidth,
    double? minPanelWidth,
    double? maxPanelWidth,
    CreditorItem? selected,
    String? error,
    bool clearSelected = false,
    String? creditorName,
    String? creditorCode,
    String? address,
    String? phone,
    String? email,
    String? taxId,
    String? contactPerson,
    String? remarks,
    DateTime? createdDate,
    double? creditLimit,
    double? currentBalance,
    List<String>? selectedImages,
  }) {
    return CreditorState(
      status: status ?? this.status,
      items: items ?? this.items,
      query: query ?? this.query,
      leftPanelWidth: leftPanelWidth ?? this.leftPanelWidth,
      minPanelWidth: minPanelWidth ?? this.minPanelWidth,
      maxPanelWidth: maxPanelWidth ?? this.maxPanelWidth,
      selected: clearSelected ? null : (selected ?? this.selected),
      error: error,
      creditorName: creditorName ?? this.creditorName,
      creditorCode: creditorCode ?? this.creditorCode,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
      contactPerson: contactPerson ?? this.contactPerson,
      remarks: remarks ?? this.remarks,
      createdDate: createdDate ?? this.createdDate,
      creditLimit: creditLimit ?? this.creditLimit,
      currentBalance: currentBalance ?? this.currentBalance,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }
}