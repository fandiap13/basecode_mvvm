import 'package:flutter/material.dart';

enum ShowcaseCategory { component, foundation }

class ShowcaseEntry {
  const ShowcaseEntry({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    this.category = ShowcaseCategory.component,
    this.isReady = false,
  });

  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final ShowcaseCategory category;

  // Screen tujuannya sudah ada; yang false tampil redup dan tidak bisa diklik.
  final bool isReady;
}
