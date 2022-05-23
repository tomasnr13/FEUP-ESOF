import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/time_slot.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher_api.dart';

// TODO: change this function to new controller file and modulate code in smaller functions
// TODO: make sure the studentsUpCodes are number only codes (without up prefix)

/**
 * Compares students schedules and returns the free time slots common to each other
 */
Future<List<List<TimeSlot>>> compareSchedulesFreeTime(
    Store<AppState> store, List<String> studentsUpCodes) async {
  const int dayStart = 60 * 60 * 8;
  const int dayEnd = 60 * 60 * 20;

  // calculating common free time slots
  List<List<TimeSlot>> result;

  // pseudo code:
  // step 1: go through each day and check what is the nearest starting time
  // slot -> free time: start time until that nearest time slot
  // step 2: from that nearest see what is the time of the block that ends
  // later and use that as starting point, repeat algorithm -> go to step 1

  // get schedules from students given
  final List<List<Lecture>> studentsSchedules =
      await schedulesFromStudentsList(studentsUpCodes, store);

  // pre-calculate last end of time for each day, if no lecture -> 0
  final List<int> lastEnds = getLastLectureEnds(studentsSchedules);

  // actually comparing schedules day by day
  for (var i = 0; i < 7; i++) {
    Lecture nearest = Lecture('', '', i, 0, '', '', '', 0, 0, 0, 0);
    nearest.startTimeSeconds = double.maxFinite as int;
    int lastEnd = 0;

    int freeTimeSlotStart = dayStart;
    int freeTimeSlotEnd;

    List<TimeSlot> dayResult;

    if (lastEnds[i] == 0) {
      dayResult.add(TimeSlot(i, dayEnd, dayStart));
    } else {
      while (lastEnd != lastEnds[i]) {
        // finding the nearest
        nearest = findNearestLecture(i, studentsSchedules, freeTimeSlotStart);
        freeTimeSlotEnd = nearest.startTimeSeconds;

        freeTimeSlotStart = lastEnd;

        // adding free time slot to day result
        if (freeTimeSlotEnd > dayEnd) {
          dayResult.add(TimeSlot(i, freeTimeSlotStart, dayEnd));
          break;
        } else {
          dayResult.add(TimeSlot(i, freeTimeSlotStart, freeTimeSlotEnd));
        }
      }
    }

    result.add(dayResult);
  }

  return result;
}

/**
 * Returns list of the end times of the last lecture of each day
 */
List<int> getLastLectureEnds(List<List<Lecture>> studentsSchedules) {
  List<int> lastEnds;

  // go through all week days
  for (int i = 0; i < 7; i++) {
    lastEnds.add(0);

    // go through all students schedules
    for (var schedule in studentsSchedules) {
      for (var lecture in schedule) {
        final int lectureEnd =
            getSecsFromBlocks(lecture.startTimeSeconds, lecture.blocks);

        if (lecture.day == i && lastEnds[i] <= lectureEnd) {
          lastEnds[i] = lectureEnd;
        }
      }
    }
  }

  return lastEnds;
}

/**
 * Get the end time in seconds from blocks(hours) and startTime(seconds)
 */
int getSecsFromBlocks(int startTime, int blocks) {
  return 60 * 30 * blocks + startTime;
}

/**
 * Get the students schedules for a given group of given students codes
 */
Future<List<List<Lecture>>> schedulesFromStudentsList(
    List<String> studentsUpCodes, Store<AppState> store) async {
  ScheduleFetcherApi fetcherApi;

  List<List<Lecture>> studentsSchedules;

  for (var student in studentsUpCodes) {
    final List<Lecture> schedule =
        await fetcherApi.getLecturesFromUP(store, int.parse(student));
    studentsSchedules.add(schedule);
  }

  return studentsSchedules;
}

/**
 * Get the nearest lecture for a given day
 */
Lecture findNearestLecture(
    int day, List<List<Lecture>> studentsSchedules, int freeTimeSlotStart) {
  Lecture nearest = Lecture('', '', day, 0, '', '', '', 0, 0, 0, 0);
  nearest.startTimeSeconds = double.maxFinite as int;

  for (var schedule in studentsSchedules) {
    for (var lecture in schedule) {
      if (lecture.day == day) {
        if (lecture.startTimeSeconds <= nearest.startTimeSeconds &&
            lecture.startTimeSeconds >= freeTimeSlotStart) {
          nearest = lecture;
        }
      }
    }
  }

  return nearest;
}

/**
 * Get the last lecture end time with no collision
 */
int findLastLectureNoCollision(
    int day, Lecture nearest, List<List<Lecture>> studentsSchedules) {
  int lastEnd = getSecsFromBlocks(nearest.startTimeSeconds, nearest.blocks);

  // TODO: if the returned latest is between other student lecture call recursively
  for (var schedule in studentsSchedules) {
    for (var lecture in schedule) {
      if (lecture.day == day) {
        final int nearestEnd =
            getSecsFromBlocks(nearest.startTimeSeconds, nearest.blocks);
        final int lectureEnd =
            getSecsFromBlocks(lecture.startTimeSeconds, lecture.blocks);

        if (lecture.startTimeSeconds < nearestEnd && lectureEnd > lastEnd) {
          lastEnd = lectureEnd;
        }
      }
    }
  }

  return lastEnd;
}
