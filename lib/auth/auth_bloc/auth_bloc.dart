import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sp_ai/auth/auth_bloc/auth_events.dart';
import 'package:sp_ai/auth/auth_bloc/auth_states.dart';

class PhoneAuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  PhoneAuthBloc() : super(AuthInitianState()) {
    on((SendCodeEvent event, emit) {
      emit(AuthLoadingState());
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          emit(AuthCodeSentState(verificationId));
        },
        verificationCompleted: (phoneAuthCredential) {
          emit(AuthCodeVerifiedState());
        },
        verificationFailed: (error) {
          emit(AuthErrorState(error.message.toString()));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationId = verificationId;
        },
      );
    });

    on((ConfirmCodeEvent event, emit) async {
      emit(AuthLoadingState());
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationID, smsCode: event.verifyCode);
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        if (userCredential.user != null) {
          emit(AuthLoggedInState(userCredential.user!));
        }
      } on FirebaseAuthException catch (ex) {
        emit(AuthErrorState(ex.message.toString()));
      }
    });
  }
}
