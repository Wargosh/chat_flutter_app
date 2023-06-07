import 'package:flutter/material.dart';

class LoginBottomContainer extends StatelessWidget {
  final String routeToNevigate;
  final String title;
  final String subtitle;

  const LoginBottomContainer({
    super.key,
    required this.routeToNevigate,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, routeToNevigate);
            },
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Terminos y condiciones de uso',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
