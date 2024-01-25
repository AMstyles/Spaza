class LocalUser{
  String? uid;
  final String name;
  final String email;
  final bool isAdmin;

  LocalUser({this.uid, required this.name, required this.email, required this.isAdmin});

  factory LocalUser.fromJson(Map<String, dynamic> json){
    return LocalUser(
      name: json['name'],
      email: json['email'],
      isAdmin: json['isAdmin']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin
    };
  }


  
}