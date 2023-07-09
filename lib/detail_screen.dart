import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFECF6FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: size.width,
              color: Colors.black12,
              child: getList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget getList(BuildContext context) {
    final length = scList.length;
    List<SortList> sortList = [];
    int i = 0;
    for (int k = 0; i < length; k++) {
      final date = scList[k].date;
      final firstItem = scList[k];
      final morningSlot = <Schedule>[];
      final afterNoonSlot = <Schedule>[];
      final eveningSlot = <Schedule>[];

      for (i = k; i < length; i++) {
        k = i;
        if (scList[i].date.day == firstItem.date.day) {
          if (scList[i].startTime.hour < 12) {
            morningSlot.add(scList[i]);
          } else if (scList[i].startTime.hour < 16) {
            afterNoonSlot.add(scList[i]);
          } else {
            eveningSlot.add(scList[i]);
          }
        } else {
          break;
        }
      }
      sortList.add(
        SortList(
          date: date,
          morningSchedule: morningSlot,
          eveningSchedule: eveningSlot,
          afterNoonSchedule: afterNoonSlot,
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: sortList.length,
      itemBuilder: (context, index) {
        final date = DateFormat.MMMMd().format(sortList[index].date);
        return Container(
          width: 155,
          margin: const EdgeInsets.only(right: 10),
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date),
              const Divider(color: Colors.blue),
              const Text('Morning'),
              ..._getListSlot(sortList[index].morningSchedule, context),
              const SizedBox(height: 10),
              const Text('AfterNoon'),
              ..._getListSlot(sortList[index].afterNoonSchedule, context),
              const SizedBox(height: 10),
              const Text('Evening'),
              ..._getListSlot(sortList[index].eveningSchedule, context),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getListSlot(List<Schedule> sortItem, BuildContext ctx) {
    return List.generate(
      sortItem.length,
      (index) {
        final startTime = (sortItem[index].startTime).format(ctx);
        final endTime = (sortItem[index].endTime).format(ctx);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(startTime),
            const Text('-'),
            Text(endTime),
          ],
        );
      },
    );
  }
}

class SortList {
  final DateTime date;
  final List<Schedule> morningSchedule;
  final List<Schedule> afterNoonSchedule;
  final List<Schedule> eveningSchedule;

  SortList({
    required this.date,
    required this.morningSchedule,
    required this.eveningSchedule,
    required this.afterNoonSchedule,
  });
}

class Schedule {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const Schedule(
      {required this.date, required this.startTime, required this.endTime});
}

final scList = [
  Schedule(
    date: DateTime.now().add(const Duration(days: 0)),
    startTime: const TimeOfDay(hour: 11, minute: 20),
    endTime: TimeOfDay(
      hour: 12,
      minute: DateTime.now().minute + 15,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 0)),
    startTime: const TimeOfDay(hour: 12, minute: 20),
    endTime: TimeOfDay(
      hour: 12,
      minute: DateTime.now().minute + 30,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 0)),
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay(
      hour: DateTime.now().hour + 2,
      minute: DateTime.now().minute + 15,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 0)),
    startTime: const TimeOfDay(hour: 20, minute: 15),
    endTime: TimeOfDay(
      hour: DateTime.now().hour + 2,
      minute: DateTime.now().minute + 30,
    ),
  ),

  ///
  ///
  Schedule(
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: const TimeOfDay(hour: 11, minute: 20),
    endTime: TimeOfDay(
      hour: 12,
      minute: DateTime.now().minute + 15,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: const TimeOfDay(hour: 12, minute: 20),
    endTime: TimeOfDay(
      hour: 12,
      minute: DateTime.now().minute + 30,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay(
      hour: DateTime.now().hour + 2,
      minute: DateTime.now().minute + 15,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: const TimeOfDay(hour: 20, minute: 15),
    endTime: TimeOfDay(
      hour: DateTime.now().hour + 2,
      minute: DateTime.now().minute + 30,
    ),
  ),
  //
  //
  //
  Schedule(
    date: DateTime.now().add(const Duration(days: 2)),
    startTime: const TimeOfDay(hour: 11, minute: 20),
    endTime: TimeOfDay(
      hour: 12,
      minute: DateTime.now().minute,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 2)),
    startTime: const TimeOfDay(hour: 12, minute: 20),
    endTime: TimeOfDay(
      hour: 12,
      minute: DateTime.now().minute + 15,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 2)),
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay(
      hour: DateTime.now().hour + 2,
      minute: DateTime.now().minute + 30,
    ),
  ),
  Schedule(
    date: DateTime.now().add(const Duration(days: 2)),
    startTime: const TimeOfDay(hour: 20, minute: 15),
    endTime: TimeOfDay(
      hour: DateTime.now().hour + 2,
      minute: DateTime.now().minute + 45,
    ),
  ),
];
