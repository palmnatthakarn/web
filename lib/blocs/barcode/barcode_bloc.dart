import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/barcode_repository.dart';
import 'barcode_event.dart';
import 'barcode_state.dart';

class BarcodeBloc extends Bloc<BarcodeEvent, BarcodeState> {
  final BarcodeRepository repo;

  BarcodeBloc(this.repo) : super(const BarcodeState()) {
    on<BarcodeInitialized>(_onInit);
    on<BarcodeSearchChanged>(_onSearchChanged);
    on<BarcodeLeftPanelDragged>(_onDragged);
    on<BarcodeItemSelected>(_onSelected);
    on<BarcodeProductTypeChanged>(_onProductTypeChanged);
    on<BarcodeProduceTypeChanged>(_onProduceTypeChanged);
  }

  Future<void> _onInit(
    BarcodeInitialized event,
    Emitter<BarcodeState> emit,
  ) async {
    emit(state.copyWith(status: BarcodeStatus.loading));
    try {
      final items = await repo.fetchItems();
      emit(state.copyWith(status: BarcodeStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: BarcodeStatus.failure, error: e.toString()));
    }
  }

  void _onSearchChanged(
    BarcodeSearchChanged event,
    Emitter<BarcodeState> emit,
  ) {
    emit(state.copyWith(query: event.query, clearSelected: true));
  }

  void _onDragged(
    BarcodeLeftPanelDragged event,
    Emitter<BarcodeState> emit,
  ) {
    final w = (state.leftPanelWidth + event.dx)
        .clamp(state.minPanelWidth, state.maxPanelWidth);
    emit(state.copyWith(leftPanelWidth: w));
  }

  void _onSelected(
    BarcodeItemSelected event,
    Emitter<BarcodeState> emit,
  ) {
    emit(state.copyWith(selected: event.item));
  }

  void _onProductTypeChanged(
    BarcodeProductTypeChanged event,
    Emitter<BarcodeState> emit,
  ) {
    emit(state.copyWith(productTypeGroup: event.value));
  }

  void _onProduceTypeChanged(
    BarcodeProduceTypeChanged event,
    Emitter<BarcodeState> emit,
  ) {
    emit(state.copyWith(produceGroup: event.value));
  }
}
