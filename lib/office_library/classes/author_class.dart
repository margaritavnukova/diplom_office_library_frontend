import 'item_base_class.dart';
import '../assets/strings.dart';

class Author implements Item {
  @override String? id;
  @override String? name;
  final String? lifetime;
  final String? country;

  Author({
    this.id = "",
    required this.name,
    this.country,
    this.lifetime,
  });

  @override
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json[AuthorJsonKeys.id],
      name: json[AuthorJsonKeys.name],
      lifetime: json[AuthorJsonKeys.lifetime],
      country: json[AuthorJsonKeys.country],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      AuthorJsonKeys.id: id,
      AuthorJsonKeys.name: name,
      AuthorJsonKeys.country: country,
      AuthorJsonKeys.lifetime: lifetime,
    };
  }

  String toJsonStr() => toJson().toString();
}
