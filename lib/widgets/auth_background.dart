import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [_BlueBox(), _HederIcon(), this.child],
      ),
    );
  }
}

class _HederIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Icon(
          Icons.person_pin_sharp,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class _BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _blueBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: -10, left: 10),
          Positioned(child: _Bubble(), top: 120, left: 150),
          Positioned(child: _Bubble(), top: 160, left: 360),
          Positioned(child: _Bubble(), top: 250, left: 10),
          Positioned(child: _Bubble(), top: 20, left: 380),
        ],
      ),
    );
  }

  BoxDecoration _blueBackground() => BoxDecoration(
      gradient:
          LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade600]));
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
