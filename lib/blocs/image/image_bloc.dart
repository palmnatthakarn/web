//import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(const ImageState()) {
    on<ImageUploadRequested>(_onImageUploadRequested);
    on<ImageRemoved>(_onImageRemoved);
  }

  Future<void> _onImageUploadRequested(
    ImageUploadRequested event,
    Emitter<ImageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        emit(state.copyWith(
          imageData: file.bytes,
          imageName: file.name,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onImageRemoved(
    ImageRemoved event,
    Emitter<ImageState> emit,
  ) {
    emit(const ImageState());
  }
}