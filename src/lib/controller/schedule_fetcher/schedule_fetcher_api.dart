import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';

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
                //ignore: lines_longer_than_80_chars
                '''mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}&pv_semana_ini=${dates.beginWeek}&pv_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session']));
    return lectures;
  }

  Future<List<Lecture>> getLecturesFromUP(
      Store<AppState> store, dynamic studentNumber) async {
    final dates = getDates();
    final List<Lecture> lectures = await parseSchedule(
        await NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                //ignore: lines_longer_than_80_chars
                '''mob_hor_geral.estudante?pv_codigo=${studentNumber}&pv_semana_ini=${dates.beginWeek}&pv_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session']));
    return lectures;
  }

  List<Lecture> compareSchedulesFreeTime(List<List<Lecture>> schedules){
    // pseudo code:
    // step 1: go through each day and check what is the nearest starting time slot -> free time: start time until that nearest time slot
    // step 2: from that nearest see what is the time of the block that ends later and use that as starting point, repeat algorithm -> go to step 1
    // in the end return list of free time slots
    for(var i = 0; i < 7; i++){
    }
  }
}
