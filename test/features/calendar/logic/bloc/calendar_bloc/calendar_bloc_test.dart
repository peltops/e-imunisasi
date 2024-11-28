import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/repositories/calendar_repository.dart';
import 'package:eimunisasi/features/calendar/logic/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:eimunisasi/core/utils/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_calendar/table_calendar.dart';

@GenerateMocks([
  CalendarRepository,
  NotificationService,
])
import 'calendar_bloc_test.mocks.dart';

void main() {
  late CalendarRepository calendarRepository;
  late NotificationService notificationService;

  setUp(() {
    calendarRepository = MockCalendarRepository();
    notificationService = MockNotificationService();
  });

  group('CalendarBloc', () {
    blocTest<CalendarBloc, CalendarState>(
      'emits [] when nothing is added',
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      ),
      expect: () => [],
    );
  });

  group('CalendarEventLoaded', () {
    late List<CalendarModel> response;

    blocTest<CalendarBloc, CalendarState>(
      'emits status success when CalendarEventLoaded is called',
      setUp: () {
        response = [
          CalendarModel(
            uid: 'uid',
            activity: 'activity',
            date: DateTime.now(),
          ),
          CalendarModel(
            uid: 'uid2',
            activity: 'activity2',
            date: DateTime.now(),
          ),
        ];
        when(calendarRepository.deleteAllEventLocal())
            .thenAnswer((_) async => 1);
        when(calendarRepository.getEvents()).thenAnswer((_) async => response);
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          CalendarEventLoaded(),
        ),
      expect: () => [
        CalendarState(
          status: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          status: FormzSubmissionStatus.success,
          events: response,
          groupedEvents: response.groupEventsByDate(),
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when getEvents() throws',
      setUp: () {
        when(calendarRepository.deleteAllEventLocal())
            .thenAnswer((_) async => 1);
        when(calendarRepository.getEvents()).thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          CalendarEventLoaded(),
        ),
      expect: () => [
        CalendarState(
          status: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          status: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          status: FormzSubmissionStatus.initial,
        ),
      ],
    );
  });

  group('SetSelectedDate', () {
    late DateTime selectedDate;
    blocTest<CalendarBloc, CalendarState>(
      'emits selectedDate when SetSelectedDate is called',
      setUp: () {
        selectedDate = DateTime.now();
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          SetSelectedDate(
            selectedDate: selectedDate,
          ),
        ),
      expect: () => [
        CalendarState(
          selectedDate: selectedDate,
        ),
      ],
    );
  });

  group('SetFocusedDate', () {
    late DateTime focusedDate;
    blocTest<CalendarBloc, CalendarState>(
      'emits focusedDate when SetFocusedDate is called',
      setUp: () {
        focusedDate = DateTime.now();
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          SetFocusedDate(
            focusedDate: focusedDate,
          ),
        ),
      expect: () => [
        CalendarState(
          focusedDate: focusedDate,
        ),
      ],
    );
  });

  group('SetCurrentPageDate', () {
    late DateTime currentPageDate;
    blocTest<CalendarBloc, CalendarState>(
      'emits currentPageDate when SetCurrentPageDate is called',
      setUp: () {
        currentPageDate = DateTime.now();
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          SetCurrentPageDate(
            currentPageDate: currentPageDate,
          ),
        ),
      expect: () => [
        CalendarState(
          currentPageDate: currentPageDate,
        ),
      ],
    );
  });

  group('SetFormat', () {
    blocTest<CalendarBloc, CalendarState>(
      'emits format when SetFormat is called',
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          SetFormat(
            format: CalendarFormat.week,
          ),
        ),
      expect: () => [
        CalendarState(
          format: CalendarFormat.week,
        ),
      ],
    );
  });

  group('AddEvent', () {
    late CalendarModel event;
    blocTest<CalendarBloc, CalendarState>(
      'emits status success when AddEvent is called',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.setEvent(event)).thenAnswer((_) async => event);
        when(calendarRepository.setEventLocal(event))
            .thenAnswer((_) async => 1);
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          AddEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.success,
          events: [event],
          groupedEvents: [event].groupEventsByDate(),
        ),
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.initial,
          dateTimeForm: null,
          activityForm: emptyString,
          events: [event],
          groupedEvents: [event].groupEventsByDate(),
        )
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when setEventLocal() throws',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.setEventLocal(
          event,
        )).thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          AddEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.initial,
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when setEvent() throws',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.setEventLocal(
          event,
        )).thenAnswer((_) async => 1);
        when(calendarRepository.setEvent(event)).thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          AddEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          statusAddEvent: FormzSubmissionStatus.initial,
        ),
      ],
    );
  });

  group('UpdateEvent', () {
    late CalendarModel event;
    blocTest<CalendarBloc, CalendarState>(
      'emits status success when UpdateEvent is called',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.updateEvent(event))
            .thenAnswer((_) async => event);
        when(calendarRepository.setEventLocal(event))
            .thenAnswer((_) async => 1);
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          UpdateEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.success,
          events: [event],
          groupedEvents: [event].groupEventsByDate(),
        ),
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.initial,
          dateTimeForm: null,
          activityForm: emptyString,
          events: [event],
          groupedEvents: [event].groupEventsByDate(),
        )
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when updateEventLocal() throws',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.setEventLocal(
          event,
        )).thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          UpdateEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.initial,
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when updateEvent() throws',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.setEventLocal(
          event,
        )).thenAnswer((_) async => 1);
        when(calendarRepository.updateEvent(event))
            .thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          UpdateEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          statusUpdateEvent: FormzSubmissionStatus.initial,
        ),
      ],
    );
  });

  group('DeleteEvent', () {
    late CalendarModel event;
    final date = DateTime.now();
    blocTest<CalendarBloc, CalendarState>(
      'emits status success when DeleteEvent is called with state.events is empty',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: date,
          createdDate: DateTime.now(),
        );
        when(calendarRepository.deleteEvent(event.documentID.orEmpty))
            .thenAnswer((_) async => event);
        when(calendarRepository.deleteEventLocal(event))
            .thenAnswer((_) async => 1);
        when(notificationService
                .cancelNotification(event.createdDate!.millisecondsSinceEpoch))
            .thenAnswer((_) async => 1);
      },
      tearDown: () {
        reset(calendarRepository);
        reset(notificationService);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          DeleteEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.success,
          events: [],
          groupedEvents: <CalendarModel>[].groupEventsByDate(),
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.initial,
          dateTimeForm: null,
          activityForm: emptyString,
          events: [],
          groupedEvents: <CalendarModel>[].groupEventsByDate(),
        ),
      ],
    );

    final mockEvent1 = CalendarModel(
      uid: 'uid',
      activity: 'activity',
      date: date,
      documentID: 'documentID',
      createdDate: DateTime.now(),
    );
    final mockEvent2 = CalendarModel(
      uid: 'uid2',
      activity: 'activity2',
      date: date,
      documentID: 'documentID2',
      createdDate: DateTime.now(),
    );
    late List<CalendarModel> mockEvents;

    blocTest<CalendarBloc, CalendarState>(
      'emits status success when DeleteEvent is called with state.events is not empty',
      setUp: () {
        mockEvents = [
          mockEvent1,
          mockEvent2,
        ];
        when(calendarRepository.deleteEvent(mockEvents[1].documentID.orEmpty))
            .thenAnswer((_) async => Future.value());
        when(calendarRepository.deleteEventLocal(mockEvents[1]))
            .thenAnswer((_) async => 1);
        when(
          notificationService.cancelNotification(
            mockEvents[1].createdDate!.millisecondsSinceEpoch,
          ),
        ).thenAnswer((_) async => 1);
      },
      tearDown: () {
        reset(calendarRepository);
        reset(notificationService);
      },
      seed: () {
        return CalendarState(
          events: mockEvents,
          groupedEvents: mockEvents.groupEventsByDate(),
        );
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      ),
      act: (bloc) => bloc.add(
        DeleteEvent(event: mockEvents[1]),
      ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.inProgress,
          events: [mockEvent1],
          groupedEvents: [
            mockEvent1,
            mockEvent2,
          ].groupEventsByDate(),
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.success,
          events: <CalendarModel>[mockEvent1],
          groupedEvents: <CalendarModel>[mockEvent1].groupEventsByDate(),
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.initial,
          dateTimeForm: null,
          activityForm: emptyString,
          events: <CalendarModel>[mockEvent1],
          groupedEvents: <CalendarModel>[mockEvent1].groupEventsByDate(),
        ),
      ],
    );
    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when deleteEventLocal() throws',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.deleteEventLocal(
          event,
        )).thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          DeleteEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.initial,
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when deleteEvent() throws',
      setUp: () {
        event = CalendarModel(
          uid: 'uid',
          activity: 'activity',
          date: DateTime.now(),
        );
        when(calendarRepository.deleteEventLocal(
          event,
        )).thenAnswer((_) async => 1);
        when(calendarRepository.deleteEvent(event.documentID.orEmpty))
            .thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          DeleteEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.inProgress,
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.failure,
        ),
        CalendarState(
          statusDeleteEvent: FormzSubmissionStatus.initial,
        ),
      ],
    );
  });

  group('SetDateTimeForm', () {
    late DateTime dateTime;
    blocTest<CalendarBloc, CalendarState>(
      'emits dateTimeForm when SetDateTimeForm is called',
      setUp: () {
        dateTime = DateTime.now();
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          SetDateTimeForm(
            value: dateTime,
          ),
        ),
      expect: () => [
        CalendarState(
          dateTimeForm: dateTime,
        ),
      ],
    );
  });

  group('SetActivityForm', () {
    late String activity;
    blocTest<CalendarBloc, CalendarState>(
      'emits activityForm when SetActivityForm is called',
      setUp: () {
        activity = 'activity';
      },
      build: () => CalendarBloc(
        notificationService,
        calendarRepository,
      )..add(
          SetActivityForm(
            value: activity,
          ),
        ),
      expect: () => [
        CalendarState(
          activityForm: activity,
        ),
      ],
    );
  });
}
