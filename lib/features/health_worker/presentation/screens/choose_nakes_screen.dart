import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/health_worker/logic/blocs/healthWorkerBloc/health_worker_bloc.dart';
import 'package:eimunisasi/features/profile/data/models/child_model.dart';
import 'package:eimunisasi/core/widgets/search_bar.dart';
import 'package:eimunisasi/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ChooseHealthWorkerScreen extends StatelessWidget {
  final ChildModel child;
  final Function(HealthWorkerModel)? onSelected;

  const ChooseHealthWorkerScreen({
    Key? key,
    required this.child,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HealthWorkerBloc>()..add(GetHealthWorkers()),
      child: _ChooseHealthWorkerScaffold(
        child: child,
        onSelected: onSelected,
      ),
    );
  }
}

class _ChooseHealthWorkerScaffold extends StatefulWidget {
  final ChildModel child;
  final Function(HealthWorkerModel)? onSelected;

  const _ChooseHealthWorkerScaffold({
    required this.child,
    this.onSelected,
  });

  @override
  State<_ChooseHealthWorkerScaffold> createState() =>
      _ChooseHealthWorkerScaffoldState();
}

class _ChooseHealthWorkerScaffoldState
    extends State<_ChooseHealthWorkerScaffold>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  bool _isFetching = false;

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
      if (_isFetching) return;
      final currentPage = context.read<HealthWorkerBloc>().state.page;
      context.read<HealthWorkerBloc>().add(ChangePage(currentPage + 1));
      setState(() {
        _isFetching = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih nakes',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.pink[100],
        child: Card(
          elevation: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SearchBarPeltops(
                  onChanged: (value) {
                    context.read<HealthWorkerBloc>().add(
                          ChangeSearch(value),
                        );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: BlocListener<HealthWorkerBloc, HealthWorkerState>(
                    listener: (context, state) {
                      if (state.statusGetHealthWorkers !=
                          FormzSubmissionStatus.inProgress) {
                        setState(() {
                          _isFetching = false;
                        });
                      }
                    },
                    child: BlocBuilder<HealthWorkerBloc, HealthWorkerState>(
                      builder: (context, state) {
                        final data = state.healthWorkers.data ?? [];
                        if (state.statusGetHealthWorkers ==
                                FormzSubmissionStatus.inProgress &&
                            data.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.statusGetHealthWorkers ==
                            FormzSubmissionStatus.failure) {
                          return ErrorContainer(
                            message: 'Gagal memuat data',
                            onRefresh: () {
                              context
                                  .read<HealthWorkerBloc>()
                                  .add(GetHealthWorkers());
                            },
                          );
                        }
                        if (data.isEmpty) {
                          return ErrorContainer(
                            message: 'Data tidak ditemukan',
                            onRefresh: () {
                              context
                                  .read<HealthWorkerBloc>()
                                  .add(GetHealthWorkers());
                            },
                          );
                        }
                        return ListView.builder(
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
                            final healthWorker = data[index];
                            return _ListTileHealthWorker(
                              healthWorker: healthWorker,
                              onSelected: (healthWorker) {
                                if (widget.onSelected != null) {
                                  widget.onSelected!(healthWorker);
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTileHealthWorker extends StatelessWidget {
  final HealthWorkerModel healthWorker;
  final Function(HealthWorkerModel)? onSelected;

  const _ListTileHealthWorker({
    required this.healthWorker,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          if (onSelected != null) {
            onSelected!(healthWorker);
            return;
          }
        },
        title: Text(
          healthWorker.fullName ?? "",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          healthWorker.profession ?? "",
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right_rounded,
        ),
      ),
    );
  }
}
