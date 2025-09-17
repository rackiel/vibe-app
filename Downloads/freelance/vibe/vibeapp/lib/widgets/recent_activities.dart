import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = _getSampleActivities();
    
    return Column(
      children: activities.map((activity) => Card(
        child: ListTile(
          leading: Icon(
            activity['icon'],
            color: activity['color'],
          ),
          title: Text(
            activity['title'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            activity['subtitle'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            activity['time'],
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      )).toList(),
    );
  }

  List<Map<String, dynamic>> _getSampleActivities() {
    return [
      {
        'title': 'Completed Sign Language Basics',
        'subtitle': 'Learned 5 new gestures',
        'icon': Icons.gesture,
        'color': Colors.green,
        'time': '2 hours ago',
      },
      {
        'title': 'Gesture Training Session',
        'subtitle': 'Practiced hand signs for 15 minutes',
        'icon': Icons.school,
        'color': Colors.blue,
        'time': '1 day ago',
      },
      {
        'title': 'Audio-Visual Test',
        'subtitle': 'Tested speech recognition',
        'icon': Icons.volume_up,
        'color': Colors.orange,
        'time': '2 days ago',
      },
      {
        'title': 'Story Adventure',
        'subtitle': 'Completed Chapter 1',
        'icon': Icons.book,
        'color': Colors.purple,
        'time': '3 days ago',
      },
    ];
  }
}
