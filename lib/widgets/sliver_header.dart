import 'package:flutter/material.dart';

class SliverHeader extends StatefulWidget {
  final Color backgroundColor;
  final Widget _title;
  final double maxSize;
  final double minSize;

  SliverHeader(this.backgroundColor, this._title, this.maxSize, this.minSize);
  @override
  _SliverHeaderState createState() => _SliverHeaderState();
}

class _SliverHeaderState extends State<SliverHeader> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: Delegate(widget.backgroundColor, widget._title, widget.maxSize,
          widget.minSize),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final Widget _title;
  final double maxSize;
  final double minSize;

  Delegate(this.backgroundColor, this._title, this.maxSize, this.minSize);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _title,
    );
  }

  @override
  double get maxExtent => maxSize;

  @override
  double get minExtent => minSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
