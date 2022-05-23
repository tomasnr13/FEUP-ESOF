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

  TimeSlot(int day, int starTimeSeconds, int endTimeSeconds) {
    //this.endTimeSeconds = 60 * 30 * blocks + startTimeSeconds;
    this.day = (day - 2) % 7;
    this.dayName = dayNames[day];
    this.endTimeSeconds = endTimeSeconds;
    this.startTimeSeconds = starTimeSeconds;
  }
}