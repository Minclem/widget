import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OperationItem extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final double anchor;
  final Function onScroll;
  final Function onOffsetChange;
  final Duration duration;

  OperationItem({
    this.children,
    this.height = 50.0,
    this.anchor = 50,
    this.onScroll,
    this.onOffsetChange,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  _OperationItemState createState() => _OperationItemState();
}

class _OperationItemState extends State<OperationItem> {
  ScrollController controller = new ScrollController();
  double speed = 0;
  int moveStart = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      speed = controller.offset;

      if (widget.onScroll != null) {
        widget.onScroll(speed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children == null) {
      return Container();
    }

    return Container(
      height: widget.height,
      child: Listener(
        onPointerDown: (_) {
          moveStart = _.position.dx.toInt();
        },
        onPointerUp: (_) {
          int moveEnd = moveStart - _.position.dx.toInt();
          ScrollPosition _sp = controller.position;
          double offset;

          // 右滑
          if (moveEnd > 0) {
            if (moveEnd >= widget.anchor || speed > widget.anchor) {
              offset = _sp.maxScrollExtent;
            } else {
              offset = _sp.minScrollExtent;
            }
            // 左滑
          } else {
            if (moveEnd < -widget.anchor || speed < widget.anchor) {
              offset = _sp.minScrollExtent;
            } else {
              offset = _sp.maxScrollExtent;
            }
          }

          controller.animateTo(
            offset,
            duration: widget.duration,
            curve: Curves.easeInCirc,
          );
        },
        child: ListView(
          controller: controller,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: widget.children,
        ),
      ),
    );
  }
}
