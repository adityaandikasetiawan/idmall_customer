import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final bool isPast;
  final String title;
  final String subtitle;
  const EventCard({
    super.key,
    required this.isPast,
    required this.title,
    required this.subtitle,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isPast
            ? Colors.deepOrange.shade400
            : Colors.deepOrange.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.title,
              style:
                  TextStyle(color: widget.isPast ? Colors.white : Colors.black),
            ),
            subtitle: Text(
              widget.subtitle,
              style:
                  TextStyle(color: widget.isPast ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
