import 'dart:developer';

import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/time_slot.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher_api.dart';

/**
 * Compares students schedules and returns the free time slots common to each other
 */
Future<List<List<TimeSlot>>> compareSchedulesFreeTime(
    Store<AppState> store, List<String> noTruncatedCodes) async {

  final List<String> studentsUpCodes = truncateUpCodes(noTruncatedCodes);

  const int dayStart = 60 * 60 * 8;
  const int dayEnd = 60 * 60 * 20;

  // calculating common free time slots
  List<List<TimeSlot>> result = [];

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
    nearest.startTimeSeconds = 99999999999;
    int lastEnd = 0;

    int freeTimeSlotStart = dayStart;
    int freeTimeSlotEnd;

    final List<TimeSlot> dayResult = [];

    if (lastEnds[i] == 0) {
      dayResult.add(TimeSlot(i, dayEnd, dayStart));
    } else {
      while (lastEnd != lastEnds[i]) {
        // finding the nearest
        nearest = findNearestLecture(i, studentsSchedules, freeTimeSlotStart);
        freeTimeSlotEnd = nearest.startTimeSeconds;

        lastEnd = findLastLectureNoCollision(i, nearest, studentsSchedules);
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
  List<int> lastEnds = [];

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
  final List<List<Lecture>> studentsSchedules = [];

  for (var student in studentsUpCodes) {
    final List<Lecture> schedule =
        await ScheduleFetcherApi().getLecturesFromUP(store, int.parse(student));
    studentsSchedules.add(schedule);
  }

  return studentsSchedules;
}

/**
 * Get the students schedules by day for a given group of given students codes
 */
Future<List<Lecture>> allSchedulesFromStudentsList(
    List<String> noTruncatedCodes, Store<AppState> store) async {
  final List<String> studentsUpCodes = truncateUpCodes(noTruncatedCodes);
  final List<Lecture> studentsSchedules = [];

  for (var student in studentsUpCodes) {
    final List<Lecture> schedule =
    await ScheduleFetcherApi().getLecturesFromUP(store, int.parse(student));
    studentsSchedules.addAll(schedule);
  }

  return studentsSchedules;
}

/**
 * Get the nearest lecture for a given day
 */
Lecture findNearestLecture(
    int day, List<List<Lecture>> studentsSchedules, int freeTimeSlotStart) {
  Lecture nearest = Lecture('', '', day, 0, '', '', '', 0, 0, 0, 0);
  nearest.startTimeSeconds = 99999999999;

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



  // get last lecture end
  while (true) {
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

    // check if that last lecture end is between other lecture period
    // if it is -> repeat step one -> else -> return
    bool between = false;

    for (var schedule in studentsSchedules) {
      for (var lecture in schedule) {
        final int lectureEnd =
        getSecsFromBlocks(lecture.startTimeSeconds, lecture.blocks);

        if (lecture.day == day) {
          if(lastEnd >= lecture.startTimeSeconds && lastEnd > lectureEnd){
            lastEnd = lectureEnd;
            nearest = lecture;
            between = true;
          }
        }
      }
    }

    if(!between){
      break;
    }
  }

  return lastEnd;
}

/**
 * Removes all 'up' prefixes from up students codes
 */
List<String> truncateUpCodes(List<String> studentsUpCodes) {
  final List<String> truncatedStudentsUpCodes = [];
  for (var code in studentsUpCodes) {
    if (code.length == 11) {
      truncatedStudentsUpCodes.add(code.substring(2));
    } else {
      truncatedStudentsUpCodes.add(code);
    }
  }

  return truncatedStudentsUpCodes;
}
