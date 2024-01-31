abstract class AuthEvent {}

class SendCodeEvent extends AuthEvent {
  String phoneNumber;
  SendCodeEvent(this.phoneNumber);
}

class ConfirmCodeEvent extends AuthEvent {
  String verificationID;
  String verifyCode;
  ConfirmCodeEvent(this.verificationID, this.verifyCode);
}
