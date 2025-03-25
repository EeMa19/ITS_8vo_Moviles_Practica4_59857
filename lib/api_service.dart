import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String _apiUrl = dotenv.get('API_URL');
  static String? _token; // Variable para almacenar el token

  // Método para iniciar sesión
  static Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/api/auth/login'), // Corregido a /api/auth/login
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token']; // El token se devuelve en el campo "token"
      return _token;
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  // Método para registrar un nuevo usuario
  static Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/api/auth/register'), // Corregido a /api/auth/register
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al registrar: ${response.body}');
    }
  }

  // Obtener todas las tareas
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/api/tareas'), // Prefijo /api/tareas está correcto según TareaController
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar las tareas: ${response.body}');
    }
  }

  // Obtener una tarea por ID
  static Future<Map<String, dynamic>> getTaskById(int id) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar la tarea: ${response.body}');
    }
  }

  // Crear una nueva tarea
  static Future<Map<String, dynamic>> createTask(Map<String, dynamic> task) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/api/tareas'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: json.encode(task),
    );
    if (response.statusCode == 200) { // Nota: debería ser 201 según TareaController
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al crear la tarea: ${response.body}');
    }
  }

  // Actualizar una tarea
  static Future<Map<String, dynamic>> updateTask(int id, Map<String, dynamic> task) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: json.encode(task),
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la tarea: ${response.body}');
    }
  }

  // Marcar una tarea como completada
  static Future<Map<String, dynamic>> toggleTaskCompletion(int id, bool completed) async {
    final response = await http.patch(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: json.encode({'completada': completed}),
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la tarea: ${response.body}');
    }
  }

  // Eliminar una tarea
  static Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la tarea: ${response.body}');
    }
  }
}