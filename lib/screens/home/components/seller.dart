import 'package:flutter/material.dart';

class Seller extends StatelessWidget {
  const Seller({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                FocusScope.of(context).unfocus(); // Hide keyboard
                Navigator.pushNamed(context, "/home"); // Replace with actual route
              }
            },
            child: const Text("Sell your product"),
          ),
        ],
      
    );
  }
}
