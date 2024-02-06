part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class CalendarEventLoaded extends CalendarEvent {
  CalendarEventLoaded();

  @override
  List<Object> get props => [];
}

class SetSelectedDate extends CalendarEvent {
  final DateTime? selectedDate;

  SetSelectedDate({
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [
        selectedDate,
      ];
}

class SetFocusedDate extends CalendarEvent {
  final DateTime focusedDate;

  SetFocusedDate({
    required this.focusedDate,
  });

  @override
  List<Object> get props => [
        focusedDate,
      ];
}

class SetCurrentPageDate extends CalendarEvent {
  final DateTime currentPageDate;

  SetCurrentPageDate({
    required this.currentPageDate,
  });

  @override
  List<Object> get props => [
        currentPageDate,
      ];
}

class SetFormat extends CalendarEvent {
  final CalendarFormat format;

  SetFormat({
    required this.format,
  });

  @override
  List<Object> get props => [
        format,
      ];
}

class AddEvent extends CalendarEvent {
  final CalendarModel event;

  AddEvent({
    required this.event,
  });

  @override
  List<Object> get props => [
    event,
  ];
}

class UpdateEvent extends CalendarEvent {
  final CalendarModel event;

  UpdateEvent({
    required this.event,
  });

  @override
  List<Object> get props => [
    event,
  ];
}

class DeleteEvent extends CalendarEvent {
  final CalendarModel event;

  DeleteEvent({
    required this.event,
  });

  @override
  List<Object> get props => [
    event,
  ];

}

class SetDateTimeForm extends CalendarEvent {
  final DateTime? value;

  SetDateTimeForm({
    required this.value,
  });

  @override
  List<Object?> get props => [
    value,
  ];
}

class SetActivityForm extends CalendarEvent {
  final String? value;

  SetActivityForm({
    required this.value,
  });

  @override
  List<Object?> get props => [
    value,
  ];
}