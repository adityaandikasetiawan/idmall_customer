import 'package:flutter/material.dart';
import 'package:idmall/widget/event_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StatusTimeline extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String title;
  final String subtile;
  const StatusTimeline({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.title,
    required this.subtile,
  });

  @override
  State<StatusTimeline> createState() => _StatusTimelineState();
}

class _StatusTimelineState extends State<StatusTimeline> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        beforeLineStyle: LineStyle(
          color: widget.isPast
              ? Colors.deepOrange.shade400
              : Colors.deepOrange.shade100,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: widget.isPast
              ? Colors.deepOrange.shade400
              : Colors.deepOrange.shade100,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: Colors.white,
          ),
        ),
        endChild: EventCard(
          isPast: widget.isPast,
          title: widget.title,
          subtitle: widget.subtile,
        ),
      ),
    );
  }
}
