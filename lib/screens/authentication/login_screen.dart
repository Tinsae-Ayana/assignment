import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_assignment/bloc/authentication/authentication_bloc.dart';
import 'package:intern_assignment/screens/authentication/otp_screen.dart';
import 'package:intern_assignment/screens/home/home.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthStatus.loginSucess) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const HomeScreen())));
        }
        if (state.status == AuthStatus.submitionSuccess) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const OtpScreen())));
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/image/user.png',
                //   height: 100,
                //   width: 100,
                // ),
                const SizedBox(
                  height: 35,
                ),
                Text('Wellcome!',
                    style: GoogleFonts.bebasNeue(
                        fontWeight: FontWeight.normal, fontSize: 34)),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  'Assignment for Intern',
                  style: GoogleFonts.bebasNeue(
                      fontWeight: FontWeight.normal, fontSize: 24),
                ),
                const SizedBox(height: 25),
                // Builder(builder: (context) {
                //   return _nameTextField(context);
                // }),
                const SizedBox(height: 50),
                Builder(builder: (context) {
                  return _phoneInputField(context);
                }),
                const SizedBox(height: 50),
                Builder(builder: (context) {
                  return _loginButton(context);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneInputField(context) {
    return IntlPhoneField(
      showCursor: false,
      style: GoogleFonts.bebasNeue(),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.black, width: 3, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(30)),
        hintText: 'Phone Number',
        hintStyle: GoogleFonts.bebasNeue(),
      ),
      initialCountryCode: 'ET',
      onChanged: (phone) {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(PhoneNumberEvent(phoneNumber: phone.completeNumber));
      },
    );
  }

  // Widget _nameTextField(context) {
  //   return TextField(
  //     showCursor: false,
  //     keyboardType: TextInputType.name,
  //     style: GoogleFonts.bebasNeue(),
  //     decoration: InputDecoration(
  //       prefixIcon: const Icon(
  //         Icons.person,
  //         color: Colors.blue,
  //       ),
  //       border: OutlineInputBorder(
  //           borderSide: const BorderSide(
  //               color: Colors.black, width: 3, style: BorderStyle.none),
  //           borderRadius: BorderRadius.circular(30)),
  //       hintText: 'Name',
  //       hintStyle: GoogleFonts.bebasNeue(),
  //     ),
  //     onChanged: (name) {},
  //   );
  // }

  Widget _loginButton(context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.status == AuthStatus.inProgress
            ? const CircularProgressIndicator()
            : Container(
                height: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(NextButtonEvent());
                    },
                    child: Text(
                      'Next',
                      style: GoogleFonts.bebasNeue(
                          fontWeight: FontWeight.normal, fontSize: 24),
                    )),
              );
      },
    );
  }
}
