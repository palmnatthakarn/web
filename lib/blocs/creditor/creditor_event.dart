import 'creditor_state.dart';

abstract class CreditorEvent {
  const CreditorEvent();
}

class CreditorInitialized extends CreditorEvent {
  const CreditorInitialized();
}

class CreditorSearchChanged extends CreditorEvent {
  final String query;
  const CreditorSearchChanged(this.query);
}

class CreditorLeftPanelDragged extends CreditorEvent {
  final double dx;
  const CreditorLeftPanelDragged(this.dx);
}

class CreditorItemSelected extends CreditorEvent {
  final CreditorItem item;
  const CreditorItemSelected(this.item);
}

class CreditorFormUpdated extends CreditorEvent {
  final String? creditorName;
  final String? creditorCode;
  final String? address;
  final String? phone;
  final String? email;
  final String? taxId;
  final String? contactPerson;
  final String? remarks;
  final DateTime? createdDate;

  const CreditorFormUpdated({
    this.creditorName,
    this.creditorCode,
    this.address,
    this.phone,
    this.email,
    this.taxId,
    this.contactPerson,
    this.remarks,
    this.createdDate,
  });
}

class CreditorItemAdded extends CreditorEvent {
  final CreditorItem item;
  const CreditorItemAdded(this.item);
}

class CreditorItemRemoved extends CreditorEvent {
  final int index;
  const CreditorItemRemoved(this.index);
}

class CreditorItemUpdated extends CreditorEvent {
  final int index;
  final CreditorItem item;
  const CreditorItemUpdated(this.index, this.item);
}

class CreditorClearAll extends CreditorEvent {
  const CreditorClearAll();
}

class CreditorCalculatePressed extends CreditorEvent {
  const CreditorCalculatePressed();
}

class CreditorInventoryPressed extends CreditorEvent {
  const CreditorInventoryPressed();
}

class CreditorAddPressed extends CreditorEvent {
  const CreditorAddPressed();
}

class CreditorDeletePressed extends CreditorEvent {
  const CreditorDeletePressed();
}

class CreditorUserPressed extends CreditorEvent {
  const CreditorUserPressed();
}

class CreditorImageAdded extends CreditorEvent {
  final String imagePath;
  const CreditorImageAdded(this.imagePath);
}

class CreditorImageRemoved extends CreditorEvent {
  final int index;
  const CreditorImageRemoved(this.index);
}

class CreditorImagesCleared extends CreditorEvent {
  const CreditorImagesCleared();
}
