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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool obscureText = true;
  bool isRememberMe = false;

  setObscureText() => setState(() => obscureText = !obscureText);

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _login() async {
    if (!_loginFormKey.currentState!.validate()) return;
    _loginFormKey.currentState!.save();
    setState(() => _isLoading = true);

    AuthService()
        .login(context, _emailController.text, _passwordController.text)
        .then((value) async {
      setState(() => _isLoading = false);
      if (appStore.isLoggedIn) {
        appStore.setIsLoggedIn(true);
        await appStore.saveCredentials(
            _emailController.text, _passwordController.text);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
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
    return Scaffold(
      backgroundColor: const Color(0xFF373b44),
      resizeToAvoidBottomInset:
          true, // Allows content to adjust when keyboard opens
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png", height: 90),
                    const SizedBox(height: 25),
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    const Text("Login to your account",
                        style: TextStyle(fontSize: 18, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),),
                  ],
                ),
                child: SingleChildScrollView(
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents scrolling
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom * 0.4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _loginFormKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 15), // Space above Email
                              CommonTextField(
                                label: "Email",
                                hint: "test@gmail.com",
                                controller: _emailController,
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter username or Login ID'
                                    : null,
                              ),
                              const SizedBox(
                                  height: 15), // Space between fields
                              CommonTextField(
                                label: "Password",
                                controller: _passwordController,
                                isPassword: true,
                                maxLines: 1,
                              ),
                              const SizedBox(
                                  height: 15), // Space above Checkbox
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Observer(
                                        builder: (_) => Checkbox(
                                          value: isRememberMe,
                                          checkColor: Colors.white,
                                          onChanged: (value) => setState(
                                              () => isRememberMe = value!),
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const Text("Remember Me",
                                          style:
                                              TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: Color(0xFF007BFF),
                                        fontWeight: FontWeight.bold),
                                  ), 
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15), // Space above button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: secondaryPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text("Sign In",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 5), // Small gap after the button
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
