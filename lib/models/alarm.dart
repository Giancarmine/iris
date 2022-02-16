class Alarm {
  int? id;
  String? date;
  String? time;
  int? color;
  int? remind;
  int? type;
  String? repeat;

  Alarm({
    this.id,
    this.date,
    this.time,
    this.color,
    this.remind,
    this.type,
    this.repeat,
  });

  Alarm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    color = json['color'];
    remind = json['remind'];
    type = json['type'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['type'] = this.type;
    data['repeat'] = this.repeat;

    return data;
  }
}
