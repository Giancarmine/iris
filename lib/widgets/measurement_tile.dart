import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris/models/measurement.dart';
import 'package:iris/utils/size_config.dart';
import 'package:iris/utils/theme.dart';

class MeasurementTile extends StatelessWidget {
  final Measurement measurement;

  MeasurementTile(this.measurement);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(measurement.color!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    measurement.value!.toString(),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            FlutterIcons.clock_faw5,
                            color: Colors.grey.shade200,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${measurement.time}",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 20, color: Colors.grey.shade100),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            measurement.note!,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey.shade200.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                measurement.type == 0 ? "MEASUREMENT" : "REMINDER",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return greenClr;
      case 2:
        return yellowClr;
      case 3:
        return pinkClr;
      case 4:
        return purpleClr;
      default:
        return bluishClr;
    }
  }
}
