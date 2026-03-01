import 'package:flutter/material.dart';

class TranslateTaskScreen extends StatefulWidget {
  const TranslateTaskScreen({super.key, required this.note});

  final Map<String, dynamic> note;

  @override
  State<TranslateTaskScreen> createState() => _TranslateTaskScreenState();
}

class _TranslateTaskScreenState extends State<TranslateTaskScreen> {
  bool _isArabic = false;

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
    final titleEn = widget.note['title'] as String? ?? '';
    final descriptionEn = widget.note['description'] as String? ?? '';
    final titleAr = widget.note['title_ar'] as String? ?? 'الاجتماع مع مدير المبيعات - كريم';
    final descriptionAr = widget.note['description_ar'] as String? ??
        'لا ينبغي تفويت هذا الاجتماع بأي حال من الأحوال، إنه اجتماع مهم للغاية مع كريم، ويجب أن أقدم له تحديثًا عن المبيعات.';
    final isArabic = _isArabic;
    final title = isArabic ? titleAr : titleEn;
    final description = isArabic ? descriptionAr : descriptionEn;
    final dateTime = widget.note['dateTime'] as String? ?? '';
    final split = _splitDateTime(dateTime);
    final dateLine = split[0];
    final timeLine = split[1];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F8FD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                title,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionPill(
                    icon: Icons.language,
                    label: 'Translate',
                    isPrimary: true,
                    onTap: () {
                      setState(() {
                        _isArabic = true;
                      });
                    },
                  ),
                  _ActionPill(
                    icon: Icons.keyboard_arrow_down,
                    label: isArabic ? 'Arabic' : 'English',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Language: ${isArabic ? 'Arabic' : 'English'}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final background = const Color(0xFF2D2D2D);
    final iconColor = isPrimary ? const Color(0xFF3B82F6) : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
