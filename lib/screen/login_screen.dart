import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Data login yang valid
  final String validUsername = "user@rams.co.id";
  final String validPassword = "userRams200!!";

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email == validUsername && password == validPassword) {
      // Jika login berhasil, pindah ke HomeScreen
      Navigator.pushReplacementNamed(context, '/map');
    } else {
      // Jika login gagal, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid username or password!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: Color(0xff3a57e8),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 100, 40, 20), // Padding kanan-kiri lebih dalam
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Padding lebih rapi
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Logo dengan ukuran yang sama dan responsif
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            "assets/logo pertamina 1.png",
                            fit: BoxFit.contain,
                            height: 80,
                          ),
                        ),
                        const SizedBox(width: 20), // Jarak seimbang antara logo
                        Expanded(
                          child: Image.asset(
                            "assets/aislogo.png",
                            fit: BoxFit.contain,
                            height: 80,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Teks Login di tengah
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),

                    // Input Email dengan padding lebih dalam
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20), // Padding lebih dalam
                          hintText: "Enter Email",
                          hintStyle: const TextStyle(fontSize: 14, color: Color(0xff494646)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff000000), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff000000), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // Input Password dengan padding lebih dalam
                    TextField(
                       controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20), // Padding lebih dalam
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(fontSize: 14, color: Color(0xff494646)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xff000000), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xff000000), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // Lupa Password
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 30),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xff3a57e8),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Login
                    MaterialButton(
                      onPressed: _login,
                      color: const Color(0xff3a57e8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xffffffff),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Daftar Akun
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 14, color: Color(0xff000000)),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "SignUp",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
