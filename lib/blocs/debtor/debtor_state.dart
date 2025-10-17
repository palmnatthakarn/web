enum DebtorStatus { initial, loading, loaded, failure }

class DebtorItem {
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

  const DebtorItem({
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

  DebtorItem copyWith({
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
    return DebtorItem(
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

class DebtorState {
  final DebtorStatus status;
  final List<DebtorItem> items;
  final String query;
  final double leftPanelWidth;
  final double minPanelWidth;
  final double maxPanelWidth;
  final DebtorItem? selected;
  final String? error;

  // Form fields
  final String? debtorName;
  final String? debtorCode;
  final String? address;
  final String? phone;
  final String? email;
  final String? taxId;
  final String? contactPerson;
  final String? remarks;
  final DateTime? createdDate;
  final List<String> selectedImages;

  const DebtorState({
    this.status = DebtorStatus.initial,
    this.items = const [],
    this.query = '',
    this.leftPanelWidth = 400,
    this.minPanelWidth = 300,
    this.maxPanelWidth = 600,
    this.selected,
    this.error,
    this.debtorName,
    this.debtorCode,
    this.address,
    this.phone,
    this.email,
    this.taxId,
    this.contactPerson,
    this.remarks,
    this.createdDate,
    this.selectedImages = const [],
  });

  DebtorState copyWith({
    DebtorStatus? status,
    List<DebtorItem>? items,
    String? query,
    double? leftPanelWidth,
    double? minPanelWidth,
    double? maxPanelWidth,
    DebtorItem? selected,
    String? error,
    String? debtorName,
    String? debtorCode,
    String? address,
    String? phone,
    String? email,
    String? taxId,
    String? contactPerson,
    String? remarks,
    DateTime? createdDate,
    List<String>? selectedImages,
    bool clearSelected = false,
  }) {
    return DebtorState(
      status: status ?? this.status,
      items: items ?? this.items,
      query: query ?? this.query,
      leftPanelWidth: leftPanelWidth ?? this.leftPanelWidth,
      minPanelWidth: minPanelWidth ?? this.minPanelWidth,
      maxPanelWidth: maxPanelWidth ?? this.maxPanelWidth,
      selected: clearSelected ? null : (selected ?? this.selected),
      error: error ?? this.error,
      debtorName: debtorName ?? this.debtorName,
      debtorCode: debtorCode ?? this.debtorCode,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
      contactPerson: contactPerson ?? this.contactPerson,
      remarks: remarks ?? this.remarks,
      createdDate: createdDate ?? this.createdDate,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  List<DebtorItem> get filtered {
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((item) {
      return (item.code.toLowerCase().contains(q)) ||
          (item.name?.toLowerCase().contains(q) ?? false) ||
          (item.phone?.toLowerCase().contains(q) ?? false) ||
          (item.email?.toLowerCase().contains(q) ?? false) ||
          (item.taxId?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}
