import 'package:flutter/material.dart';
import 'edit_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'All'; // 'All', 'In Progress', 'On Hold'

  // Sample notes data
  final List<Map<String, dynamic>> _allNotes = [
    {
      'id': 1,
      'title': 'Meeting with sales manager - Kareem',
      'description': 'This meeting shouldn\'t be missed at any cost, It\'s really an important meeting with Kareem, I have to give an update on Sales.',
      'dateTime': '25 Sept. 2025 05:20 PM',
      'status': 'In Progress',
      'icon': Icons.call_made, // upward-right arrow
      'color': const LinearGradient(
        colors: [Color(0xFF9F7AEA), Color(0xFFF687B3)], // Soft purple to soft pink gradient
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 2,
      'title': 'Weekly lab assignment - Due Monday',
      'description': 'I need to submit a proposal with full project requirements, mockups, wireframes, and',
      'dateTime': '27 Sept. 2025 On Hold',
      'status': 'On Hold',
      'icon': Icons.pause,
      'color': const LinearGradient(
        colors: [Color(0xFFFF9A6B), Color(0xFFFFB088)], // Soft orange gradient
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 3,
      'title': 'Car wash and hangout with Aimen',
      'description': 'Need to go car wash as it\'s too dirty last night and then have to hangout with Aimen as I\'d promised her.',
      'dateTime': 'Today In Progress',
      'status': 'In Progress',
      'icon': Icons.call_received, // downward-left arrow
      'color': const LinearGradient(
        colors: [Color(0xFF7AB8F5), Color(0xFF9BC5F7)], // Soft blue to soft light blue gradient
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  List<Map<String, dynamic>> get _filteredNotes {
    if (_selectedFilter == 'All') {
      return _allNotes;
    } else if (_selectedFilter == 'In Progress') {
      return _allNotes.where((note) => note['status'] == 'In Progress').toList();
    } else if (_selectedFilter == 'On Hold') {
      return _allNotes.where((note) => note['status'] == 'On Hold').toList();
    }
    return _allNotes;
  }

  void _openEdit(Map<String, dynamic> note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FD),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  // Top row with profile, search, and plus icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile picture
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF6B46C1),
                        backgroundImage: const AssetImage('assets/images/profile_picture.png'),
                      ),
                      // Search and Plus icons
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Search')),
                              );
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black87,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Add new note')),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black87,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Manage Your Daily Notes',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filter Tabs
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildFilterTab('All', _allNotes.length.toString().padLeft(2, '0')),
                      _buildFilterTab('In Progress', _allNotes.where((n) => n['status'] == 'In Progress').length.toString().padLeft(2, '0')),
                      _buildFilterTab('On Hold', _allNotes.where((n) => n['status'] == 'On Hold').length.toString().padLeft(2, '0')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Notes List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = _filteredNotes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _openEdit(note);
                          },
                          child: _buildNoteCard(note),
                        ),
                      ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F8FD),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Add Note Button (Purple circular with document icon and plus)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add new note')),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA78BFA), // Match login/signup button theme
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.note_add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                // Notes Icon
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Already on dashboard
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Progress Icon
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_filteredNotes.isNotEmpty) {
                          _openEdit(_filteredNotes.first);
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                    const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, String count) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with date/time/status and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and time/status (combined)
              Expanded(
                child: Text(
                  note['dateTime'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              // Icon in white circle
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  note['icon'] as IconData,
                  color: iconColor,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            note['title'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            note['description'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto',
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
