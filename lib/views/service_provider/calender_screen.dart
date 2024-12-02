import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:property_app/app_constants/app_sizes.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';
import 'package:property_app/constant_widget/drawer.dart';
import 'package:property_app/views/main_bottom_bar/service_provider_bottom_ar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constant_widget/delete_widgets.dart';
import '../../controllers/services_provider_controller/calender_screen_controlelr.dart';
import '../../models/service_provider_model/provider_job.dart';
import '../../route_management/constant_routes.dart';

const int kFirstYear = 2020;
const int kLastYear = 2030;

class CalendarScreen extends GetView<CalendarScreenController> {
  final bool isBack;
   bool? back;
   CalendarScreen({Key? key, required this.isBack, this.back = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      key: controller.key,
      appBar: homeAppBar(
        context,
        text: "Calendar",
        isBack: isBack,
        menuOnTap: () => controller.key.currentState!.openDrawer(),
        backTap: () {
          Get.offAll(const ServiceProviderBottomBar());
        },
        back: back,
      ),
      drawer: providerDrawer(
        context,
        onDeleteAccount: () {
          deleteFunction(context, controller);
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.pagingController.itemList!.clear();
            controller.getMyJob(1);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
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
                                return isSameDay(
                                    controller.selectedDay.value, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                controller.selectedDay.value = selectedDay;
                                controller.focusedDay.value = focusedDay;
                                // Additional code for onDaySelected if needed
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
                                return controller.highlightedDates.contains(day)
                                    ? [{}]
                                    : [];
                              },
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  if (controller.highlightedDates.contains(
                                      DateTime(day.year, day.month, day.day))) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          day.day.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          h50,
                          PagedListView<int, ProviderJobData>(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            pagingController: controller.pagingController,
                            builderDelegate:
                                PagedChildBuilderDelegate<ProviderJobData>(
                              firstPageErrorIndicatorBuilder: (context) =>
                                  MaterialButton(
                                child: const Text(
                                    "No Data Found, Tap to try again."),
                                onPressed: () =>
                                    controller.pagingController.refresh(),
                              ),
                              itemBuilder: (context, item, index) {
                                if (item.createdAt != null) {
                                  final createdAtDate = item.createdAt!;
                                  final dayOfWeek = DateFormat.E().format(
                                      createdAtDate); // e.g., "Thu" for Thursday
                                  final dayOfMonth = DateFormat.d().format(
                                      createdAtDate); // e.g., "13" for the 13th

                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Get.toNamed(
                                              kCalendarDetailScreen,
                                              arguments: item.id,
                                            );
                                          },
                                          leading: Container(
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            child: Column(
                                              children: [
                                                customText(
                                                    text: dayOfWeek,
                                                    fontSize: 21),
                                                customText(
                                                    text: dayOfMonth,
                                                    fontSize: 10),
                                              ],
                                            ),
                                          ),
                                          title: customText(
                                            text: item.provider.fullname,
                                            fontSize: 21,
                                          ),
                                          subtitle: customText(
                                            text: item.request.time,
                                            color: greyColor,
                                          ),
                                        ),
                                      ),
                                      h15,
                                    ],
                                  );
                                } else {
                                  // Handle the case when createdAt is null
                                  return SizedBox.shrink();
                                }
                              },
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
    final firstDayOfWeek =
        startingDate.subtract(Duration(days: startingDate.weekday - 1));

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
        final currentDate =
            DateTime(startingDate.year, startingDate.month, day);

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
              color: _isSelectedDay(day, startingDate)
                  ? Colors.blue
                  : (currentDate.isAtSameMomentAs(DateTime.now())
                      ? Colors.yellowAccent
                      : null),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$day'),
          ),
        );
      },
    );
  }

  bool _isSelectedDay(int day, DateTime startingDate) {
    return selectedDate.day == day &&
        selectedDate.year == startingDate.year &&
        selectedDate.month == startingDate.month;
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
