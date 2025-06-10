import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/tip.dart';
import '../providers/tip_provider.dart';
import '../widgets/AppBar_Widger.dart';
import '../widgets/Tip_card_widgets.dart';
import '../widgets/navigation_Widger.dart';

class AdminTipScreen extends ConsumerWidget {
  const AdminTipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipState = ref.watch(tipProvider);
    print('TipState: isLoading=${tipState.isLoading}, error=${tipState.errorMessage}, tips=${tipState.tips.length}');

    // Fetch tips when the screen is built, only if tips are empty and no error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tipState.tips.isEmpty && tipState.errorMessage == null) {
        print('Triggering fetchTips at ${DateTime.now()}');
        ref.read(tipProvider.notifier).fetchTips();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFCA7F7F),
      appBar: AppBarWidget(
        customImage: 'assets/lighticon.png',
        text: 'Tips',
        onCustomImageClick: () {
          print('Custom image clicked');
        },
      ),
      endDrawer: const AppNavigationDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16.0),
              Expanded(
                child: tipState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : tipState.errorMessage != null
                    ? Center(child: Text(tipState.errorMessage!))
                    : ListView.builder(
                  itemCount: tipState.tips.length,
                  itemBuilder: (context, index) {
                    final tip = tipState.tips[index];
                    return TipCard(
                      tip: tip.description,
                      id: tip.id,
                      onEditTip: (id) => _showEditTipDialog(context, ref, tip), // Pass ref here
                      onDeleteTip: (id) {
                        print('Deleting tip with ID: $id');
                        ref.read(tipProvider.notifier).deleteTip(id);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 250.0),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/bottom.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading bottom.png: $error');
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 30.0),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => _showAddTipDialog(context, ref),
          child: Image.asset(
            'assets/add.png',
            width: 50.0,
            height: 50.0,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading add.png: $error');
              return const Icon(Icons.add);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddTipDialog(BuildContext context, WidgetRef ref) {
    String editTipDescription = '';
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tip:'),
              const SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  editTipDescription = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your tip',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF361919),
                      width: 3.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF794747),
                foregroundColor: Colors.white,
                minimumSize: const Size(100, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                if (editTipDescription.isNotEmpty) {
                  print('Adding tip: $editTipDescription');
                  ref.read(tipProvider.notifier).addTip(editTipDescription);
                }
                Navigator.pop(context);
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTipDialog(BuildContext context, WidgetRef ref, Tip tip) {
    String editTipDescription = tip.description;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Tip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tip:'),
              const SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  editTipDescription = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your tip',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF361919),
                      width: 3.0,
                    ),
                  ),
                ),
                controller: TextEditingController(text: editTipDescription),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF794747),
                foregroundColor: Colors.white,
                minimumSize: const Size(100, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                if (editTipDescription.isNotEmpty) {
                  print('Updating tip ID ${tip.id} with: $editTipDescription');
                  ref.read(tipProvider.notifier).updateTip(tip.id, editTipDescription);
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}