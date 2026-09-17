import 'package:flutter/material.dart';

class SectionShowcase extends StatelessWidget {
  const SectionShowcase(this.title, {super.key, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (description != null) ...[
            SizedBox(height: 4),
            Text(description!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
