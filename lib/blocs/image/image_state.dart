import 'dart:typed_data';

class ImageState {
  final Uint8List? imageData;
  final String? imageName;
  final bool isLoading;

  const ImageState({
    this.imageData,
    this.imageName,
    this.isLoading = false,
  });

  ImageState copyWith({
    Uint8List? imageData,
    String? imageName,
    bool? isLoading,
  }) {
    return ImageState(
      imageData: imageData ?? this.imageData,
      imageName: imageName ?? this.imageName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}