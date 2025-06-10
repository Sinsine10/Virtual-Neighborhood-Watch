import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String customImage; // Custom image path before the text
  final String text;
  final VoidCallback onCustomImageClick; // Action for the custom image

  const AppBarWidget({
    Key? key,
    required this.customImage,
    required this.text,
    required this.onCustomImageClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF794747), // Set AppBar color to #794747
      automaticallyImplyLeading: false, // Remove back navigation icon
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0), // Adds 10px padding on all sides
            child: GestureDetector(
              onTap: onCustomImageClick,
              child: Image.asset(
                customImage,
                height: 24.0,
                width: 24.0,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading custom image $customImage: $error');
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0), // Adds 20px space to the right
          child: Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/menu.png',
                width: 29.0,
                height: 29.0,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading menu.png: $error');
                  return const Icon(Icons.menu);
                },
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open the endDrawer
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height
}