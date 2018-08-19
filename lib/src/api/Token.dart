class Token {
  final String token;
  final DateTime createdAt;

  Token({this.token, this.createdAt});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String obscuredToken() {
    return token.replaceRange(4, token.length - 4, "•" * (token.length - 8));
  }
}
