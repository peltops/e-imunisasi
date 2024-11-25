import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/features/health_worker/logic/blocs/healthWorkerBloc/health_worker_bloc.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/core/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class HealthWorkerListScreen extends StatelessWidget {
  final String name;

  const HealthWorkerListScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HealthWorkerBloc>(
      create: (context) => getIt<HealthWorkerBloc>()..add(GetHealthWorkers()),
      child: _HealthWorkerListScaffold(name: name),
    );
  }
}

class _HealthWorkerListScaffold extends StatefulWidget {
  final String name;

  const _HealthWorkerListScaffold({
    required this.name,
  });

  @override
  _HealthWorkerListScaffoldState createState() =>
      _HealthWorkerListScaffoldState();
}

class _HealthWorkerListScaffoldState extends State<_HealthWorkerListScaffold>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final currentPage = context.read<HealthWorkerBloc>().state.page;
      context.read<HealthWorkerBloc>().add(ChangePage(currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        title: Text(
          'Daftar ${widget.name}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          color: Colors.pink[100],
          child: Card(
            margin: EdgeInsets.all(20),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocBuilder<HealthWorkerBloc, HealthWorkerState>(
                builder: (context, state) {
                  if (state.statusGetHealthWorkers ==
                          FormzSubmissionStatus.inProgress &&
                      state.healthWorkers.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.statusGetHealthWorkers ==
                      FormzSubmissionStatus.failure) {
                    return ErrorContainer(
                      message: "Gagal memuat data",
                      onRefresh: () {
                        context
                            .read<HealthWorkerBloc>()
                            .add(GetHealthWorkers());
                      },
                    );
                  }
                  if (state.healthWorkers.isEmpty) {
                    return ErrorContainer(
                      message: "Data tidak ditemukan",
                      onRefresh: () {
                        context
                            .read<HealthWorkerBloc>()
                            .add(GetHealthWorkers());
                      },
                    );
                  }
                  var data = state.healthWorkers;
                  return Column(
                    children: [
                      SearchBarPeltops(
                        onChanged: (value) {
                          context.read<HealthWorkerBloc>().add(
                                ChangeSearch(value),
                              );
                        },
                      ),
                      Flexible(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: () {
                            if (state.statusGetHealthWorkers ==
                                FormzSubmissionStatus.inProgress) {
                              return data.length + 1;
                            }
                            return data.length;
                          }(),
                          itemBuilder: (context, index) {
                            if (index == data.length &&
                                state.statusGetHealthWorkers ==
                                    FormzSubmissionStatus.inProgress) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Card(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        data[index].fullName ?? '-',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(data[index].phoneNumber ?? '-'),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.medical_services_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(data[index].profession ?? '-'),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
