class RLogin {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  RLogin({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RLogin.successResponsefromJSON(Map<String, dynamic> json) {
    return RLogin(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}
