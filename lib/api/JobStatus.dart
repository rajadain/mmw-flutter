enum Status { started, completed, failed }

Status parseStatus(String status) {
  var test = "Status.$status";
  return Status.values.firstWhere(
    (s) => s.toString() == test,
    orElse: () => null,
  );
}

class JobStatus {
  final String error;
  final String uuid;
  final Status status;
  final DateTime startedAt;
  final DateTime finishedAt;
  final dynamic result;

  JobStatus({
    this.uuid,
    this.status,
    this.startedAt,
    this.finishedAt,
    this.error,
    this.result,
  });

  factory JobStatus.fromJson(Map<String, dynamic> json) {
    return JobStatus(
      uuid: json['job_uuid'],
      status: parseStatus(json['status']),
      startedAt: DateTime.parse(json['started']),
      finishedAt: DateTime.parse(json['finished']),
      error: json['error'],
      result: json['result'],
    );
  }
}
