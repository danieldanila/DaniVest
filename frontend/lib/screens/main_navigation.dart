import 'package:flutter/material.dart';
import 'package:frontend/widgets/full_navigation.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.homepageShowCardDetails = false,
  });

  final int initialIndex;
  final bool homepageShowCardDetails;

  @override
  Widget build(BuildContext context) {
    return FullNavigation(
      initialIndex: initialIndex,
      homepageShowCardDetails: homepageShowCardDetails,
    );
  }
}
