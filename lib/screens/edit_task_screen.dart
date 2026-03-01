import 'package:flutter/material.dart';
import 'translate_task_screen.dart';

class EditTaskScreen extends StatelessWidget {
  const EditTaskScreen({super.key, required this.note});

  final Map<String, dynamic> note;

  List<String> _splitDateTime(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return const ['', ''];
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    final timeIndex = parts.indexWhere((p) => p.contains(':'));
    if (timeIndex != -1) {
      final date = parts.sublist(0, timeIndex).join(' ');
      final time = parts.sublist(timeIndex).join(' ');
      return [date, time];
    }
    return [trimmed, ''];
  }

  @override
  Widget build(BuildContext context) {
    final title = note['title'] as String? ?? '';
    final description = note['description'] as String? ?? '';
    final dateTime = note['dateTime'] as String? ?? '';
    final split = _splitDateTime(dateTime);
    final dateLine = split[0];
    final timeLine = split[1];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F8FD),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        leadingWidth: 56,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              dateLine,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (timeLine.isNotEmpty)
              Text(
                timeLine,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF6B46C1),
              backgroundImage: const AssetImage('assets/images/profile_picture.png'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _NotePreviewCard(note: note),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Roboto',
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              if (note['items'] is List)
                ...List<Widget>.from(
                  (note['items'] as List)
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 16, height: 1.4)),
                                Expanded(
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.4,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )
              else
                Text(
                  description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                  fontFamily: 'Roboto',
                ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BottomBarItem(
                icon: Icons.receipt_long,
                label: 'Tasks',
                onTap: () => Navigator.of(context).pop(),
              ),
              _BottomBarItem(
                icon: Icons.language,
                label: 'Translate',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TranslateTaskScreen(note: note),
                    ),
                  );
                },
              ),
              _BottomBarItem(
                icon: Icons.edit,
                label: 'Edit',
                isActive: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditTaskFormScreen(note: note),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFA78BFA) : Colors.black87;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskFormScreen extends StatefulWidget {
  const EditTaskFormScreen({super.key, required this.note});

  final Map<String, dynamic> note;

  @override
  State<EditTaskFormScreen> createState() => _EditTaskFormScreenState();
}

class _NotePreviewCard extends StatelessWidget {
  const _NotePreviewCard({required this.note});

  final Map<String, dynamic> note;

  @override
  Widget build(BuildContext context) {
    final colorValue = note['color'];
    final isGradient = colorValue is LinearGradient;
    final Color iconColor;
    if (isGradient) {
      iconColor = colorValue.colors.first;
    } else if (colorValue is Color) {
      iconColor = colorValue;
    } else {
      iconColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: isGradient ? colorValue : null,
        color: isGradient ? null : (colorValue is Color ? colorValue : Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              note['title'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              note['icon'] as IconData? ?? Icons.note,
              color: iconColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditTaskFormScreenState extends State<EditTaskFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title'] as String? ?? '');
    _descriptionController = TextEditingController(text: widget.note['description'] as String? ?? '');
    _titleFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _titleFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F8FD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Task',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFFA78BFA),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
