import 'package:flutter/material.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/helper/textview.dart';
import '../../lists/filter_model.dart';

class MeetingStatus extends StatefulWidget {
  final ValueChanged<String>statusChanged;
  final void Function()? onTapDownload;
  const MeetingStatus({super.key,required this.statusChanged,this.onTapDownload});

  @override
  _MeetingStatusState createState() => _MeetingStatusState();
}

class _MeetingStatusState extends State<MeetingStatus> {
  int selectedIndex = 0;
  selected(int position){
    setState(() {
      selectedIndex = position;
      widget.statusChanged(['Pending','Approved','Rejected'][position]);
    });
  }
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Status',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: [ 'Pending','Approved','Rejected'].length,
                itemBuilder: (context, index) {
                  var data = [ 'Pending','Approved','Rejected'][index];
                  bool isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: ()=>selected(index),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                      height: 20,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child:
                      Center(
                          child: Text(
                            data.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

  class MeetingMonth extends StatefulWidget {
    final ValueChanged<String>monthChanged;
    final ValueChanged<String>selectedMonthChanged;
    final void Function()? onTapDownload;
    const MeetingMonth({super.key, required this.monthChanged, this.onTapDownload,required this.selectedMonthChanged});

    @override
    _MeetingMonthState createState() => _MeetingMonthState();
  }

class _MeetingMonthState extends State<MeetingMonth> {

  int? selectedIndex;
  var selectedMonth = "";

  @override
  void initState() {
    super.initState();

    int currentMonth = DateTime.now().month;

    selectedIndex = rangeprice.indexOf(currentMonth.toString());
    if (selectedIndex == -1) {
      selectedIndex = 0;
    }
    selectedMonth = '${selectedIndex! + 1}';
    widget.monthChanged(rangeprice[selectedIndex!]);
    widget.selectedMonthChanged(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Months',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: rangeprice.length,
                itemBuilder: (context, index) {
                  var data = rangeprice[index];
                  bool isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedMonth = '${selectedIndex! + 1}';
                        widget.monthChanged(data);
                        widget.selectedMonthChanged(selectedMonth);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 20,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                            data.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}




class MeetingDate extends StatefulWidget {
  final ValueChanged<String> fromDateChanged;
  final ValueChanged<String> toDateChanged;
  final void Function()? onTapDownload;

  const MeetingDate({
    super.key,
    required this.fromDateChanged,
    required this.toDateChanged,
    this.onTapDownload,
  });

  @override
  _MeetingDateState createState() => _MeetingDateState();
}

class _MeetingDateState extends State<MeetingDate> {
  String fromDate = '';
  String toDate = '';
  bool isLoading = true;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
}

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (type == 'to') {
          toDateController.text = '${picked.year}-${picked.month}-${picked.day}';
          widget.toDateChanged(toDateController.text);
        } else {
          fromDateController.text = '${picked.year}-${picked.month}-${picked.day}';
          widget.fromDateChanged(fromDateController.text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                  title: 'Date',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // From Date Field
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.none,
                    controller: fromDateController,
                    onTap: () {
                      _selectDate(context, 'from');
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorConstants.GREY7COLOR),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.DarkMahroon),
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'From date',
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Select a date';
                      }
                      return null;
                    },
                  ),
                ),

                // Separator Icon
                const Icon(
                  Icons.compare_arrows_rounded,
                  color: Colors.grey,
                  size: 32,
                ),

                // To Date Field
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.none,
                    controller: toDateController,
                    onTap: () {
                      _selectDate(context, 'to');
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorConstants.GREY7COLOR),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.DarkMahroon),
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'To date',
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Select a date';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



//------------------------------------
class MeetingToday extends StatefulWidget {
  final ValueChanged<String>todayChanged;
  final void Function()? onTapDownload;
  const MeetingToday({super.key, required this.todayChanged, this.onTapDownload});

  @override
  _MeetingTodayState createState() => _MeetingTodayState();
}

class _MeetingTodayState extends State<MeetingToday> {
  int? selectedIndex;
  int  monthSelect = 0;

@override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: Days.length,
                itemBuilder: (context, index) {
                  var data = Days[index];
                  bool isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        widget.todayChanged(data);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 20,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                            data.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}


class MeetingYears extends StatefulWidget {
  final ValueChanged<String>yearsChanged;
  final void Function()? onTapDownload;

  const MeetingYears({super.key, required this.yearsChanged, this.onTapDownload, });

  @override
  _MeetingYearsState createState() => _MeetingYearsState();
}

class _MeetingYearsState extends State<MeetingYears> {
  int? selectedIndex;
  var selectedYears = "";

  @override
  void initState() {
    super.initState();

    int currentYear = DateTime.now().year;


    selectedIndex = years.indexOf(currentYear.toString());
    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    selectedYears = years[selectedIndex!];
    widget.yearsChanged(selectedYears);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Years',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: years.length,
                itemBuilder: (context, index) {
                  var data = years[index];
                  bool isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedYears = data.toString();
                        widget.yearsChanged(selectedYears);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      height: 20,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          data.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

