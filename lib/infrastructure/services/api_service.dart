import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;

  ApiService({required this.client});
}