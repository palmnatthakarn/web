import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/creditor/creditor_bloc.dart';
import '../../../blocs/creditor/creditor_event.dart';
import '../../../blocs/creditor/creditor_state.dart';

class CreditorHeader extends StatefulWidget {
  final Function() onAddNewItem;

  const CreditorHeader({
    Key? key,
    required this.onAddNewItem,
  }) : super(key: key);

  @override
  State<CreditorHeader> createState() => _CreditorHeaderState();
}

class _CreditorHeaderState extends State<CreditorHeader> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  CreditorBloc? _getCreditorBloc() {
    try {
      return context.read<CreditorBloc>();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditorBloc, CreditorState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Search Field
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาเจ้าหนี้ด้วยชื่อหรือรหัส...',
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF6B7280)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF10B981)),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  final bloc = _getCreditorBloc();
                                  if (bloc != null) {
                                    bloc.add(const CreditorSearchChanged(''));
                                  }
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        final bloc = _getCreditorBloc();
                        if (bloc != null) {
                          bloc.add(CreditorSearchChanged(value));
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add button
                  Tooltip(
                    message: 'เพิ่มเจ้าหนี้ใหม่',
                    child: ElevatedButton(
                      onPressed: widget.onAddNewItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
