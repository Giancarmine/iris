import 'dart:async';
import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iris/controllers/measurement_controller.dart';
import 'package:iris/models/measurement.dart';
import 'package:iris/screens/add_measurement.dart';
import 'package:iris/services/notification_services.dart';
import 'package:iris/services/theme_services.dart';
import 'package:iris/utils/size_config.dart';
import 'package:iris/utils/theme.dart';
import 'package:iris/widgets/button.dart';
import 'package:iris/widgets/measurement_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _measurementController = Get.put(MeasurementController());
  var notifyHelper;
  bool animate = false;
  double left = 630;
  double top = 900;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _timer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        animate = true;
        left = 30;
        top = top / 3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDataBar(),
          const SizedBox(
            height: 12,
          ),
          _showMeasurements(),
        ],
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          Column(
            children: [
              MyButton(
                icon: Icons.alarm_add,
                onTap: () async {
                  // await Get.to(const AddReminderPage());
                  _measurementController.getMeasurements();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              MyButton(
                icon: FontAwesomeIcons.eyeDropper,
                onTap: () async {
                  await Get.to(() => const AddMeasurementPage());
                  _measurementController.getMeasurements();
                },
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme");

          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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

  _addDataBar() {
    var todayDate = DateTime.now();

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime(todayDate.year, todayDate.month, todayDate.day - 3),
        height: 100,
        width: 80,
        initialSelectedDate: todayDate,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        locale: Platform.localeName, //"it_IT",
      ),
    );
  }

  _showMeasurements() {
    return Expanded(
      child: Obx(() {
        if (_measurementController.measurementList.isEmpty) {
          return _noMeasurementMsg();
        } else {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _measurementController.measurementList.length,
              itemBuilder: (context, index) {
                Measurement measurement = _measurementController.measurementList[index];
                if (measurement.date ==
                    DateFormat.yMd().format(_selectedDate)) {
                  //notifyHelper.scheduledNotification();
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: 300.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, measurement);
                                },
                                child: MeasurementTile(measurement)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        }
      }),
    );
  }

  showBottomSheet(BuildContext context, Measurement measurement) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: SizeConfig.screenHeight! * 0.24,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey.shade300),
          ),
          const Spacer(),
          _buildBottomSheetButton(
              label: "Delete Measurement",
              onTap: () {
                _measurementController.deleteMeasurement(measurement);
                Get.back();
              },
              clr: Colors.red.shade300),
          const SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
      required VoidCallback onTap,
      Color? clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey.shade300
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose
              ? titleTextStyle
              : titleTextStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _noMeasurementMsg() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "images/task.svg",
                color: primaryClr.withOpacity(0.5),
                height: 90,
                semanticsLabel: 'Task',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "You do not have any measurement yet!\nAdd new measurements to keep trace of that.",
                  textAlign: TextAlign.center,
                  style: subTitleTextStyle,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
