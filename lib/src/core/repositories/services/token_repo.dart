
abstract class ITokenRepo{
  Map<String, dynamic> decode(String token);
  bool isExpired(String token);
}