import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spaza/firebase/authentication/Auth.dart';
import 'package:spaza/pages/auth/forgot_password_page.dart';
import 'package:spaza/pages/auth/sign_up_page.dart';
import 'package:spaza/pages/home_page.dart';
import 'package:spaza/widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  var brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                ),
              )),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome to Lucky\'s Spaza',
          style: GoogleFonts.abel(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      extendBody: true,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/light1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 330,
                child: Image.asset("lib/illustrations/login_bot.png"),
              ),

              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    focusColor: Colors.amber,
                    hoverColor: Colors.amber,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    focusColor: Colors.red,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              //forgot password text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ForgotPasswordPage()));
                  },
                  child: const Text('Forgot password?',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ),
              LoginButton(
                  onPressed: () {
                    login(context);
                  },
                  text: 'Login'),
              const SizedBox(height: 20),
              const Text("Not already part of the gang?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return SignUpPage();
                  }));
                },
                child: const Text("Sign up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void login(BuildContext context) async {
    Auth.signInWithEmail(
        _emailController.text.trim(), _passwordController.text.trim(), context);
    // final thing = await Auth.getUID();
    // print('thing is $thing');
  }
}
