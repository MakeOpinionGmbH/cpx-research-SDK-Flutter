class CPXLogger {
  static bool isEnabled = false;
  static List<String> _logs = [];

  static List<String> get getLogs => _logs;

  /// The function [enableLogger] enables the CPX Logging functionality
  static enableLogger(bool enabled) {
    isEnabled = enabled;
    CPXLogger.log("CPXLogger enabled");
  }

  /// [log] logs the provided message with a timestamp in a list of Logs and prints them in the console
  static log(String message) {
    if(isEnabled) {
      String log = timestamp() + ": " + message;
      _logs.add(log);
      print(log);
    }
  }

  /// [timestamp] provides the current date and time for the log
  static String timestamp() {
    DateTime now = DateTime.now();
    return "[${now.year.toString()}/${now.month.toString().padLeft(2,'0')}/${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}]";
  }

}