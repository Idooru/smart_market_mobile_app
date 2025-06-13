import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Smart Market", style: TextStyle(color: Color.fromARGB(255, 190, 190, 190), fontSize: 40)),
                  SizedBox(height: 15),
                  CircularProgressIndicator(color: Color.fromARGB(255, 190, 190, 190)),
                ],
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
