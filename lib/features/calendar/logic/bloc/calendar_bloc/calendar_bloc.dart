import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/repositories/calendar_repository.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

@Singleton()
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository calendarRepository;

  CalendarBloc(
    this.calendarRepository,
  ) : super(CalendarState()) {
    on<CalendarEventLoaded>(_onCalendarEventLoaded);
    on<SetSelectedDate>(_onSetSelectedDate);
    on<SetFocusedDate>(_onSetFocusedDate);
    on<SetCurrentPageDate>(_onSetCurrentPageDate);
    on<SetFormat>(_onSetFormat);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  void _onCalendarEventLoaded(
    CalendarEventLoaded event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      calendarRepository.deleteAllEventLocal();
      final events = await calendarRepository.getEvents();
      final groupedEvents = events.groupEventsByDate();

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        events: events,
        groupedEvents: groupedEvents,
      ));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onSetSelectedDate(
    SetSelectedDate event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(selectedDate: event.selectedDate));
  }

  void _onSetFocusedDate(
    SetFocusedDate event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(focusedDate: event.focusedDate));
  }

  void _onSetCurrentPageDate(
    SetCurrentPageDate event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(currentPageDate: event.currentPageDate));
  }

  void _onSetFormat(
    SetFormat event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(format: event.format));
  }

  void _onAddEvent(
    AddEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(statusAddEvent: FormzStatus.submissionInProgress));
      final response = await calendarRepository.setEvent(event.event);
      await calendarRepository.setEventLocal(
        response,
      );
      final currentEvents = (state.events ?? [])..add(response);

      emit(state.copyWith(
        statusAddEvent: FormzStatus.submissionSuccess,
        events: currentEvents,
        groupedEvents: currentEvents.groupEventsByDate(),
      ));
    } catch (e) {
      emit(state.copyWith(statusAddEvent: FormzStatus.submissionFailure));
    }
  }

  void _onUpdateEvent(
    UpdateEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(statusUpdateEvent: FormzStatus.submissionInProgress));
      final response = await calendarRepository.updateEvent(event.event);
      await calendarRepository.updateEventLocal(
        response,
      );
      final currentEvents = (state.events ?? [])
        ..removeWhere((element) => element.documentID == event.event.documentID)
        ..add(response);
      emit(state.copyWith(
        statusUpdateEvent: FormzStatus.submissionSuccess,
        events: currentEvents,
        groupedEvents: currentEvents.groupEventsByDate(),
      ));
    } catch (e) {
      emit(state.copyWith(statusUpdateEvent: FormzStatus.submissionFailure));
    }
  }

  void _onDeleteEvent(
    DeleteEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(statusDeleteEvent: FormzStatus.submissionInProgress));
      await calendarRepository.deleteEvent(event.event.documentID.orEmpty);
      await calendarRepository.deleteEventLocal(
        event.event,
      );
      final currentEvents = (state.events ?? [])
        ..removeWhere(
            (element) => element.documentID == event.event.documentID);
      emit(state.copyWith(
        statusDeleteEvent: FormzStatus.submissionSuccess,
        events: currentEvents,
        groupedEvents: currentEvents.groupEventsByDate(),
      ));
    } catch (e) {
      emit(state.copyWith(statusDeleteEvent: FormzStatus.submissionFailure));
    }
  }
}
