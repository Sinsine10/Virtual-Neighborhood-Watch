import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/tip_viewmodel.dart';
import '../widgets/AppBar_Widger.dart';
import '../widgets/Tip_card_widgets.dart';
import '../widgets/navigation_Widger.dart';

class AdminTipScreen extends StatefulWidget {
  const AdminTipScreen({super.key});

  @override
  _AdminTipScreenState createState() => _AdminTipScreenState();
}

class _AdminTipScreenState extends State<AdminTipScreen> {
  String editTipDescription = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TipViewModel>().fetchTips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TipViewModel>(
      builder: (context, viewModel, child) {
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
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.errorMessage != null
                        ? Center(child: Text(viewModel.errorMessage!))
                        : ListView.builder(
                      itemCount: viewModel.tips.length,
                      itemBuilder: (context, index) {
                        return TipCard(
                          tip: viewModel.tips[index].description,
                          id: viewModel.tips[index].id,
                          onEditTip: (_) {},
                          onDeleteTip: (_) {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 120.0),
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
              onPressed: () => _showAddTipDialog(),
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
      },
    );
  }

  void _showAddTipDialog() {
    editTipDescription = '';
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissal by tapping outside
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
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF361919),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
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
                  context.read<TipViewModel>().addTip(editTipDescription);
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
}