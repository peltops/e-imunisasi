import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/health_worker/logic/blocs/healthWorkerBloc/health_worker_bloc.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/core/widgets/search_bar.dart';
import 'package:eimunisasi/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ChooseHealthWorkerScreen extends StatelessWidget {
  final Anak child;
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

class _ChooseHealthWorkerScaffold extends StatelessWidget {
  final Anak child;
  final Function(HealthWorkerModel)? onSelected;

  const _ChooseHealthWorkerScaffold({
    required this.child,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentPage = context.watch<HealthWorkerBloc>().state.page;
    final ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent - 50) {
        context.read<HealthWorkerBloc>().add(
              ChangePage(currentPage + 1),
            );
      }
    });
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
                  child: BlocBuilder<HealthWorkerBloc, HealthWorkerState>(
                    builder: (context, state) {
                      if (state.statusGetHealthWorkers ==
                          FormzSubmissionStatus.inProgress &&
                          state.healthWorkers.isEmpty) {
                        return Center(child: CircularProgressIndicator());
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
                      final data = state.healthWorkers;
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
                        itemCount: (){
                          if (state.page == 1) {
                            return data.length;
                          } else {
                            return data.length + 1;
                          }
                        }(),
                        itemBuilder: (context, index) {
                          if (index == data.length) {
                            return LinearProgressIndicator();
                          }
                          final healthWorker = data[index];
                          return _ListTileHealthWorker(
                            healthWorker: healthWorker,
                            onSelected: (healthWorker) {
                              if (onSelected != null) {
                                onSelected!(healthWorker);
                              }
                            },
                          );
                        },
                      );
                    },
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
