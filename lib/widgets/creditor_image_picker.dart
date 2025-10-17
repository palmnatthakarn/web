import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../blocs/creditor/creditor_bloc.dart';
import '../blocs/creditor/creditor_event.dart';
import '../blocs/creditor/creditor_state.dart';

class CreditorImagePicker extends StatelessWidget {
  const CreditorImagePicker({super.key});

  Future<void> _pickImages(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (file.bytes != null) {
            // สำหรับ web เราจะเก็บ base64 string หรือ file name
            final fileName = file.name;
            context.read<CreditorBloc>().add(CreditorImageAdded(fileName));
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเลือกรูปภาพ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(BuildContext context, int index) {
    context.read<CreditorBloc>().add(CreditorImageRemoved(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditorBloc, CreditorState>(
      buildWhen: (previous, current) => 
          previous.selectedImages != current.selectedImages,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'รูปภาพเจ้าหนี้:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => _pickImages(context),
                  icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                  label: const Text('เพิ่มรูป'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                if (state.selectedImages.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => context
                        .read<CreditorBloc>()
                        .add(const CreditorImagesCleared()),
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('ลบทั้งหมด'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
            if (state.selectedImages.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.selectedImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageName = entry.value;
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image, size: 24, color: Colors.grey),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  imageName,
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => _removeImage(context, index),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ] else
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Center(
                  child: Text(
                    'ยังไม่มีรูปภาพ',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}