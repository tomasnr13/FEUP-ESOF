class TimeSlot {
  static var dayNames = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  String dayName;
  int day;
  int startTimeSeconds;
  int endTimeSeconds;
  String startTime;
  String endTime;

  TimeSlot(int day, int starTimeSeconds, int endTimeSeconds) {
    //this.endTimeSeconds = 60 * 30 * blocks + startTimeSeconds;
    this.day = (day - 2) % 7;
    this.dayName = dayNames[day];
    this.endTimeSeconds = endTimeSeconds;
    this.startTimeSeconds = starTimeSeconds;
    this.startTime = (startTimeSeconds ~/ 3600).toString().padLeft(2, '0') +
        'h'  + ((startTimeSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    this.endTime = (endTimeSeconds ~/ 3600).toString().padLeft(2, '0') +
        'h'  + ((endTimeSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
  }

  int getDurationSecs(){
    return endTimeSeconds - startTimeSeconds;
  }
}