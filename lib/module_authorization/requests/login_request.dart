class LoginRequest {
  late String email;
  late String password;
  LoginRequest(this.email, this.password);

  LoginRequest.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.password = map['password'];
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic>  map ={};
    map['email'] = this.email;
    map['password'] = this.password;
    return map;
  }
}
