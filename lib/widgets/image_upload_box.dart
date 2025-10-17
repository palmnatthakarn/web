import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/image/image_bloc.dart';
import '../blocs/image/image_event.dart';
import '../blocs/image/image_state.dart';

class ImageUploadBox extends StatelessWidget {
  const ImageUploadBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.imageData != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            state.imageData!,
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => context.read<ImageBloc>().add(ImageRemoved()),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () => context.read<ImageBloc>().add(ImageUploadRequested()),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text('เพิ่มรูป', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}