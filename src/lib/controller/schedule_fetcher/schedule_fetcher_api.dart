import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/time_slot.dart';

/// Class for fetching the user's lectures from the faculty's API.
class ScheduleFetcherApi extends ScheduleFetcher {
  /// Fetches the user's lectures from the faculty's API.
  @override
  Future<List<Lecture>> getLectures(Store<AppState> store) async {
    final dates = getDates();
    final List<Lecture> lectures = await parseSchedule(
        await NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                '''mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}&pv_semana_ini=${dates.beginWeek}&pv_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session']));
    return lectures;
  }

  Future<List<Lecture>> getLecturesFromUP(
      Store<AppState> store, dynamic studentCode) async {
    final dates = getDates();
    final List<Lecture> lectures = await parseSchedule(
        await NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                //ignore: lines_longer_than_80_chars
                '''mob_hor_geral.estudante?pv_codigo=${studentCode}&pv_semana_ini=${dates.beginWeek}&pv_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session']));
    return lectures;
  }

  // TODO: make sure the studentsUpCodes are number only codes (without up prefix)
  Future<List<List<TimeSlot>>> compareSchedulesFreeTime(
      Store<AppState> store, List<String> studentsUpCodes) async {
    // pseudo code:
    // step 1: go through each day and check what is the nearest starting time
    // slot -> free time: start time until that nearest time slot
    // step 2: from that nearest see what is the time of the block that ends
    // later and use that as starting point, repeat algorithm -> go to step 1

    // get schedules from students given
    List<List<Lecture>> studentsSchedules;

    for (var student in studentsUpCodes) {
      final List<Lecture> schedule =
          await getLecturesFromUP(store, int.parse(student));
      studentsSchedules.add(schedule);
    }

    // calculating common free time slots
    List<List<TimeSlot>> result;
    int dayStart; // TODO: find a way of putting a predetermined start and end time for each day
    int dayEnd;

    // pre-calculate last end of time for each day, if no lecture -> 0
    List<int> lastEnds;

    for (int i = 0; i < 7; i++) {
      lastEnds.add(0);
      for (var schedule in studentsSchedules) {
        for (var lecture in schedule) {
          final int lectureEnd = 60 * 30 * lecture.blocks + lecture.startTimeSeconds;
          if (lecture.day == i && lastEnds[i] <= lectureEnd) {
            lastEnds[i] = lectureEnd;
          }
        }
      }
    }


    // actually comparing schedules day by day
    for (var i = 0; i < 7; i++) {
      Lecture nearest = Lecture('', '', i, 0, '', '', '', 0, 0, 0, 0);
      nearest.startTimeSeconds = double.maxFinite as int;
      int latestEnd = 0;

      int freeTimeSlotStart = dayStart;
      int freeTimeSlotEnd;

      List<TimeSlot> dayResult;

      if (lastEnds[i] == 0) {
        dayResult.add(TimeSlot(i, dayEnd, dayStart));
      } else {
        while (latestEnd != lastEnds[i]) {
          // finding the nearest
          for (var schedule in studentsSchedules) {
            for (var lecture in schedule) {
              if (lecture.day == i) {
                if (lecture.startTimeSeconds <= nearest.startTimeSeconds &&
                    lecture.startTimeSeconds >= freeTimeSlotStart) {
                  nearest = lecture;
                }
              }
            }
          }

          freeTimeSlotEnd = nearest.startTimeSeconds;

          latestEnd = 60 * 30 * nearest.blocks + nearest.startTimeSeconds;

          // finding the latest
          for (var schedule in studentsSchedules) {
            for (var lecture in schedule) {
              if (lecture.day == i) {
                final int nearestEnd =
                    60 * 30 * nearest.blocks + nearest.startTimeSeconds;
                final int lectureEnd =
                    60 * 30 * lecture.blocks + lecture.startTimeSeconds;
                if (lecture.startTimeSeconds < nearestEnd &&
                    lectureEnd > latestEnd) {
                  latestEnd = lectureEnd;
                }
              }
            }
          }
          freeTimeSlotStart = latestEnd;

          // adding free time slot to day result
          dayResult.add(TimeSlot(i, freeTimeSlotStart, freeTimeSlotEnd));
        }
      }

      result.add(dayResult);
    }

    return result;
  }
}
