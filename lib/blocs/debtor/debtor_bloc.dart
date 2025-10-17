import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/debtor_repository.dart';
import 'debtor_event.dart';
import 'debtor_state.dart';

class DebtorBloc extends Bloc<DebtorEvent, DebtorState> {
  final DebtorRepository repo;

  DebtorBloc(this.repo)
      : super(DebtorState(
          createdDate: DateTime.now(),
        )) {
    on<DebtorInitialized>(_onInit);
    on<DebtorSearchChanged>(_onSearchChanged);
    on<DebtorLeftPanelDragged>(_onDragged);
    on<DebtorItemSelected>(_onSelected);
    on<DebtorFormUpdated>(_onFormUpdated);
    on<DebtorItemAdded>(_onItemAdded);
    on<DebtorItemRemoved>(_onItemRemoved);
    on<DebtorItemUpdated>(_onItemUpdated);
    on<DebtorClearAll>(_onClearAll);
    on<DebtorCalculatePressed>(_onCalculatePressed);
    on<DebtorInventoryPressed>(_onInventoryPressed);
    on<DebtorAddPressed>(_onAddPressed);
    on<DebtorDeletePressed>(_onDeletePressed);
    on<DebtorUserPressed>(_onUserPressed);
    on<DebtorImageAdded>(_onImageAdded);
    on<DebtorImageRemoved>(_onImageRemoved);
    on<DebtorImagesCleared>(_onImagesCleared);
  }

  Future<void> _onInit(
    DebtorInitialized event,
    Emitter<DebtorState> emit,
  ) async {
    emit(state.copyWith(status: DebtorStatus.loading));
    try {
      final items = await repo.fetchDebtors();
      emit(state.copyWith(status: DebtorStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: DebtorStatus.failure, error: e.toString()));
    }
  }

  void _onSearchChanged(
    DebtorSearchChanged event,
    Emitter<DebtorState> emit,
  ) {
    emit(state.copyWith(query: event.query, clearSelected: true));
  }

  void _onDragged(
    DebtorLeftPanelDragged event,
    Emitter<DebtorState> emit,
  ) {
    final w = (state.leftPanelWidth + event.dx)
        .clamp(state.minPanelWidth, state.maxPanelWidth);
    emit(state.copyWith(leftPanelWidth: w));
  }

  void _onSelected(
    DebtorItemSelected event,
    Emitter<DebtorState> emit,
  ) {
    emit(state.copyWith(selected: event.item));
  }

  void _onFormUpdated(
    DebtorFormUpdated event,
    Emitter<DebtorState> emit,
  ) {
    emit(state.copyWith(
      debtorName: event.debtorName,
      debtorCode: event.debtorCode,
      address: event.address,
      phone: event.phone,
      email: event.email,
      taxId: event.taxId,
      contactPerson: event.contactPerson,
      remarks: event.remarks,
      createdDate: event.createdDate,
    ));
  }

  void _onItemAdded(
    DebtorItemAdded event,
    Emitter<DebtorState> emit,
  ) {
    final updatedItems = [...state.items, event.item];
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemRemoved(
    DebtorItemRemoved event,
    Emitter<DebtorState> emit,
  ) {
    final updatedItems = List<DebtorItem>.from(state.items);
    updatedItems.removeAt(event.index);
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemUpdated(
    DebtorItemUpdated event,
    Emitter<DebtorState> emit,
  ) {
    final updatedItems = List<DebtorItem>.from(state.items);
    updatedItems[event.index] = event.item;
    emit(state.copyWith(items: updatedItems));
  }

  void _onClearAll(
    DebtorClearAll event,
    Emitter<DebtorState> emit,
  ) {
    emit(state.copyWith(
      items: [],
      query: '',
      clearSelected: true,
      debtorName: null,
      debtorCode: null,
      address: null,
      phone: null,
      email: null,
      taxId: null,
      contactPerson: null,
      remarks: null,
      selectedImages: [],
    ));
  }

  void _onCalculatePressed(
    DebtorCalculatePressed event,
    Emitter<DebtorState> emit,
  ) {
    // TODO: Implement calculation logic
  }

  void _onInventoryPressed(
    DebtorInventoryPressed event,
    Emitter<DebtorState> emit,
  ) {
    // TODO: Implement inventory logic
  }

  void _onAddPressed(
    DebtorAddPressed event,
    Emitter<DebtorState> emit,
  ) {
    // TODO: Show add dialog
  }

  void _onDeletePressed(
    DebtorDeletePressed event,
    Emitter<DebtorState> emit,
  ) {
    if (state.selected != null) {
      final index = state.items.indexOf(state.selected!);
      if (index >= 0) {
        add(DebtorItemRemoved(index));
      }
    }
  }

  void _onUserPressed(
    DebtorUserPressed event,
    Emitter<DebtorState> emit,
  ) {
    // TODO: Implement user logic
  }

  void _onImageAdded(
    DebtorImageAdded event,
    Emitter<DebtorState> emit,
  ) {
    final updatedImages = [...state.selectedImages, event.imagePath];
    emit(state.copyWith(selectedImages: updatedImages));
  }

  void _onImageRemoved(
    DebtorImageRemoved event,
    Emitter<DebtorState> emit,
  ) {
    final updatedImages = List<String>.from(state.selectedImages);
    updatedImages.removeAt(event.index);
    emit(state.copyWith(selectedImages: updatedImages));
  }

  void _onImagesCleared(
    DebtorImagesCleared event,
    Emitter<DebtorState> emit,
  ) {
    emit(state.copyWith(selectedImages: []));
  }
}
