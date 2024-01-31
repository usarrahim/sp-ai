import 'package:flutter/material.dart';
import 'package:sp_ai/auth/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_ai/auth/auth_bloc/auth_states.dart';

class RegisterOrLoginScreen extends StatefulWidget {
  const RegisterOrLoginScreen({Key? key}) : super(key: key);

  @override
  _RegisterOrLoginScreenState createState() => _RegisterOrLoginScreenState();
}

class _RegisterOrLoginScreenState extends State<RegisterOrLoginScreen> {
  PhoneAuthBloc phoneAuthBloc = PhoneAuthBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                child: Column(children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.runtimeType == AuthInitianState
                              ? "Telefon numarası Giriniz"
                              : "Doğrulama Kodu Giriniz",
                          style:
                              TextStyle(color: Color(0xFF4DC5E5), fontSize: 22),
                        ),
                        state.runtimeType == AuthLoadingState
                            ? Container(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Color(0xFFE0A941),
                                ),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_vert_outlined,
                                  color: Color(0xFFE0A941),
                                ))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        decoration: BoxDecoration(
                            color: Color(0xFFDCDFE0),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFDCDFE0)),
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        decoration: BoxDecoration(
                            color: Color(0xFFDCDFE0),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFDCDFE0)),
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthLoggedInState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Oturum açma başarılı.")));
        }

        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
    );
  }
}
