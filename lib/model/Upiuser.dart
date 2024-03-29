class Upiuser {
  int id;
  String firstName;
  String upiid;

  Upiuser({
    required this.id,
    required this.firstName,
    required this.upiid,
  });

  factory Upiuser.fromJson(Map<String, dynamic> data) => new Upiuser(
        id: data["id"],
        firstName: data["first_name"],
        upiid: data["upiid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "upiid": upiid,
      };
}
