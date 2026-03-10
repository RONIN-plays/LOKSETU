import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String emailOrPhone = '';
  String password = '';
  bool isObscured = true;
  bool _isLoading = false;
  bool _isOtpSent = false;
  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailOrPhoneController.removeListener(() {});
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
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
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A11CB),
                  ),
                ),
                SizedBox(height: 20),

                // Email / Phone
                TextFormField(
                  controller: _emailOrPhoneController,
                  decoration: InputDecoration(
                    labelText: "Email or Mobile",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter email or phone"
                      : null,
                  onSaved: (value) => emailOrPhone = value!,
                ),
                SizedBox(height: 16),

                // Password or OTP
                Visibility(
                  visible: _isOtpSent || _emailOrPhoneController.text.contains('@'),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isOtpSent ? false : isObscured,
                    decoration: InputDecoration(
                      labelText: _isOtpSent ? "OTP Code" : "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: _isOtpSent ? null : IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => isObscured = !isObscured),
                      ),
                    ),
                    validator: (value) {
                      if (_isOtpSent) {
                        return value == null || value.length != 6
                            ? "Enter 6-digit OTP"
                            : null;
                      } else if (_emailOrPhoneController.text.contains('@')) {
                        return value == null || value.isEmpty
                            ? "Enter password"
                            : null;
                      } else {
                        return null; // No validation for phone before OTP
                      }
                    },
                    onSaved: (value) => password = value!,
                  ),
                ),
                SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A11CB),
                    ),
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() => _isLoading = true);
                        try {
                          if (_isOtpSent) {
                            // Verify OTP
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                              verificationId: _verificationId,
                              smsCode: password,
                            );
                            await FirebaseAuth.instance.signInWithCredential(credential);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          } else if (emailOrPhone.contains('@')) {
                            // Email login
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailOrPhone,
                              password: password,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          } else {
                            // Send OTP for phone
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: emailOrPhone,
                              verificationCompleted: (PhoneAuthCredential credential) async {
                                await FirebaseAuth.instance.signInWithCredential(credential);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomeScreen()),
                                );
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message ?? 'Verification failed')),
                                );
                                setState(() => _isLoading = false);
                              },
                              codeSent: (String verificationId, int? resendToken) {
                                setState(() {
                                  _verificationId = verificationId;
                                  _isOtpSent = true;
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('OTP sent to $emailOrPhone')),
                                );
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {
                                _verificationId = verificationId;
                              },
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message ?? 'Login failed')),
                          );
                          setState(() => _isLoading = false);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred')),
                          );
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(_isOtpSent ? "Verify OTP" : "Login", style: TextStyle(fontSize: 16)),
                  ),
                ),

                SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    String input = _emailOrPhoneController.text.trim();
                    if (input.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter your email or phone first')),
                      );
                      return;
                    }
                    if (input.contains('@')) {
                      FirebaseAuth.instance.sendPasswordResetEmail(email: input);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset email sent')),
                      );
                    } else {
                      // For phone, perhaps implement phone reset, but for now
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset via SMS not implemented')),
                      );
                    }
                  },
                  child: Text(
                    "Forgot Password?",
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