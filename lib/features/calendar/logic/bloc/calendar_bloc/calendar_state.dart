part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState(
      {this.status = FormzSubmissionStatus.initial,
      this.statusAddEvent = FormzSubmissionStatus.initial,
      this.statusUpdateEvent = FormzSubmissionStatus.initial,
      this.statusDeleteEvent = FormzSubmissionStatus.initial,
      this.errorMessage,
      this.events,
      this.selectedEvents,
      this.groupedEvents,
      this.selectedDate,
      this.focusedDate,
      this.currentPageDate,
      this.format = CalendarFormat.month,
      this.dateTimeForm,
      this.activityForm = emptyString});

  final FormzSubmissionStatus status;
  final FormzSubmissionStatus statusAddEvent;
  final FormzSubmissionStatus statusUpdateEvent;
  final FormzSubmissionStatus statusDeleteEvent;
  final String? errorMessage;
  final List<CalendarModel>? events;
  final List<CalendarModel>? selectedEvents;
  final LinkedHashMap<DateTime, List<CalendarModel>>? groupedEvents;
  final DateTime? selectedDate;
  final DateTime? focusedDate;
  final DateTime? currentPageDate;
  final CalendarFormat format;
  final DateTime? dateTimeForm;
  final String activityForm;

  CalendarState copyWith({
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusAddEvent,
    FormzSubmissionStatus? statusUpdateEvent,
    FormzSubmissionStatus? statusDeleteEvent,
    String? errorMessage,
    List<CalendarModel>? events,
    List<CalendarModel>? selectedEvents,
    LinkedHashMap<DateTime, List<CalendarModel>>? groupedEvents,
    DateTime? selectedDate,
    DateTime? focusedDate,
    DateTime? currentPageDate,
    CalendarFormat? format,
    DateTime? dateTimeForm,
    String? activityForm,
  }) {
    return CalendarState(
      status: status ?? this.status,
      statusAddEvent: statusAddEvent ?? this.statusAddEvent,
      statusUpdateEvent: statusUpdateEvent ?? this.statusUpdateEvent,
      statusDeleteEvent: statusDeleteEvent ?? this.statusDeleteEvent,
      errorMessage: errorMessage ?? this.errorMessage,
      events: events ?? this.events,
      selectedEvents: selectedEvents ?? this.selectedEvents,
      groupedEvents: groupedEvents ?? this.groupedEvents,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      currentPageDate: currentPageDate ?? this.currentPageDate,
      format: format ?? this.format,
      dateTimeForm: dateTimeForm ?? this.dateTimeForm,
      activityForm: activityForm ?? this.activityForm,
    );
  }

  @override
  List<Object?> get props => [
        status,
        statusAddEvent,
        statusUpdateEvent,
        statusDeleteEvent,
        errorMessage,
        events,
        selectedEvents,
        groupedEvents,
        selectedDate,
        focusedDate,
        currentPageDate,
        format,
        dateTimeForm,
        activityForm,
      ];
}
