import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/repositories/calendar_repository.dart';
import 'package:eimunisasi/features/calendar/logic/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_calendar/table_calendar.dart';

@GenerateMocks([
  CalendarRepository,
])
import 'calendar_bloc_test.mocks.dart';

void main() {
  late CalendarRepository calendarRepository;

  setUp(() {
    calendarRepository = MockCalendarRepository();
  });

  group('CalendarBloc', () {
    blocTest<CalendarBloc, CalendarState>(
      'emits [] when nothing is added',
      build: () => CalendarBloc(
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          CalendarEventLoaded(),
        ),
      expect: () => [
        CalendarState(
          status: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          status: FormzStatus.submissionSuccess,
          events: response,
          groupedEvents: response.groupEventsByDate(),
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'emits status failure when deleteAllEventLocal() throws',
      setUp: () {
        when(calendarRepository.deleteAllEventLocal())
            .thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(calendarRepository)
        ..add(
          CalendarEventLoaded(),
        ),
      expect: () => [
        CalendarState(
          status: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          status: FormzStatus.submissionFailure,
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          CalendarEventLoaded(),
        ),
      expect: () => [
        CalendarState(
          status: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          status: FormzStatus.submissionFailure,
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          AddEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusAddEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusAddEvent: FormzStatus.submissionSuccess,
          events: [event],
          groupedEvents: [event].groupEventsByDate(),
        ),
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          AddEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusAddEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusAddEvent: FormzStatus.submissionFailure,
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          AddEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusAddEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusAddEvent: FormzStatus.submissionFailure,
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
        when(calendarRepository.updateEventLocal(event))
            .thenAnswer((_) async => 1);
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(calendarRepository)
        ..add(
          UpdateEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusUpdateEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusUpdateEvent: FormzStatus.submissionSuccess,
          events: [event],
          groupedEvents: [event].groupEventsByDate(),
        ),
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
        when(calendarRepository.updateEventLocal(
          event,
        )).thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(calendarRepository)
        ..add(
          UpdateEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusUpdateEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusUpdateEvent: FormzStatus.submissionFailure,
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
        when(calendarRepository.updateEventLocal(
          event,
        )).thenAnswer((_) async => 1);
        when(calendarRepository.updateEvent(event))
            .thenThrow(Exception('error'));
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(calendarRepository)
        ..add(
          UpdateEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusUpdateEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusUpdateEvent: FormzStatus.submissionFailure,
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
        );
        when(calendarRepository.deleteEvent(event.documentID.orEmpty))
            .thenAnswer((_) async => event);
        when(calendarRepository.deleteEventLocal(event))
            .thenAnswer((_) async => 1);
      },
      tearDown: () {
        reset(calendarRepository);
      },
      build: () => CalendarBloc(calendarRepository)
        ..add(
          DeleteEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionSuccess,
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
    );
    final mockEvent2 = CalendarModel(
      uid: 'uid2',
      activity: 'activity2',
      date: date,
      documentID: 'documentID2',
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
      },
      tearDown: () {
        reset(calendarRepository);
      },
      seed: () {
        return CalendarState(
          events: mockEvents,
          groupedEvents: mockEvents.groupEventsByDate(),
        );
      },
      build: () => CalendarBloc(calendarRepository),
      act: (bloc) => bloc.add(
        DeleteEvent(event: mockEvents[1]),
      ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionInProgress,
          events: [mockEvent1],
          groupedEvents: [
            mockEvent1,
            mockEvent2,
          ].groupEventsByDate(),
        ),
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionSuccess,
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          DeleteEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionFailure,
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
      build: () => CalendarBloc(calendarRepository)
        ..add(
          DeleteEvent(
            event: event,
          ),
        ),
      expect: () => [
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionInProgress,
        ),
        CalendarState(
          statusDeleteEvent: FormzStatus.submissionFailure,
        ),
      ],
    );
  });
}
