import 'package:flutter/material.dart';
import '../widgets/menu.dart';
class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD07C7C),
      endDrawer: const AppMenuDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF794747),
        elevation: 0,
         automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/lighticon.png', width: 24, height: 24),
            const SizedBox(width: 10),
            const Text(
              'Tips',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/menu.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              onPressed: () {
                
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),





      body: Stack(
        children: [
          Container(
            color: const Color(0xFFD07C7C), // background pink
          ),
           Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              TipCard(text: 'Make sure to lock your doors before you go to bed'),
              SizedBox(height: 10),
              TipCard(text: 'Take care when standing in line'),
              SizedBox(height: 10),
              TipCard(text: 'Be careful who you ask for directions'),
            ],
          ),
        ],
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String text;
  const TipCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(50, size.height, 150, size.height - 20);
    path.quadraticBezierTo(size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
