import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;
  bool _isConfirmObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E8FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A11CB),
                  ),
                ),
                SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email";
                    }
                    if (!value.contains('@')) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _isObscured = !_isObscured),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmObscured,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () => _isConfirmObscured = !_isConfirmObscured,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A11CB),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    );

                                // Send email verification
                                await FirebaseAuth.instance.currentUser
                                    ?.sendEmailVerification();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Account created! Please check your email to verify.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Navigate back to login
                                Navigator.pop(context);
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = 'Registration failed';
                                if (e.code == 'weak-password') {
                                  errorMessage = 'Password is too weak';
                                } else if (e.code == 'email-already-in-use') {
                                  errorMessage = 'Email already exists';
                                } else if (e.code == 'invalid-email') {
                                  errorMessage = 'Invalid email format';
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('An error occurred')),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Create Account",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),

                SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to login
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Color(0xFF6A11CB)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
