import 'package:chat_flutter_app/widgets/custom_button.dart';
import 'package:chat_flutter_app/widgets/login_bottom.dart';
import 'package:flutter/material.dart';

import 'package:chat_flutter_app/widgets/custom_logo.dart';
import 'package:chat_flutter_app/widgets/custom_input.dart';

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
                LoginBottomContainer(
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
            onPress: () {
              print('object');
            },
          ),
        ],
      ),
    );
  }
}
