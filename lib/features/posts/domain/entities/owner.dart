import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;

  const Owner({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
  });

  @override
  List<Object> get props => [id, title, firstName, lastName, picture];
}
