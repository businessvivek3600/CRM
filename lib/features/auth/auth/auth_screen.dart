import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../services/auth_services.dart';
import '../../../store/app_store.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _isLoading = false;
  bool obscureText = true;
  bool isRememberMe = false;
  setObscureText() => setState(() => obscureText = !obscureText);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedCredentials();
  }

  void _login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    _loginFormKey.currentState!.save();
    setState(() => _isLoading = true);
    AuthService()
        .login(
      context,
      _emailController.text,
      _passwordController.text,
    )
        .then((value) async {
      setState(() => _isLoading = false);
      if (appStore.isLoggedIn) {
        appStore.setIsLoggedIn(true);
        await appStore.saveCredentials(
            _emailController.text, _passwordController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (_) => false);
      }
    });
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await appStore.loadCredentials();
    setState(() {
      _emailController.text = credentials['email'] ?? '';
      _passwordController.text = credentials['password'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF373b44),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: screenHeight /
                      2.1, // First container takes half of the screen height
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      //Logo and Text
                      Expanded(
                        child: Image.asset(
                          "assets/logo.png",
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Login to your account",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: screenHeight / 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CommonTextField(
                        label: "Email",
                        hint: "test@gmail.com",
                        controller: _emailController,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter username Or Login ID';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      // Password TextField
                      CommonTextField(
                        label: "Password",
                        controller: _passwordController,
                        isPassword: true,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      // Remember Me and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Observer(
                                builder: (_) => Checkbox(
                                  value: isRememberMe,
                                  checkColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      isRememberMe = value!;
                                    });
                                    print(
                                        'Remember Me State: ${appStore.rememberMe}');
                                  },
                                  activeColor: Theme.of(context)
                                      .primaryColor, // Primary color for the checkbox
                                ),
                              ),
                              const Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFF007BFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor:
                                secondaryPrimaryColor, // Primary color for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
