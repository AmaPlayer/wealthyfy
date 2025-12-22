import 'package:flutter/material.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/helper/textview.dart';
import '../../helper/imagees.dart';
import '../../lists/filter_model.dart';


//1
class ApplyListStatus extends StatefulWidget {
  const ApplyListStatus({super.key});

  @override
  _ApplyListStatusState createState() => _ApplyListStatusState();
}

class _ApplyListStatusState extends State<ApplyListStatus> {
  final List<bool> _isSelected = List.generate(10, (index) => false);

  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Status',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_circle_down_outlined,size: 20,),
                          headingText(title: 'Download',fontSize: 10,
                              color: ColorConstants.GREY7COLOR,fontWeight: FontWeight.bold)
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: status.length,
                itemBuilder: (context, index) {
                  var data = status[index];
                  bool isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 20,
                      margin: EdgeInsets.all(10),
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
          Populars(),
        ],
      ),
    );
  }

  Widget Populars() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
             //   Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetail()));
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.only(
                    left: 10, right: 5, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: ColorConstants.GREY6COLOR,
                        ),
                        addPadding(10, 0),
                        headingText(title: '11:52'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        width: 1,
                        color: ColorConstants.DarkMahroon,
                        height: 70),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        proimage,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    addPadding(0, 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(title: 'Name'),
                        Flexible(
                            child: headingFullText(
                                title: 'Mon 10 till 11 - Church Hall')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                              title: '27-11-2024',
                            ),
                            addPadding(0, 50),
                            headingText(
                              title: '10 Days',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
//2
class ApplyListMonth extends StatefulWidget {
  const ApplyListMonth({super.key});

  @override
  _ApplyListMonthState createState() => _ApplyListMonthState();
}

class _ApplyListMonthState extends State<ApplyListMonth> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Select Month',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_circle_down_outlined,size: 20,),
                          headingText(title: 'Download',fontSize: 10,
                              color: ColorConstants.GREY7COLOR,fontWeight: FontWeight.bold)
                        ],
                      ),
                    )),
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
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 20,
                      margin: EdgeInsets.all(10),
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
          Populars(),
        ],
      ),
    );
  }

  Widget Populars() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
               // Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetail()));
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.only(
                    left: 10, right: 5, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: ColorConstants.GREY6COLOR,
                        ),
                        addPadding(10, 0),
                        headingText(title: '11:52'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        width: 1,
                        color: ColorConstants.DarkMahroon,
                        height: 70),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        proimage,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    addPadding(0, 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(title: 'Name'),
                        Flexible(
                            child: headingFullText(
                                title: 'Mon 10 till 11 - Church Hall')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                              title: '27-11-2024',
                            ),
                            addPadding(0, 50),
                            headingText(
                              title: '10 Days',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
//3
class ApplyListDate extends StatefulWidget {
  const ApplyListDate({super.key});

  @override
  _ApplyListDateState createState() => _ApplyListDateState();
}

class _ApplyListDateState extends State<ApplyListDate> {
  DateTime currentDate = DateTime.now();
  String? selectedDateForBD;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
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
    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
        selectedDateForBD =
        '${currentDate.year}/${currentDate.month}/${currentDate.day}';
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
                    title: 'Date', fontSize: 14, fontWeight: FontWeight.bold),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_circle_down_outlined,size: 20,),
                          headingText(title: 'Download',fontSize: 10,
                              color: ColorConstants.GREY7COLOR,fontWeight: FontWeight.bold)
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorConstants.GREYCOLOR)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.calendar_month),
                      Text(
                        ' ${currentDate.year}/${currentDate.month}/${currentDate.day}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Populars(),
        ],
      ),
    );
  }

  Widget Populars() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetail()));
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.only(
                    left: 10, right: 5, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: ColorConstants.GREY6COLOR,
                        ),
                        addPadding(10, 0),
                        headingText(title: '11:52'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        width: 1,
                        color: ColorConstants.DarkMahroon,
                        height: 70),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        proimage,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    addPadding(0, 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(title: 'Name'),
                        Flexible(
                            child: headingFullText(
                                title: 'Mon 10 till 11 - Church Hall')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                              title: '27-11-2024',
                            ),
                            addPadding(0, 50),
                            headingText(
                              title: '10 Days',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
//4
class ApplyListToday extends StatefulWidget {
  const ApplyListToday({super.key});

  @override
  _ApplyListTodayState createState() => _ApplyListTodayState();
}

class _ApplyListTodayState extends State<ApplyListToday> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Days',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_circle_down_outlined,size: 20,),
                          headingText(title: 'Download',fontSize: 10,
                              color: ColorConstants.GREY7COLOR,fontWeight: FontWeight.bold)
                        ],
                      ),
                    )),
              ],
            ),
          ),

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
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 20,
                      margin: EdgeInsets.all(10),
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
          Populars(),
        ],
      ),
    );
  }

  Widget Populars() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
             //   Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetail()));
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.only(
                    left: 10, right: 5, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: ColorConstants.GREY6COLOR,
                        ),
                        addPadding(10, 0),
                        headingText(title: '11:52'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        width: 1,
                        color: ColorConstants.DarkMahroon,
                        height: 70),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        proimage,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    addPadding(0, 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(title: 'Name'),
                        Flexible(
                            child: headingFullText(
                                title: 'Mon 10 till 11 - Church Hall')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                              title: '27-11-2024',
                            ),
                            addPadding(0, 50),
                            headingText(
                              title: '10 Days',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
//5
class ApplyListYears extends StatefulWidget {
  const ApplyListYears({super.key});

  @override
  _ApplyListYearsState createState() => _ApplyListYearsState();
}

class _ApplyListYearsState extends State<ApplyListYears> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
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
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_circle_down_outlined,size: 20,),
                          headingText(title: 'Download',fontSize: 10,
                              color: ColorConstants.GREY7COLOR,fontWeight: FontWeight.bold)
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
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
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                      height: 20,
                      margin: EdgeInsets.all(10),
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
          Populars()
        ],
      ),
    );
  }

  Widget Populars() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetail()));
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.only(
                    left: 10, right: 5, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: ColorConstants.GREY6COLOR,
                        ),
                        addPadding(10, 0),
                        headingText(title: '11:52'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        width: 1,
                        color: ColorConstants.DarkMahroon,
                        height: 70),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        proimage,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    addPadding(0, 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(title: 'Name'),
                        Flexible(
                            child: headingFullText(
                                title: 'Mon 10 till 11 - Church Hall')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                              title: '27-11-2024',
                            ),
                            addPadding(0, 50),
                            headingText(
                              title: '10 Days',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
