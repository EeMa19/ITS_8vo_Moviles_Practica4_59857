import 'package:flutter/material.dart';

class AuthScreens extends StatefulWidget {
  const AuthScreens({super.key});

  @override
  State<AuthScreens> createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  bool isLogin = true; // Para alternar entre login y registro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Iniciar Sesión' : 'Registrarse'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AuthForm(
          isLogin: isLogin,
          onSwitch: () {
            setState(() {
              isLogin = !isLogin;
            });
          },
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final VoidCallback onSwitch;

  const AuthForm({super.key, required this.isLogin, required this.onSwitch});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Validar email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor ingrese un correo válido';
    }
    return null;
  }

  // Validar contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Aquí iría la lógica para enviar los datos al backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isLogin
              ? 'Iniciando sesión...'
              : 'Registrando usuario...'),
        ),
      );
      // Por ahora, solo navegamos a la pantalla principal si es login
      if (widget.isLogin) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'ejemplo@dominio.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.isLogin ? 'Iniciar Sesión' : 'Registrarse'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.onSwitch,
            child: Text(widget.isLogin
                ? '¿No tienes cuenta? Regístrate'
                : '¿Ya tienes cuenta? Inicia sesión'),
          ),
        ],
      ),
    );
  }
}