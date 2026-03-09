import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String emailOrPhone = '';
  String password = '';
  bool isObscured = true;

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

                // Password
                TextFormField(
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => isObscured = !isObscured),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter password" : null,
                  onSaved: (value) => password = value!,
                ),
                SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A11CB),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // TODO: Replace with backend authentication
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      }
                    },
                    child: Text("Login", style: TextStyle(fontSize: 16)),
                  ),
                ),

                SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    // TODO: Navigate to Forgot Password / OTP
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