import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:provider/provider.dart';

void userLogout(BuildContext context) async {
  final auth = Provider.of<AuthProvider>(context, listen: false);
  await auth.logout();
}
