import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spaza/widgets/login_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  static const routeName = '/forgot_password';
  final _emailFieldKey = GlobalKey<FormFieldState>();
  late final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            'Forgot Password',
            style: GoogleFonts.abel(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          leading: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),

            child:IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

          ),
        ),


        body: Form(child:ListView(
              children: [
                SizedBox(
                  height: 330,
                  child:Image.asset('lib/illustrations/forgot_password.png')),

                Padding(padding: const EdgeInsets.all(10),
                  child: Text('Reset Password', style: GoogleFonts.abel(fontSize: 30, fontWeight: FontWeight.bold),),),

                Text('Please enter your email address to reset your password', style: GoogleFonts.abel(fontSize: 15,color: Colors.blueGrey ),),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {

                      _emailFieldKey.currentState!.validate();
                      FocusScope.of(context).nextFocus();
                    },
                    key: _emailFieldKey,
                    onChanged: (value) {
                        _emailController.text = value;
                    },

                    decoration: const InputDecoration(
                      focusColor: Colors.amber,
                      hoverColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),),

                LoginButton(onPressed: (){}, text: "Reset Password"),
              ],
            ),
            )

    );
  }
}