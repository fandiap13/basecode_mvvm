import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => ShowcaseScreenState();
}

class ShowcaseScreenState extends State<ShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _isLoading = false;

  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Button')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Section('Variant'),
          for (final variant in AppButtonVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppButton(
                label: variant.name,
                variant: variant,
                isLoading: _isLoading,
                onPressed: () {},
              ),
            ),

          const _Section('Size'),
          for (final size in AppButtonSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppButton(
                label: size.name,
                size: size,
                isLoading: _isLoading,
                onPressed: () {},
              ),
            ),

          const _Section('Icon'),
          AppButton(
            label: 'Leading icon',
            leadingIcon: Icons.add,
            isLoading: _isLoading,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Trailing icon',
            trailingIcon: Icons.arrow_forward,
            isLoading: _isLoading,
            onPressed: () {},
          ),

          const _Section('Disabled'),
          const AppButton(label: 'Disabled', onPressed: null),

          const _Section('Expanded'),
          AppButton(
            label: 'Expanded',
            isExpanded: true,
            isLoading: _isLoading,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleLoading,
        icon: Icon(_isLoading ? Icons.stop : Icons.hourglass_empty),
        label: Text(_isLoading ? 'Stop loading' : 'Show loading'),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
