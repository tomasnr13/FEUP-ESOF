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

  // TODO: make sure the studentsUpCodes
  Future<List<TimeSlot>> compareSchedulesFreeTime(
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
    List<TimeSlot> result;

    for (var i = 0; i < 7; i++) {
      Lecture nearest = Lecture('', '', i, 0, '', '', '', 0, 0, 0, 0);
      nearest.startTimeSeconds = double.maxFinite as int;

      int lowerLimit = double.minPositive as int;
      int latestEnd = 0;

      int freeTimeSlotStart; // TODO: find a way of putting a predetermined start time for each day
      int freeTimeSlotEnd;

      while(latestEnd != ) {  // TODO: find a stopping criteria

        // finding the nearest
        for (var schedule in studentsSchedules) {
          for (var lecture in schedule) {
            if (lecture.day == i) {
              if (lecture.startTimeSeconds <= nearest.startTimeSeconds && lecture.startTimeSeconds >= lowerLimit) {
                nearest = lecture;
              }
            }
          }
        }

        latestEnd = 60 * 30 * nearest.blocks + nearest.startTimeSeconds;

        // finding the latest
        for (var schedule in studentsSchedules) {
          for (var lecture in schedule) {
            if (lecture.day == i) {
              final int nearestEnd = 60 * 30 * nearest.blocks +
                  nearest.startTimeSeconds;
              final int lectureEnd = 60 * 30 * lecture.blocks +
                  lecture.startTimeSeconds;
              if (lecture.startTimeSeconds < nearestEnd &&
                  lectureEnd > latestEnd) {
                latestEnd = lectureEnd;
              }
            }
          }
        }

        lowerLimit = latestEnd;

        // TODO: add free time slot at end of each iteration
      }
    }

    return result;
  }
}
