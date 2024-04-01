import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreViewScreen extends ConsumerStatefulWidget {
  const ExploreViewScreen({super.key});
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const ExploreViewScreen());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExPloreViewState();
}

class _ExPloreViewState extends ConsumerState<ExploreViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
