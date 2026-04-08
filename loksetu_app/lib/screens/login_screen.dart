import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'admin_panel_screen.dart';

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
  bool _isAdmin = false; // New state for role

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF001F3F), // Navy Blue
              Color(0xFF003366), // Royal Blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lighter Premium Login Card for Contrast
                  Container(
                    padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92), // High-contrast Light Card
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Color(0xFF6A11CB).withOpacity(0.3),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 2,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF001F3F), // Navy Blue Text for Contrast
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Enter your credentials to continue",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 36),

                          // Role Selector
                          DropdownButtonFormField<bool>(
                            value: _isAdmin,
                            dropdownColor: Colors.white,
                            style: TextStyle(color: Color(0xFF333333)),
                            items: [
                              DropdownMenuItem(value: false, child: Text("Citizen", style: TextStyle(fontWeight: FontWeight.w600))),
                              DropdownMenuItem(value: true, child: Text("Admin", style: TextStyle(fontWeight: FontWeight.w600))),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _isAdmin = value);
                              }
                            },
                            decoration: _premiumInputDecoration(
                              label: "Select Role",
                              icon: Icons.person_outline,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Email / Phone
                          TextFormField(
                            controller: _emailOrPhoneController,
                            style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w600),
                            decoration: _premiumInputDecoration(
                              label: "Email or Mobile",
                              icon: Icons.alternate_email,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter email or phone"
                                : null,
                            onSaved: (value) => emailOrPhone = value!,
                          ),
                          SizedBox(height: 20),

                          // Password or OTP
                          Visibility(
                            visible: _isOtpSent || _emailOrPhoneController.text.contains('@'),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isOtpSent ? false : isObscured,
                              style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w600),
                              decoration: _premiumInputDecoration(
                                label: _isOtpSent ? "OTP Code" : "Password",
                                icon: _isOtpSent ? Icons.lock_clock_outlined : Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: _isOtpSent
                                    ? null
                                    : IconButton(
                                        icon: Icon(
                                          isObscured ? Icons.visibility : Icons.visibility_off,
                                          color: Color(0xFF6A11CB).withOpacity(0.6),
                                        ),
                                        onPressed: () => setState(() => isObscured = !isObscured),
                                      ),
                              ),
                              validator: (value) {
                                if (_isOtpSent) {
                                  return value == null || value.length != 6 ? "Enter 6-digit OTP" : null;
                                } else if (_emailOrPhoneController.text.contains('@')) {
                                  return value == null || value.isEmpty ? "Enter password" : null;
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) => password = value!,
                            ),
                          ),
                          SizedBox(height: 32),

                          // Login Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6A11CB).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        setState(() => _isLoading = true);
                                        // Authentication logic...
                                        try {
                                          if (_isOtpSent) {
                                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                              verificationId: _verificationId,
                                              smsCode: password,
                                            );
                                            UserCredential userCredential = await FirebaseAuth.instance
                                                .signInWithCredential(credential);
                                            _checkAdminAndNavigate(userCredential);
                                          } else if (emailOrPhone.contains('@')) {
                                            UserCredential userCredential = await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                              email: emailOrPhone,
                                              password: password,
                                            );
                                            _checkAdminAndNavigate(userCredential);
                                          } else {
                                            _sendOtp();
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          _showError(e.message ?? 'Login failed');
                                        } catch (e) {
                                          _showError('An error occurred');
                                        }
                                      }
                                    },
                              child: _isLoading
                                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text(
                                      _isOtpSent ? "Verify OTP" : "Login",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Forgot Password
                          TextButton(
                            onPressed: _handleForgotPassword,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Color(0xFFB39DDB), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen()));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Color(0xFFB39DDB), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _premiumInputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: Color(0xFF6A11CB), size: 22),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF6A11CB), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      filled: true,
      fillColor: Color(0xFFF8F9FA), // Clean light fill
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() => _isLoading = false);
  }

  Future<void> _checkAdminAndNavigate(UserCredential userCredential) async {
    if (_isAdmin && userCredential.user?.email != 'admin@gmail.com') {
      await FirebaseAuth.instance.signOut();
      _showError('Access Denied: You do not have Admin privileges.');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _isAdmin ? AdminPanelScreen() : HomeScreen(),
      ),
    );
  }

  Future<void> _sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: emailOrPhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        _checkAdminAndNavigate(userCredential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _showError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent to $emailOrPhone')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _handleForgotPassword() {
    String input = _emailOrPhoneController.text.trim();
    if (input.isEmpty) {
      _showError('Please enter your email or phone first');
      return;
    }
    if (input.contains('@')) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: input);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent')));
    } else {
      _showError('Password reset via SMS not implemented');
    }
  }
}
