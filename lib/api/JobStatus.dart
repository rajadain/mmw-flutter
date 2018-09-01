import 'Result.dart';

enum Status { started, complete, failed }

Status parseStatus(String status) {
  var test = "Status.$status";
  return Status.values.firstWhere(
    (s) => s.toString() == test,
    orElse: () => null,
  );
}

class JobStatus<T extends Result> {
  final String error;
  final String uuid;
  final Status status;
  final DateTime startedAt;
  final DateTime finishedAt;
  final T result;

  JobStatus({
    this.uuid,
    this.status,
    this.startedAt,
    this.finishedAt,
    this.error,
    this.result,
  });

  factory JobStatus.fromJson(Map<String, dynamic> json) {
    final Status status = parseStatus(json['status']);
    T result;

    switch (status) {
      case Status.complete:
        result = parseResult(json['result']) as T;
        break;
      default:
        result = null;
    }

    return JobStatus(
      uuid: json['job_uuid'],
      status: status,
      startedAt: DateTime.parse(json['started']),
      finishedAt: DateTime.parse(json['finished']),
      error: json['error'],
      result: result,
    );
  }
}
