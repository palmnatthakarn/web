import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/creditor_repository.dart';
import 'creditor_event.dart';
import 'creditor_state.dart';

class CreditorBloc extends Bloc<CreditorEvent, CreditorState> {
  final CreditorRepository repo;

  CreditorBloc(this.repo)
      : super(CreditorState(
          createdDate: DateTime.now(),
        )) {
    on<CreditorInitialized>(_onInit);
    on<CreditorSearchChanged>(_onSearchChanged);
    on<CreditorLeftPanelDragged>(_onDragged);
    on<CreditorItemSelected>(_onSelected);
    on<CreditorFormUpdated>(_onFormUpdated);
    on<CreditorItemAdded>(_onItemAdded);
    on<CreditorItemRemoved>(_onItemRemoved);
    on<CreditorItemUpdated>(_onItemUpdated);
    on<CreditorClearAll>(_onClearAll);
    on<CreditorCalculatePressed>(_onCalculatePressed);
    on<CreditorInventoryPressed>(_onInventoryPressed);
    on<CreditorAddPressed>(_onAddPressed);
    on<CreditorDeletePressed>(_onDeletePressed);
    on<CreditorUserPressed>(_onUserPressed);
    on<CreditorImageAdded>(_onImageAdded);
    on<CreditorImageRemoved>(_onImageRemoved);
    on<CreditorImagesCleared>(_onImagesCleared);
  }

  Future<void> _onInit(
    CreditorInitialized event,
    Emitter<CreditorState> emit,
  ) async {
    emit(state.copyWith(status: CreditorStatus.loading));
    try {
      final items = await repo.fetchCreditors();
      emit(state.copyWith(status: CreditorStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: CreditorStatus.failure, error: e.toString()));
    }
  }

  void _onSearchChanged(
    CreditorSearchChanged event,
    Emitter<CreditorState> emit,
  ) {
    emit(state.copyWith(query: event.query, clearSelected: true));
  }

  void _onDragged(
    CreditorLeftPanelDragged event,
    Emitter<CreditorState> emit,
  ) {
    final w = (state.leftPanelWidth + event.dx)
        .clamp(state.minPanelWidth, state.maxPanelWidth);
    emit(state.copyWith(leftPanelWidth: w));
  }

  void _onSelected(
    CreditorItemSelected event,
    Emitter<CreditorState> emit,
  ) {
    emit(state.copyWith(selected: event.item));
  }

  void _onFormUpdated(
    CreditorFormUpdated event,
    Emitter<CreditorState> emit,
  ) {
    emit(state.copyWith(
      creditorName: event.creditorName,
      creditorCode: event.creditorCode,
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
    CreditorItemAdded event,
    Emitter<CreditorState> emit,
  ) {
    final updatedItems = [...state.items, event.item];
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemRemoved(
    CreditorItemRemoved event,
    Emitter<CreditorState> emit,
  ) {
    final updatedItems = List<CreditorItem>.from(state.items);
    updatedItems.removeAt(event.index);
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemUpdated(
    CreditorItemUpdated event,
    Emitter<CreditorState> emit,
  ) {
    final updatedItems = List<CreditorItem>.from(state.items);
    updatedItems[event.index] = event.item;
    emit(state.copyWith(items: updatedItems));
  }

  void _onClearAll(
    CreditorClearAll event,
    Emitter<CreditorState> emit,
  ) {
    emit(state.copyWith(
      items: [],
      creditorName: '',
      creditorCode: '',
      address: '',
      phone: '',
      email: '',
      taxId: '',
      contactPerson: '',
      remarks: '',
      selectedImages: [],
      clearSelected: true,
    ));
  }

  void _onCalculatePressed(
    CreditorCalculatePressed event,
    Emitter<CreditorState> emit,
  ) {
    // TODO: Implement calculate functionality
  }

  void _onInventoryPressed(
    CreditorInventoryPressed event,
    Emitter<CreditorState> emit,
  ) {
    // TODO: Implement inventory functionality
  }

  void _onAddPressed(
    CreditorAddPressed event,
    Emitter<CreditorState> emit,
  ) {
    // TODO: Implement add functionality
  }

  void _onDeletePressed(
    CreditorDeletePressed event,
    Emitter<CreditorState> emit,
  ) {
    // TODO: Implement delete functionality
  }

  void _onUserPressed(
    CreditorUserPressed event,
    Emitter<CreditorState> emit,
  ) {
    // TODO: Implement user functionality
  }

  void _onImageAdded(
    CreditorImageAdded event,
    Emitter<CreditorState> emit,
  ) {
    final updatedImages = [...state.selectedImages, event.imagePath];
    emit(state.copyWith(selectedImages: updatedImages));
  }

  void _onImageRemoved(
    CreditorImageRemoved event,
    Emitter<CreditorState> emit,
  ) {
    final updatedImages = List<String>.from(state.selectedImages);
    if (event.index >= 0 && event.index < updatedImages.length) {
      updatedImages.removeAt(event.index);
      emit(state.copyWith(selectedImages: updatedImages));
    }
  }

  void _onImagesCleared(
    CreditorImagesCleared event,
    Emitter<CreditorState> emit,
  ) {
    emit(state.copyWith(selectedImages: []));
  }
}
