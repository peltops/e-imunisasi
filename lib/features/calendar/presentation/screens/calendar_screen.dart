import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/utils/any_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../pages/home/utama/kalender/update_event.dart';
import '../../logic/bloc/calendar_bloc/calendar_bloc.dart';
import 'add_event_calendar_screen.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>(
      create: (_) => getIt<CalendarBloc>()..add(CalendarEventLoaded()),
      child: const _CalendarScaffold(),
    );
  }
}

class _CalendarScaffold extends StatelessWidget {
  const _CalendarScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        title: Text(
          AppConstant.CALENDAR_LABEL,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => context.navigateTo(
              BlocProvider.value(
                value: context.read<CalendarBloc>(),
                child: AddEventCalendar(),
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state.status == FormzStatus.submissionFailure) {
            return Center(child: Text('Error'));
          }
          if (state.status == FormzStatus.submissionInProgress) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            children: [
              const _CalendarSection(),
              const SizedBox(height: 30.0),
              const _HeaderDetailCalendarSection(),
              const _DetailCalendarSection(),
            ],
          );
        },
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection();

  @override
  Widget build(BuildContext context) {
    final _calendarBloc = context.read<CalendarBloc>();
    CalendarBuilders calendarBuilder() {
      return CalendarBuilders(markerBuilder: (context, date, events) {
        if (events.isNotEmpty) {
          return Positioned(
            bottom: 1,
            child: Container(
              padding: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 15.0, minHeight: 15.0),
              child: Center(
                child: Text(
                  "${events.length}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
        return Container();
      });
    }

    final kFirstDay = DateTime(DateTime.now().year - 5);
    final kLastDay = DateTime(DateTime.now().year + 5);

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return TableCalendar(
          calendarBuilders: calendarBuilder(),
          eventLoader: null,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.pink[200],
              shape: BoxShape.circle,
            ),
          ),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: state.focusedDate ?? DateTime.now(),
          calendarFormat: state.format,
          selectedDayPredicate: (day) {
            return isSameDay(day, state.selectedDate ?? DateTime.now());
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(state.selectedDate ?? DateTime.now(), selectedDay)) {
              _calendarBloc.add(SetSelectedDate(selectedDate: selectedDay));
              _calendarBloc.add(SetFocusedDate(focusedDate: focusedDay));
            }
          },
          onFormatChanged: (format) {
            if (state.format != format) {
              _calendarBloc.add(SetFormat(format: format));
            }
          },
          onPageChanged: (focusedDay) {
            _calendarBloc.add(SetFocusedDate(focusedDate: focusedDay));
            _calendarBloc.add(SetCurrentPageDate(currentPageDate: focusedDay));
          },
        );
      },
    );
  }
}

class _HeaderDetailCalendarSection extends StatelessWidget {
  const _HeaderDetailCalendarSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate,
      builder: (context, state) {
        if (state.selectedDate.isNull()) {
          return const SizedBox();
        }
        final dateString = () {
          if (state.selectedDate.isNull()) {
            return '';
          }
          return DateFormat('dd MMMM yyyy').format(state.selectedDate!);
        }();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar aktivitas : ' + dateString,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: IconButton(
                    onPressed: () {
                      context.read<CalendarBloc>().add(
                            SetSelectedDate(selectedDate: null),
                          );
                    },
                    icon: Icon(
                      Icons.close_rounded,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5.0),
            ...?state.selectedEvents?.map(
              (event) => ListTile(
                title: Text(event.activity ?? emptyString),
                subtitle: Text(
                  event.date.isNotNull()
                      ? DateFormat('dd-MM-yyyy').format(event.date!)
                      : emptyString,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DetailCalendarSection extends StatelessWidget {
  const _DetailCalendarSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state.selectedDate != null) {
          return DataTable(
            headingRowHeight: 40,
            headingTextStyle: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            dataTextStyle: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
            ),
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).primaryColor),
            columns: [
              DataColumn(
                label: Text('Tanggal'),
              ),
              DataColumn(
                label: Text('Aktivitas'),
              ),
              DataColumn(
                label: Text(''),
              ),
            ],
            rows: state.groupedEvents?[state.selectedDate]?.map((e) {
                  return _ListRowEvent(
                    event: e,
                  ).build(context);
                }).toList() ??
                [],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _ListRowEvent {
  const _ListRowEvent({
    required this.event,
  });

  final CalendarModel event;

  DataRow build(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(event.date!).toString(),
          ),
        ),
        DataCell(
          Text(
            event.activity ?? emptyString,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          (event.readOnly == true)
              ? PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (item) {
                    selectedItem(
                      context,
                      item,
                      event,
                    );
                  },
                  initialValue: 2,
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).primaryColor,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(
                        AppConstant.EDIT,
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        AppConstant.DELETE,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ),
      ],
    );
  }

  void confirmDeleteDialog(BuildContext context, CalendarModel event) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
        child: Text(AppConstant.NO),
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ));
    Widget continueButton = TextButton(
      child: Text(AppConstant.YES),
      onPressed: () async {
        context.read<CalendarBloc>().add(DeleteEvent(event: event));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppConstant.CONFIRMATION),
      content: Text(AppConstant.DELETE_CONFIRMATION_QUESTION),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void selectedItem(BuildContext context, item, CalendarModel data) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UpdateEventCalendar(docID: data.documentID, data: data)));
        break;
      case 1:
        confirmDeleteDialog(context, event);
    }
  }
}
