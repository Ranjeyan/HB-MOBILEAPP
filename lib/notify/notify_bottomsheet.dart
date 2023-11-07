import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationOptionsBottomSheet extends StatefulWidget {
  final void Function(DateTime) onScheduleNotification;

  NotificationOptionsBottomSheet({Key? key, required this.onScheduleNotification})
      : super(key: key);

  @override
  _NotificationOptionsBottomSheetState createState() =>
      _NotificationOptionsBottomSheetState();
}

class _NotificationOptionsBottomSheetState
    extends State<NotificationOptionsBottomSheet> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOption("Tomorrow Morning", Icons.access_alarm, () {
              _scheduleNotificationForTomorrowMorning();
              Navigator.pop(context);
            }),
            _buildOption("Tomorrow Evening", Icons.access_alarm, () {
              _scheduleNotificationForTomorrowEvening();
              Navigator.pop(context);
            }),
            _buildOption("Choose Date and Time", Icons.access_alarm, () {
              _selectDateAndTime(context);
            }),
            _buildOption("In 1 Hour", Icons.access_alarm, () {
              _scheduleNotificationIn1Hour();
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text, IconData icon, Function() onTap) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 8.0),
          Text(text),
        ],
      ),
      onTap: onTap,
    );
  }

  void _scheduleNotificationForTomorrowMorning() {
    tz.TZDateTime scheduledTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 8);
    widget.onScheduleNotification.call(scheduledTime);
  }

  void _scheduleNotificationForTomorrowEvening() {
    tz.TZDateTime scheduledTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 20);
    widget.onScheduleNotification.call(scheduledTime);
  }

  void _scheduleNotificationIn1Hour() {
    tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(
      const Duration(hours: 1),
    );
    widget.onScheduleNotification.call(scheduledTime);
  }


  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
          final selectedDateTime = tz.TZDateTime.local(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          widget.onScheduleNotification.call(selectedDateTime);
        });
      }
    }
  }
}
