import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter_app/widgets/custom_logo.dart';
import 'package:chat_flutter_app/widgets/custom_input.dart';
import 'package:chat_flutter_app/widgets/custom_button.dart';
import 'package:chat_flutter_app/widgets/login_bottom.dart';

import 'package:chat_flutter_app/services/auth_service.dart';
import 'package:chat_flutter_app/services/socket_service.dart';
import 'package:chat_flutter_app/helpers/show_alert.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(
                  title: 'Inicia sesion',
                ),
                _Form(),
                const LoginBottomContainer(
                  routeToNevigate: 'register',
                  title: 'Aun no tienes una cuenta?',
                  subtitle: 'Crear una cuenta',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_open,
            placeholder: 'Clave',
            textController: passController,
            isPassword: true,
          ),
          CustomButton(
            text: 'Conectar',
            isLoading: authService.isLoading,
            onPress: authService.isLoading
                ? () {}
                : () async {
                    // Dispose any focused input selected (for hidden mobile keyboard)
                    FocusScope.of(context).unfocus();

                    final result = await authService.login(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );

                    if (!context.mounted) return;

                    if (result == 'OK') {
                      socketService.connect();

                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(context, 'Atención', result);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
