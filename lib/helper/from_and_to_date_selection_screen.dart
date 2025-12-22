import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../APIs/Api.dart';
import 'colors.dart';

DateTime currentDateTime = DateTime.now();
String currentFormatDate = DateFormat('dd MMM yyyy').format(currentDateTime);

class FromAndToDateSelectionScreen extends StatefulWidget {
  final ValueChanged<DateType> dateManager;
  final EdgeInsetsGeometry? margin;
  final bool? isDisable;
  final String? initialFromDate;
  final String? initialToDate;
  final bool? isShowColumn;
  final double? height;

  const FromAndToDateSelectionScreen({
    super.key,
    required this.dateManager,
    this.margin,
    this.isDisable,
    this.height,
    this.isShowColumn,
    this.initialFromDate,
    this.initialToDate,
  });

  @override
  State<FromAndToDateSelectionScreen> createState() =>
      _FromAndToDateSelectionScreenState();
}

class _FromAndToDateSelectionScreenState
    extends State<FromAndToDateSelectionScreen> {

  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();

  String fromSelectedDate = '';
  String toSelectedDate = '';

  @override
  void initState() {
    userLeaveApplyApi;
    super.initState();
    setState(() {
     // userLeaveApplyApi;
      // if (widget.isShowColumn ?? false) {
      //   toSelectedDate = widget.initialToDate.toString();
      //   fromSelectedDate = widget.initialFromDate.toString();
      // } else {
      //   toSelectedDate = DateFormat('dd MMM yyyy').format(currentDateTime);
      //   fromSelectedDate = DateFormat('dd MMM yyyy').format(currentDateTime);
      // }
      fromdatecontroller.text = fromSelectedDate;
      todatecontroller.text = toSelectedDate;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: widget.margin,
    child: rowItem(),
  );

  rowItem() => Row(
    children: [
      Expanded(
        child: TextFormField(
          readOnly: true,
          keyboardType: TextInputType.none,
          controller: fromdatecontroller,
          onTap: () {
            setState(() {
              fromSelection(context);
            });
          },
          decoration: InputDecoration(
            labelStyle: TextStyle(color: ColorConstants.GREY7COLOR),
            border: OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.DarkMahroon)),
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: 'From date',
            prefixIcon: Icon(Icons.calendar_month),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'select date';
            }
            return null;
          },
        ),
      ),
      const Icon(
        Icons.compare_arrows_rounded,
        color: Colors.grey,
        size: 32,
      ),
      Expanded(
        child: TextFormField(
          readOnly: true,
          keyboardType: TextInputType.none,
          controller: todatecontroller,
          onTap: () {
            setState(() {
              toSelection(context);
            });
          },
          decoration: InputDecoration(
            labelStyle: TextStyle(color: ColorConstants.GREY7COLOR),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.DarkMahroon)),
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: 'To date',
            prefixIcon: Icon(
              Icons.calendar_month,
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'select date';
            }
            return null;
          },
        ),
      ),
    ],
  );

  //----- Selection Logic
  Future fromSelection(BuildContext context) async {
    await selectDate(
      context: context,
      initialDate: toSelectedDate != '' ? converter(toSelectedDate) : converter(fromSelectedDate),
      lastDate: null,
      startDate: null,
    ).then((d) {
      setState(() {
        userLeaveApplyApi;
        fromSelectedDate = d.toString();
        widget.dateManager(DateType(type: DateTypeEnum.from, date: fromSelectedDate));
        fromdatecontroller.text = DateFormat('dd MMM yyyy').format(converter(fromSelectedDate)!);
      });
    });
  }
  Future toSelection(BuildContext context) async {
    await selectDate(
      context: context,
      initialDate: fromSelectedDate != '' ? converter(fromSelectedDate) : currentDateTime,
      startDate: converter(fromSelectedDate),
      lastDate: DateTime(2030),
    ).then((d) {
      setState(() {
        userLeaveApplyApi;
        toSelectedDate = d.toString();
        widget.dateManager(DateType(type: DateTypeEnum.to, date: toSelectedDate));
        todatecontroller.text = DateFormat('dd MMM yyyy').format(converter(toSelectedDate)!);
      });
    });
  }
  DateTime? converter(String dateInput) {
    if (dateInput.isEmpty) {
      return null;
    }
    DateFormat inputFormat = DateFormat("dd MMM yyyy");
    DateTime parsedDate = inputFormat.parse(dateInput);
    DateTime now = DateTime.now();
    DateTime finalDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
    return finalDateTime;
  }
}
class DateType {
  DateTypeEnum type;
  String date;
  DateType({required this.type, required this.date});
}
Future<String> selectDate({
  required BuildContext context,
  DateTime? lastDate,
  DateTime? startDate,
  DateTime? initialDate,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: startDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime(2030),
  );
  return DateFormat('dd MMM yyyy').format(picked!);
}
enum DateTypeEnum { from, to }