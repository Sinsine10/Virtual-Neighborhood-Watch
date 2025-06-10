import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tip_provider.dart';

class TipCard extends ConsumerWidget {
  final String tip;
  final int id;
  final Function(int) onEditTip;  // Callback for editing a tip
  final Function(int) onDeleteTip; // Callback for deleting a tip

  const TipCard({
    Key? key,
    required this.tip,
    required this.id,
    required this.onEditTip,
    required this.onDeleteTip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tip),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/edit.png',
                    width: 20.0,
                    height: 20.0,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.edit),
                  ),
                  onPressed: () => onEditTip(id), // Use the onEditTip callback
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/delete.png',
                    width: 20.0,
                    height: 20.0,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.delete),
                  ),
                  onPressed: () => _showDeleteDialog(context, id), // Show delete dialog
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int tipId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Tip'),
          content: const Text('Are you sure you want to delete this tip?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF794747),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                onDeleteTip(tipId); // Call the onDeleteTip callback
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF794747),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}