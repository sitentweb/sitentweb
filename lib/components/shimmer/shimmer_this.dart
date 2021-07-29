import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerThis extends StatelessWidget {
  final child;
  const ShimmerThis({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: child
    );
  }
}