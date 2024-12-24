class AuthenticateEmailResponse {
  final String token;
  final String refreshToken;

  AuthenticateEmailResponse({required this.token, required this.refreshToken});
}
