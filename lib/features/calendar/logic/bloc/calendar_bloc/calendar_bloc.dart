import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/core/utils/datetime_extension.dart';
import 'package:eimunisasi/core/utils/string_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/extension.dart';
import '../../../../../services/notifications.dart';
import '../../../data/repositories/calendar_repository.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

@injectable
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final NotificationService notificationService;
  final CalendarRepository calendarRepository;

  CalendarBloc(
    this.notificationService,
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
    on<SetDateTimeForm>(_onSetAddDate);
    on<SetActivityForm>(_onSetAddActivity);
  }

  void _onCalendarEventLoaded(
    CalendarEventLoaded event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final events = await calendarRepository.getEvents();
      final groupedEvents = events.groupEventsByDate();

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        events: events,
        groupedEvents: groupedEvents,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
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
      emit(state.copyWith(statusAddEvent: FormzSubmissionStatus.inProgress));
      final response = await calendarRepository.setEvent(event.event);
      final idNotif = await calendarRepository.setEventLocal(response);
      final currentEvents = (state.events ?? [])..add(response);

      emit(state.copyWith(
        statusAddEvent: FormzSubmissionStatus.success,
        events: currentEvents,
        groupedEvents: currentEvents.groupEventsByDate(),
      ));
      final validCreateNotification =
          response.date?.isAfter(DateTime.now()) == true &&
              response.createdDate != null;
      if (validCreateNotification) {
        await notificationService.scheduledNotification(
          idNotif,
          'Pengingat jadwal',
          'Aktivitas: ' + response.activity.orEmpty,
          response.date.orNow,
        );
      }
      emit(state.copyWith(
        statusAddEvent: FormzSubmissionStatus.initial,
        dateTimeForm: null,
        activityForm: emptyString,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(statusAddEvent: FormzSubmissionStatus.failure));
      emit(state.copyWith(statusAddEvent: FormzSubmissionStatus.initial));
    }
  }

  void _onUpdateEvent(
    UpdateEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(statusUpdateEvent: FormzSubmissionStatus.inProgress));
      final response = await calendarRepository.updateEvent(event.event);
      final idNotif = await calendarRepository.setEventLocal(response);
      final currentEvents = (state.events ?? [])
        ..removeWhere((element) => element.documentID == event.event.documentID)
        ..add(response);

      emit(state.copyWith(
        statusUpdateEvent: FormzSubmissionStatus.success,
        events: currentEvents,
        groupedEvents: currentEvents.groupEventsByDate(),
      ));
      final validCreateNotification =
          response.date?.isAfter(DateTime.now()) == true &&
              response.createdDate != null;
      if (validCreateNotification) {
        await notificationService.scheduledNotification(
          idNotif,
          'Pengingat jadwal',
          'Aktivitas: ' + response.activity.orEmpty,
          response.date.orNow,
        );
      }
      emit(state.copyWith(
        statusUpdateEvent: FormzSubmissionStatus.initial,
        dateTimeForm: null,
        activityForm: emptyString,
      ));
    } catch (e) {
      log("error update event: ${e.toString()}");
      emit(state.copyWith(statusUpdateEvent: FormzSubmissionStatus.failure));
      emit(state.copyWith(statusUpdateEvent: FormzSubmissionStatus.initial));
    }
  }

  void _onDeleteEvent(
    DeleteEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(statusDeleteEvent: FormzSubmissionStatus.inProgress));
      await calendarRepository.deleteEvent(event.event.documentID.orEmpty);
      await calendarRepository.deleteEventLocal(event.event);
      final currentEvents = (state.events ?? [])
        ..removeWhere(
          (element) => element.documentID == event.event.documentID,
        );
      emit(state.copyWith(
        statusDeleteEvent: FormzSubmissionStatus.success,
        events: currentEvents,
        groupedEvents: currentEvents.groupEventsByDate(),
      ));
      await notificationService.cancelNotification(
        event.event.createdDate!.millisecondsSinceEpoch,
      );
      emit(state.copyWith(
        statusDeleteEvent: FormzSubmissionStatus.initial,
        dateTimeForm: null,
        activityForm: emptyString,
      ));
    } catch (e) {
      log("error delete event: ${e.toString()}");
      emit(state.copyWith(statusDeleteEvent: FormzSubmissionStatus.failure));
      emit(state.copyWith(statusDeleteEvent: FormzSubmissionStatus.initial));
    }
  }

  void _onSetAddDate(
    SetDateTimeForm event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(dateTimeForm: event.value));
  }

  void _onSetAddActivity(
    SetActivityForm event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(activityForm: event.value));
  }
}
