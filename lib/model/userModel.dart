import 'dart:convert';

import 'package:hive/hive.dart';

part 'adapters/userModel.g.dart';

@HiveType(typeId: 13)
class User {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? jwtToken;
  @HiveField(3)
  String? email;
  @HiveField(4)
  Map? avatarUrls;
  @HiveField(5)
  Map? links;
  @HiveField(6)
  String? address_1;
  @HiveField(7)
  String? address_2;
  @HiveField(8)
  String? city;
  @HiveField(9)
  String? company;
  @HiveField(10)
  String? country;
  @HiveField(11)
  String? firstName;
  @HiveField(12)
  String? lastName;

  User(
      {this.id,
      this.name,
      this.jwtToken,
      this.email,
      this.avatarUrls,
      this.links,
      this.address_1,
      this.address_2,
      this.city,
      this.company,
      this.country,
      this.firstName,
      this.lastName});

  static User fromJson(Map<String, dynamic?> jsonString) {
    Map<String, dynamic?> blog = jsonString;
    return User(
      id: blog['id'],
      name: blog['name'],
      firstName: blog['first_name'],
      lastName: blog['last_name'],
      email: blog['email'],
      avatarUrls: blog['avatar_urls'],
      links: blog['_links'],
      address_1: blog['address_1'],
      address_2: blog['address_2'],
      city: blog['city'],
      company: blog['company'],
      country: blog['country'],
    );
  }

  String toJson() => json.encode({
        "id": this.id.toString(),
        "name": this.name.toString(),
        "email": this.email.toString(),
        "avatarUrls": this.avatarUrls.toString(),
        "links": this.links.toString(),
        "address_1": this.address_1.toString(),
        "address_2": this.address_2.toString(),
        "city": this.city.toString(),
        "company": this.company.toString(),
        "country": this.country.toString(),
      });

  // Future<List<User>> fetch() async {
  //   List<dynamic> data = await super.fetch();
  //   List<User> users = new List();
  //   int i = 0;
  //   data.forEach((element) {
  //     users.add(User.fromJson(element));
  //     i++;
  //   });
  //   return users;
  // }
}
