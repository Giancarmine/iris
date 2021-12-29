class Notification {
  int? id;
  String? date;
  String? time;
  int? color;
  int? remind;
  int? type;

  Notification({
    this.id,
    this.date,
    this.time,
    this.color,
    this.remind,
    this.type,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    color = json['color'];
    remind = json['remind'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['type'] = this.type;

    return data;
  }
}
