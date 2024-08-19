import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/constant_widget/drawer.dart';
import 'package:property_app/views/main_bottom_bar/service_provider_bottom_ar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constant_widget/delete_widgets.dart';
import '../../controllers/services_provider_controller/calender_screen_controlelr.dart';
import 'package:intl/intl.dart';
import '../../models/service_provider_model/provider_job.dart';
import '../../route_management/constant_routes.dart';

const int kFirstYear = 2020;
const int kLastYear = 2030;

class CalendarScreen extends GetView<CalendarScreenController> {
  final bool isBack;
  const CalendarScreen({Key? key, required this.isBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      key: controller.key,
      appBar: homeAppBar(context, text: "Calendar", isBack: true,
        menuOnTap:  () => controller.key.currentState!.openDrawer(),
        backTap: () {
          Get.offAll(const ServiceProviderBottomBar());
        },
          back: false
      ),
      drawer: providerDrawer(context, onDeleteAccount: (){
        deleteFunction(context, controller);
      }),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            controller.pagingController.itemList!.clear();
            controller.getMyJob(1);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(() => controller.isLoading.value ?
            const Center(child: CircularProgressIndicator())  :
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(kFirstYear),
                        lastDay: DateTime.utc(kLastYear),
                        focusedDay: controller.focusedDay.value,
                        calendarFormat: controller.calendarFormat.value,
                        selectedDayPredicate: (day) {
                          return isSameDay(controller.selectedDay.value, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          controller.selectedDay.value = selectedDay;
                          controller.focusedDay.value = focusedDay;
                          // Your existing code for onDaySelected
                        },
                        onFormatChanged: (format) {
                          if (controller.calendarFormat.value != format) {
                            controller.calendarFormat.value = format;
                          }
                        },
                        onPageChanged: (focusedDay) {
                          controller.focusedDay.value = focusedDay;
                        },
                        eventLoader: (day) {
                          return controller.highlightedDates.contains(day) ? [{}] : []; // Returning a non-empty list for highlighted days
                        },
                       calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            if (controller.highlightedDates.contains(DateTime(day.year, day.month, day.day))) {
                              // This means this day should be highlighted
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade200, // Use any color to highlight the day
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: const TextStyle(color: Colors.white), // Change text color as needed
                                   ),
                                 ),
                               );
                             } // Return null for all other days to use the default style.
                            return null;
                          },
                        ),
                      ),
                    ),

                    h50,
                    // controller.isLoading.value ? const Center(child: CircularProgressIndicator())
                   // : controller.allJobList.isEmpty ? customText(
                   //    text: "No Job here"
                   //  ) :  ListView.builder(
                   //    itemCount: controller.allJobList.length,
                   //    shrinkWrap: true,
                   //    itemBuilder: (context, index) {
                   //      final createdAtDate = DateTime.parse(controller.allJobList[index].createdAt.toString());
                   //      final dayOfWeek = DateFormat.E().format(createdAtDate); // "Thu" for Thursday
                   //      final dayOfMonth = DateFormat.d().format(createdAtDate); // "13" for the 13th day of the month
                   //      return Column(
                   //        children: [
                   //          Container(
                   //            decoration: BoxDecoration(
                   //              color: whiteColor,
                   //              borderRadius: BorderRadius.circular(15),
                   //              boxShadow: [
                   //                BoxShadow(
                   //                  color: Colors.black.withOpacity(0.2),
                   //                  blurRadius: 1.0,
                   //                ),
                   //              ],
                   //            ),
                   //            child: ListTile(
                   //              onTap: (){
                   //                Get.toNamed(kCalendarDetailScreen, arguments: controller.allJobList[index].id);
                   //              },
                   //              leading: Container(
                   //                decoration: BoxDecoration(
                   //                  color: whiteColor,
                   //                  borderRadius: BorderRadius.circular(15),
                   //                  boxShadow: [
                   //                    BoxShadow(
                   //                      color: Colors.black.withOpacity(0.2),
                   //                      blurRadius: 1.0,
                   //                    ),
                   //                  ],
                   //                ),
                   //                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                   //                child: Column(
                   //                  children: [
                   //                    customText(
                   //                      text: dayOfWeek,
                   //                      fontSize: 21
                   //                    ),
                   //                    customText(
                   //                      text: dayOfMonth,
                   //                      fontSize: 10
                   //                    ),
                   //                  ],
                   //                ),
                   //              ),
                   //              title: customText(
                   //                  text: controller.allJobList[index].provider.fullname,
                   //                  fontSize: 21,
                   //              ),
                   //              subtitle: customText(
                   //                text: controller.allJobList[index].request.time,
                   //                color: greyColor
                   //              ),
                   //            ),
                   //          ),
                   //          h15,
                   //        ],
                   //      );
                   //    }
                   //  ),
                    // h20,
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: whiteColor,
                    //     borderRadius: BorderRadius.circular(15),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.2),
                    //         blurRadius: 1.0,
                    //       ),
                    //     ],
                    //   ),
                    //   child: ListTile(
                    //     leading: Container(
                    //       decoration: BoxDecoration(
                    //         color: whiteColor,
                    //         borderRadius: BorderRadius.circular(15),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black.withOpacity(0.2),
                    //             blurRadius: 1.0,
                    //           ),
                    //         ],
                    //       ),
                    //       padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    //       child: Column(
                    //         children: [
                    //           customText(
                    //               text: "Thu",
                    //               fontSize: 21
                    //           ),
                    //           customText(
                    //               text: "8",
                    //               fontSize: 10
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     title: customText(
                    //       text: "Organizational meeting",
                    //       fontSize: 21,
                    //     ),
                    //     subtitle: customText(
                    //         text: "10.00am - 11.30pm",
                    //         color: greyColor
                    //     ),
                    //   ),
                    // )
                    PagedListView<int, ProviderJobData>(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      pagingController: controller.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<ProviderJobData>(
                          firstPageErrorIndicatorBuilder: (context) => MaterialButton(
                            child: const Text("No Data Found, Tap to try again."),
                            onPressed: () => controller.pagingController.refresh(),
                          ),
                          itemBuilder: (context, item, index) {
                        
                            final createdAtDate = DateTime.parse(item.createdAt.toString());
                            final dayOfWeek = DateFormat.E().format(createdAtDate); // "Thu" for Thursday
                            final dayOfMonth = DateFormat.d().format(createdAtDate); // "13" for the 13th day of the month
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: (){
                                      Get.toNamed(kCalendarDetailScreen, arguments: item.id);
                                    },
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                      child: Column(
                                        children: [
                                          customText(
                                              text: dayOfWeek,
                                              fontSize: 21
                                          ),
                                          customText(
                                              text: dayOfMonth,
                                              fontSize: 10
                                          ),
                                        ],
                                      ),
                                    ),
                                    title: customText(
                                      text: item.provider.fullname,
                                      fontSize: 21,
                                    ),
                                    subtitle: customText(
                                        text: item.request.time,
                                        color: greyColor
                                    ),
                                  ),
                                ),
                                h15,
                              ],
                            );
                          }
                      ),
                    ),
                  ],
                ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}

