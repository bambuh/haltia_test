final class User {
  final String id;
  final String? firstName;
  final String? lastName;

  const User({
    required this.id,
    this.firstName,
    this.lastName,
  });
}
