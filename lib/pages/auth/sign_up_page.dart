import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spaza/firebase/authentication/Auth.dart';
import 'package:spaza/firebase/database/database.dart';
import 'package:spaza/models/local_user.dart';
import 'package:spaza/pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/sign_up_page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<FormFieldState>();
  final _choiceFieldKey = GlobalKey<FormFieldState>();
  String finalImage = '';

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool hide = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  int _index = 0;
  int? yos;
  String? userType;

  List<Step> getSteps() {
    return [
      Step(
          state: _index == 0 ? StepState.editing : StepState.complete,
          title: Text(
            'Let\'s get to know you',
            style: GoogleFonts.roboto(),
          ),
          content: Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    key: _nameFieldKey,
                    onChanged: (value) {
                      setState(() {
                        _nameController.text = value;
                      });
                    },
                    onEditingComplete: () {
                      if (_nameFieldKey.currentState!.validate()) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: const InputDecoration(
                      focusColor: Colors.amber,
                      hoverColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Full names',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  )),
            ],
          )),
      Step(
          state: _index == 1
              ? StepState.editing
              : _index < 1
                  ? StepState.indexed
                  : StepState.complete,
          title: Text('Credentials'),
          content: Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      if (_emailFieldKey.currentState!.validate()) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    key: _emailFieldKey,
                    onChanged: (value) {
                      setState(() {
                        _emailController.text = value;
                      });
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
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    key: _passwordFieldKey,
                    onChanged: (value) {
                      setState(() {
                        _passwordController.text = value;
                      });
                    },
                    obscureText: true,
                    onEditingComplete: () {
                      if (_passwordFieldKey.currentState!.validate()) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      if (_passwordFieldKey.currentState!.validate()) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: const InputDecoration(
                      focusColor: Colors.amber,
                      hoverColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'password must be at least 6 characters long';
                      }
                      return null;
                    },
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    key: _confirmPasswordFieldKey,
                    onChanged: (value) {
                      setState(() {
                        _confirmPasswordController.text = value;
                      });
                      _confirmPasswordFieldKey.currentState!.validate();
                    },
                    decoration: const InputDecoration(
                      focusColor: Colors.amber,
                      hoverColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'confirm password',
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'passwords do not match';
                      }
                      return null;
                    },
                  )),
            ],
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Let\'s get you started!',
            style: GoogleFonts.abel(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Stack(alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   //image: AssetImage('lib/images/light1.png'),
              //   fit: BoxFit.cover,
              // ),

              ),
        ),
        //Lottie.asset('lib/animations/blob2.json', repeat: true, reverse: true, animate: true,),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Stepper(
                        physics: const NeverScrollableScrollPhysics(),
                        steps: getSteps(),
                        currentStep: _index,
                        onStepContinue: () {
                          print(_index);
                          setState(() {
                            if (_index == 0) {
                              if (_nameFieldKey.currentState!.validate()) {
                                _index++;
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                //todo: create user
                                submit();
                              }
                            }
                          });
                        },
                        onStepCancel: () {
                          setState(() {
                            if (_index > 0) {
                              _index--;
                            } else {
                              _index = 0;
                            }
                          });
                        },
                        onStepTapped: (index) {
                          setState(() {
                            _index = index;
                          });
                        },
                        elevation: 10,
                        type: StepperType.vertical,
                      ),
                    ],
                  )
                ]))
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void submit() async {
    String? uid = await Auth.signupWithEmail(
        context, _emailController.text.trim(), _passwordController.text.trim());

    if (uid != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign up success"),
      ));
      LocalUser user = LocalUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        isAdmin: false,
        uid: uid,
      );
      await Database.writeUser(user, context);
      //set user in provider
      // Provider.of<UserProvider>(context, listen: false).setUser(user);
      // LocalStorage.writeUserToLocalStorage(user);
      // print(Provider.of<UserProvider>(context, listen: false).user!.toString());
      MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => HomePage(),
          settings: RouteSettings(name: 'HomePage'));
      Navigator.pushReplacement(context, route);
    } else {
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign up failed"),
      ));
    }
  }
}
