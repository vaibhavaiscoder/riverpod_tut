// To parse this JSON data, do
//
//     final createUser = createUserFromJson(jsonString);

import 'dart:convert';

CreateUser createUserFromJson(String str) => CreateUser.fromJson(json.decode(str));

String createUserToJson(CreateUser data) => json.encode(data.toJson());

class CreateUser {
  String name;
  String job;
  String id;
  DateTime createdAt;

  CreateUser({
    required this.name,
    required this.job,
    required this.id,
    required this.createdAt,
  });

  CreateUser copyWith({
    String? name,
    String? job,
    String? id,
    DateTime? createdAt,
  }) =>
      CreateUser(
        name: name ?? this.name,
        job: job ?? this.job,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
      );

  factory CreateUser.fromJson(Map<String, dynamic> json) => CreateUser(
    name: json["name"],
    job: json["job"],
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "job": job,
    "id": id,
    "createdAt": createdAt.toIso8601String(),
  };
}
