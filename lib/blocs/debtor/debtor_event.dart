import 'debtor_state.dart';

abstract class DebtorEvent {
  const DebtorEvent();
}

class DebtorInitialized extends DebtorEvent {
  const DebtorInitialized();
}

class DebtorSearchChanged extends DebtorEvent {
  final String query;
  const DebtorSearchChanged(this.query);
}

class DebtorLeftPanelDragged extends DebtorEvent {
  final double dx;
  const DebtorLeftPanelDragged(this.dx);
}

class DebtorItemSelected extends DebtorEvent {
  final DebtorItem item;
  const DebtorItemSelected(this.item);
}

class DebtorFormUpdated extends DebtorEvent {
  final String? debtorName;
  final String? debtorCode;
  final String? address;
  final String? phone;
  final String? email;
  final String? taxId;
  final String? contactPerson;
  final String? remarks;
  final DateTime? createdDate;

  const DebtorFormUpdated({
    this.debtorName,
    this.debtorCode,
    this.address,
    this.phone,
    this.email,
    this.taxId,
    this.contactPerson,
    this.remarks,
    this.createdDate,
  });
}

class DebtorItemAdded extends DebtorEvent {
  final DebtorItem item;
  const DebtorItemAdded(this.item);
}

class DebtorItemRemoved extends DebtorEvent {
  final int index;
  const DebtorItemRemoved(this.index);
}

class DebtorItemUpdated extends DebtorEvent {
  final int index;
  final DebtorItem item;
  const DebtorItemUpdated(this.index, this.item);
}

class DebtorClearAll extends DebtorEvent {
  const DebtorClearAll();
}

class DebtorCalculatePressed extends DebtorEvent {
  const DebtorCalculatePressed();
}

class DebtorInventoryPressed extends DebtorEvent {
  const DebtorInventoryPressed();
}

class DebtorAddPressed extends DebtorEvent {
  const DebtorAddPressed();
}

class DebtorDeletePressed extends DebtorEvent {
  const DebtorDeletePressed();
}

class DebtorUserPressed extends DebtorEvent {
  const DebtorUserPressed();
}

class DebtorImageAdded extends DebtorEvent {
  final String imagePath;
  const DebtorImageAdded(this.imagePath);
}

class DebtorImageRemoved extends DebtorEvent {
  final int index;
  const DebtorImageRemoved(this.index);
}

class DebtorImagesCleared extends DebtorEvent {
  const DebtorImagesCleared();
}
