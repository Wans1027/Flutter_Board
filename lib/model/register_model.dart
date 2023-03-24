class RegitserModel {
  final int id;

  const RegitserModel({required this.id});

  factory RegitserModel.fromJson(Map<String, dynamic> json) {
    return RegitserModel(
      id: json['id'],
    );
  }
}

class LoginFailModel {
  final String code, message;

  const LoginFailModel({required this.code, required this.message});

  factory LoginFailModel.fromJson(Map<String, dynamic> json) {
    return LoginFailModel(
      code: json['code'],
      message: json['message'],
    );
  }
}