// circleAvatar(
// text: "Job Calendar",
// image: AppIcons.calendar,
// ),

class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCalendars(),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime startingDate) {
    final daysInWeek = 7;
    final firstDayOfWeek = startingDate.subtract(Duration(days: startingDate.weekday - 1));

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(daysInWeek, (index) {
          final day = firstDayOfWeek.add(Duration(days: index)).day;
          return Container(
            alignment: Alignment.center,
            width: 40,
            child: Text('${_getWeekdayName(day)}'),
          );
        }),
      ),
    );
  }
  Widget _buildCalendars() {
    return Container(
      height: 400,
      child: PageView.builder(
        itemCount: 12,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final currentMonth = DateTime.now().add(Duration(days: index * 30));
          return Column(
            children: [
              _buildCurrentDateInfo(),
              _buildHeader(currentMonth),
              _buildSingleCalendar(currentMonth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSingleCalendar(DateTime startingDate) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      shrinkWrap: true,
      itemCount: DateTime(startingDate.year, startingDate.month + 1, 0).day,
      itemBuilder: (context, index) {
        final day = index + 1;
        final currentDate = DateTime(startingDate.year, startingDate.month, day);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = DateTime(
                startingDate.year,
                startingDate.month,
                day,
              );
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _isSelectedDay(day, startingDate) ? Colors.blue : (currentDate.isAtSameMomentAs(DateTime.now()) ? Colors.yellowAccent : null),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$day'),
          ),
        );
      },
    );
  }

  bool _isSelectedDay(int day, DateTime startingDate) {
    return selectedDate.day == day && selectedDate.year == startingDate.year && selectedDate.month == startingDate.month;
  }

  Widget _buildCurrentDateInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getWeekdayName(int day) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[(day - 1) % 7];
  }
}
