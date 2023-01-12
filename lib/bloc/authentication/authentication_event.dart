part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

class PhoneNumberEvent extends AuthenticationEvent {
  final String phoneNumber;
  PhoneNumberEvent({required this.phoneNumber});
}

class PhoneVerificationEvent extends AuthenticationEvent {
  final String? verficationId;
  final int? resendToken;
  PhoneVerificationEvent(
      {required this.verficationId, required this.resendToken});
}

class OtpEvent extends AuthenticationEvent {
  final String otp;
  OtpEvent({required this.otp});
}

class StatusEvent extends AuthenticationEvent {
  final AuthStatus status;
  StatusEvent({required this.status});
}

class NextButtonEvent extends AuthenticationEvent {}

class SubmitOtpEvent extends AuthenticationEvent {}

class ResendButtonEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}
