import 'item_base_class.dart';
import '../assets/strings.dart';

class Author implements Item {
  @override String? id;
  @override String? name;
  final String? lifetime;
  final String? country;
  final String? photoBase64;

  Author({
    this.id = "",
    required this.name,
    this.country,
    this.lifetime,
    this.photoBase64
  });

  @override
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json[AuthorJsonKeys.id],
      name: json[AuthorJsonKeys.name],
      lifetime: json[AuthorJsonKeys.lifetime],
      country: json[AuthorJsonKeys.country],
      photoBase64: json[UserJsonKeys.photoBase64],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      AuthorJsonKeys.id: id,
      AuthorJsonKeys.name: name,
      AuthorJsonKeys.country: country ?? "Страна неизвестна",
      AuthorJsonKeys.lifetime: lifetime ?? "Время жизни неизвестно",
      UserJsonKeys.photoBase64: photoBase64,
    };
  }

  String toJsonStr() => toJson().toString();
}
