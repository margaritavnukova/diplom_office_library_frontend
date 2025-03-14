import 'item_base_class.dart';
import '../assets/strings.dart';

class Genre implements Item {
  @override String? id;
  @override String? name;
  final String? description;

  Genre({
    this.id = "",
    required this.name,
    this.description,
  });

  @override
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json[GenreJsonKeys.id],
      name: json[GenreJsonKeys.name],
      description: json[GenreJsonKeys.description],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      GenreJsonKeys.id: id,
      GenreJsonKeys.name: name,
      GenreJsonKeys.description: description,
    };
  }

  String toJsonStr() => toJson().toString();
}
