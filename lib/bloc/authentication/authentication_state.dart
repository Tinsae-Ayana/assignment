part of 'authentication_bloc.dart';

enum AuthStatus {
  inProgress,
  submitionSuccess,
  submitionFailure,
  validInput,
  invalidInput,
  loginSucess
}

class AuthenticationState extends Equatable {
  final AuthStatus? status;
  final String phoneNumber;
  final String otp;
  final String? verificationId;
  final int? resendToken;

  const AuthenticationState(
      {required this.status,
      required this.phoneNumber,
      required this.otp,
      required this.verificationId,
      required this.resendToken});

  @override
  List<Object?> get props =>
      [status, phoneNumber, otp, verificationId, resendToken];

  copyWith({status, phoneNumber, otp, verificationId, resendToken}) {
    return AuthenticationState(
        status: status ?? this.status,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        otp: otp ?? this.otp,
        verificationId: verificationId ?? this.verificationId,
        resendToken: resendToken ?? this.resendToken);
  }
}
