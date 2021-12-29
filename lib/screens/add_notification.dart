import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iris/controllers/measurement_controller.dart';
import 'package:iris/models/measurement.dart';
import 'package:iris/utils/theme.dart';
import 'package:iris/widgets/button.dart';
import 'package:iris/widgets/input_field.dart';

class AddNotificationPage extends StatefulWidget {
  AddNotificationPage({Key? key, this.notifyHelper}) : super(key: key);

  final notifyHelper;

  @override
  State<AddNotificationPage> createState() => _AddNotificationPageState();
}

class _AddNotificationPageState extends State<AddNotificationPage> {
  final MeasurementController _measurementController =
      Get.put(MeasurementController());

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedReminder = 2;
  List<int> reminderList = [
    0,
    1,
    2,
    3,
    4,
    5,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Notification",
                style: headingStyle,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFormUser();
                  },
                ),
              ),
              Expanded(
                child: MyInputField(
                  title: "Start Date",
                  hint: _startTime,
                  widget: IconButton(
                    onPressed: () {
                      _getTimeFormUser(isStartTime: true);
                    },
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // MyInputField(
              //   title: "Repeat",
              //   hint: _selectedRepeat,
              //   widget: DropdownButton(
              //     icon: const Icon(
              //       Icons.keyboard_arrow_down,
              //       color: Colors.grey,
              //     ),
              //     iconSize: 32,
              //     style: subTitleStyle,
              //     underline: Container(
              //       height: 0,
              //     ),
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         _selectedRepeat = newValue!;
              //       });
              //     },
              //     elevation: 4,
              //     items:
              //         repeatList.map<DropdownMenuItem<String>>((String? value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value!,
              //           style: const TextStyle(color: Colors.grey),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyButton(
                      label: "Add Notification", onTap: () => _validateData())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_valueController.text.isNotEmpty &&
        _valueController.text.isNumericOnly) {
      _addNotificationToDB();
      if (_selectedReminder != 0) {
        // notifyHelper.scheduledNotification('It is the time!',
        //     'Let\'s add a new measurement', _selectedReminder);
      }
      Get.back();
    } else {
      Get.snackbar(
        "Required",
        "Please insert the measurement value!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addNotificationToDB() async {
    int value = await _measurementController.addMeasurement(
      measurement: Measurement(
        value: int.parse(_valueController.text),
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        time: _startTime,
        color: _evaluateColor(),
        remind: _selectedReminder,
        type: 0,
      ),
    );

    print("My value is $value");
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _getDateFormUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  _getTimeFormUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);

    if (pickedTime == null) {
      print("Time cancelled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    }
  }

  _evaluateColor() {
    int? result = 0;
    int value = int.parse(_valueController.text);
    if (value >= 60 && value <= 110) {
      result = 1;
    } else if (value > 110 && value <= 125) {
      result = 2;
    } else if (value >= 126 && value < 140) {
      result = 3;
    } else if (value >= 140 && value <= 200) {
      result = 4;
    }

    return result;
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}
