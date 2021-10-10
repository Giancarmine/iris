class Measurement {
  int? id;
  int? value;
  String? note;
  String? date;
  String? time;
  int? color;
  int? remind;
  int? type;

  Measurement({
    this.id,
    this.value,
    this.note,
    this.date,
    this.time,
    this.color,
    this.remind,
    this.type,
  });

  Measurement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    note = json['note'];
    date = json['date'];
    time = json['time'];
    color = json['color'];
    remind = json['remind'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = this.id;
    data['value'] = this.value;
    data['note'] = this.note;
    data['date'] = this.date;
    data['time'] = this.time;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['type'] = this.type;

    return data;
  }
}
