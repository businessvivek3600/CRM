import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Login'),
            ElevatedButton(onPressed: () {

            }, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
