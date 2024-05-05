import 'package:artwork_app/common/colors.dart';
//import 'package:artwork_app/common/paths.dart';
import 'package:artwork_app/features/auth/controller/auth_controller.dart';
import 'package:artwork_app/features/auth/views/sign_up_info.dart';
import 'package:artwork_app/features/auth/views/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sign.jpg'), // Fotoğrafın yolu burada belirtilmeli
                fit: BoxFit.cover,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: const BoxDecoration(
              color: Color(0xFF291C3C), // Kutucuk rengini siyah olarak ayarladık
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                           color: Colors.lightGreenAccent, // Yazı rengini açık yeşil olarak ayarladık
                           fontSize: 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is required.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.lightGreenAccent), // Label rengini açık yeşil olarak ayarladık
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                           style: TextStyle(color: Colors.lightGreenAccent), // Metin rengini açık yeşil olarak ayarladık                         
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password is required.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.lightGreenAccent), // Label rengini açık yeşil olarak ayarladık
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: borderColor,
                              ),
                            ),
                          ),
                          style: TextStyle(color: Colors.lightGreenAccent), // Metin rengini açık yeşil olarak ayarladık                          
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(authControllerProvider)
                                      .signUpWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      )
                                      .then(
                                        (value) => Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SignUpInfo(
                                              email: _emailController.text,
                                            ),
                                          ),
                                          (route) => false,
                                        ),
                                      );
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              color: signInButtonColor,
                              minWidth: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: textButtonTextColor,
                                fontSize: 15,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignIn(),
                                ),
                              ),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: signInButtonColor,
                                  fontSize: 14,
                                ),
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
          ),
        ],
      ),
    );
  }
}
