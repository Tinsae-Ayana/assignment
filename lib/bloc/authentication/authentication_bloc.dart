import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc()
      : super(const AuthenticationState(
          status: null,
          verificationId: null,
          phoneNumber: '',
          otp: '',
          resendToken: null,
        )) {
    on<PhoneNumberEvent>(_phoneNumberEvent);
    on<PhoneVerificationEvent>(_onPhoneVerficationEvent);
    on<OtpEvent>(_onOtpEvent);
    on<StatusEvent>(_onStatusEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
    on<SubmitOtpEvent>(_onSubitOtpEvent);
    on<ResendButtonEvent>(_onResendButton);
    on<LogoutEvent>(_onLogoutEvent);
  }
  _phoneNumberEvent(PhoneNumberEvent event, emit) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  _onPhoneVerficationEvent(PhoneVerificationEvent event, emit) {
    emit(state.copyWith(
        verificationId: event.verficationId, resendToken: event.resendToken));
  }

  _onOtpEvent(OtpEvent event, emit) {
    emit(state.copyWith(otp: event.otp));
  }

  _onStatusEvent(StatusEvent event, emit) {
    emit(state.copyWith(status: event.status));
  }

  _onLogoutEvent(event, emit) {
    FirebaseAuth.instance.signOut();
  }

  _onNextButtonEvent(NextButtonEvent event, emit) {
    add(StatusEvent(status: AuthStatus.inProgress));

    if (inputValidationPhoneNumber()) {
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: state.phoneNumber,
          verificationCompleted: (phoneCredential) {
            add(StatusEvent(status: AuthStatus.loginSucess));
          },
          verificationFailed: (exception) {
            add(StatusEvent(status: AuthStatus.submitionFailure));
          },
          codeSent: ((verificationId, forceResendingToken) {
            add(PhoneVerificationEvent(
                verficationId: verificationId,
                resendToken: forceResendingToken));
            add(StatusEvent(status: AuthStatus.submitionSuccess));
          }),
          codeAutoRetrievalTimeout: (_) {});
    } else {
      add(StatusEvent(status: AuthStatus.invalidInput));
    }
  }

  _onSubitOtpEvent(SubmitOtpEvent event, emit) async {
    add(StatusEvent(status: AuthStatus.inProgress));

    if (inputValidationOtp()) {
      final credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId!, smsCode: state.otp);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user == null) {
        add(StatusEvent(status: AuthStatus.submitionFailure));
      } else {
        add(StatusEvent(status: AuthStatus.loginSucess));
      }
    } else {
      add(StatusEvent(status: AuthStatus.invalidInput));
    }
  }

  _onResendButton(ResendButtonEvent event, emit) {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: state.phoneNumber,
        forceResendingToken: state.resendToken,
        verificationCompleted: (phoneCredential) {
          add(StatusEvent(status: AuthStatus.loginSucess));
        },
        verificationFailed: (exception) {
          add(StatusEvent(status: AuthStatus.submitionFailure));
        },
        codeSent: ((verificationId, forceResendingToken) {
          add(PhoneVerificationEvent(
              verficationId: verificationId, resendToken: forceResendingToken));
          add(StatusEvent(status: AuthStatus.submitionSuccess));
        }),
        codeAutoRetrievalTimeout: (_) {});
  }

  bool inputValidationPhoneNumber() {
    final RegExp phoneNumberRegExp = RegExp(
      r'^\+[0-9]{12}$',
    );

    if (phoneNumberRegExp.hasMatch(state.phoneNumber)) {
      return true;
    } else {
      return false;
    }
  }

  bool inputValidationOtp() {
    RegExp otpRegExp = RegExp(
      r'^[0-9]{6}$',
    );

    if (otpRegExp.hasMatch(state.otp)) {
      return true;
    } else {
      return false;
    }
  }
}
