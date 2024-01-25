part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState({
    this.status = FormzStatus.pure,
    this.statusAddEvent = FormzStatus.pure,
    this.statusUpdateEvent = FormzStatus.pure,
    this.statusDeleteEvent = FormzStatus.pure,
    this.errorMessage,
    this.events,
    this.selectedEvents,
    this.groupedEvents,
    this.selectedDate,
    this.focusedDate,
    this.currentPageDate,
    this.format = CalendarFormat.month,
  });

  final FormzStatus status;
  final FormzStatus statusAddEvent;
  final FormzStatus statusUpdateEvent;
  final FormzStatus statusDeleteEvent;
  final String? errorMessage;
  final List<CalendarModel>? events;
  final List<CalendarModel>? selectedEvents;
  final LinkedHashMap<DateTime, List<CalendarModel>>? groupedEvents;
  final DateTime? selectedDate;
  final DateTime? focusedDate;
  final DateTime? currentPageDate;
  final CalendarFormat format;

  CalendarState copyWith({
    FormzStatus? status,
    FormzStatus? statusAddEvent,
    FormzStatus? statusUpdateEvent,
    FormzStatus? statusDeleteEvent,
    String? errorMessage,
    List<CalendarModel>? events,
    List<CalendarModel>? selectedEvents,
    LinkedHashMap<DateTime, List<CalendarModel>>? groupedEvents,
    DateTime? selectedDate,
    DateTime? focusedDate,
    DateTime? currentPageDate,
    CalendarFormat? format,
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
      ];
}
