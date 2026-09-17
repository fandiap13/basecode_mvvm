enum Flavor {
  dev(name: 'dev', label: 'DEV'),
  prod(name: 'prod', label: '');

  const Flavor({required this.name, required this.label});

  final String name;

  /// Label banner; kosong berarti tidak ditampilkan.
  final String label;

  bool get isDev => this == Flavor.dev;
}
