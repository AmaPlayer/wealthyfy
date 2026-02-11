import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthyfy/controller/dashboardcontroller.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/tabs/home_tab.dart';
import 'package:wealthyfy/tabs/meeting_tab.dart';
import 'package:wealthyfy/tabs/profile_tab.dart';
class MyBottomBar extends GetView<DashboardController> {
  const MyBottomBar({super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      HomeTab(),
       MeetingTab(),
       ProfileTab(),
    ];
    return Obx(
          () => Scaffold(
           // backgroundColor: ColorConstants.DarkMahroon,
        body: Center(
          child: widgetOptions.elementAt(controller.selectedIndex.value),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 0, right: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              backgroundColor: ColorConstants.DarkMahroon,
              showSelectedLabels: false,
             iconSize: 20,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: ColorConstants.GREYCOLOR,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _buildNavItem(
                      Icons.home, 'Home', controller.selectedIndex.value == 0),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem(
                      Icons.laptop_chromebook_rounded,
                      'Meeting',
                      controller.selectedIndex.value == 1),
                  label: '',
                ),

                BottomNavigationBarItem(
                  icon: _buildNavItem(
                      Icons.person, 'Account', controller.selectedIndex.value == 2),
                  label: '',
                ),

              ],
              currentIndex: controller.selectedIndex.value,
              selectedItemColor: Color(0xFFdbbf89),
              onTap: controller.onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: isSelected
          ? BoxDecoration(
        color: Color(0xFFdbbf89),
        borderRadius: BorderRadius.circular(25),
      )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.black
                : Colors.white,
          ),
          if (isSelected) ...[
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Colors.white,
                fontSize: 14,
              ),
            ),
          ]
        ],
      ),
    );
  }
}





