import 'package:dashboard/core/sample_api/api_method.dart';
import 'package:dashboard/core/sample_api/api_service.dart';
import 'package:dashboard/models/user.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/hommi_logo.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController(text: "0999999999");
  final _passwordController = TextEditingController(text: 'password');
  bool _obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.blue.shade100],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    const HommiLogo(size: 60),
                    const SizedBox(height: 40),
                    // Welcome Text
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Log in to continue',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    // Phone Number Field
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                            });
                          }

                          final result = await SimpleApiService.instance
                              .makeRequest(
                                method: ApiMethod.post,
                                endpoint: "login",
                                body: {
                                  "phone_number": _phoneController.text,
                                  "password": _passwordController.text,
                                },
                              );

                          result.fold(
                            (error) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            (data) async {
                              final User user = User.fromJson(
                                data['data']['user'],
                              );
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              user.saveToPrefs();
                              final String token = data['data']['token'];
                              await prefs.setString('token', token);
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardScreen(user: user),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
