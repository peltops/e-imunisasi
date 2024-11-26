import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/features/contact/logic/clinic_bloc/clinic_bloc.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/core/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ClinicListScreen extends StatelessWidget {
  final name;

  const ClinicListScreen({
    Key? key,
    this.name = 'klinik',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClinicBloc>(
      create: (context) => getIt<ClinicBloc>()
        ..add(
          GetClinics(),
        ),
      child: _ClinicListScaffold(name),
    );
  }
}

class _ClinicListScaffold extends StatefulWidget {
  final String name;

  const _ClinicListScaffold(
    this.name, {
    Key? key,
  }) : super(key: key);

  @override
  State<_ClinicListScaffold> createState() => _ClinicListScaffoldState();
}

class _ClinicListScaffoldState extends State<_ClinicListScaffold>
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
      final currentPage = context.read<ClinicBloc>().state.page;
      context.read<ClinicBloc>().add(ChangePage(currentPage + 1));
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
              child: BlocListener<ClinicBloc, ClinicState>(
                listener: (context, state) {
                  if (state.statusGetClinic == FormzSubmissionStatus.success) {
                    setState(() {
                      _isFetching = false;
                    });
                  }
                },
                child: BlocBuilder<ClinicBloc, ClinicState>(
                  builder: (context, state) {
                    final data = state.clinics.data ?? [];
                    if (state.statusGetClinic ==
                            FormzSubmissionStatus.inProgress &&
                        data.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.statusGetClinic ==
                        FormzSubmissionStatus.failure) {
                      return ErrorContainer(
                        message: "Gagal memuat data",
                        onRefresh: () {
                          context.read<ClinicBloc>().add(GetClinics());
                        },
                      );
                    }
                    if (data.isEmpty) {
                      return ErrorContainer(
                        message: "Data tidak ditemukan",
                        onRefresh: () {
                          context.read<ClinicBloc>().add(GetClinics());
                        },
                      );
                    }
                    return Column(
                      children: [
                        SearchBarPeltops(
                          onChanged: (value) {
                            context.read<ClinicBloc>().add(
                                  ChangeSearch(value),
                                );
                          },
                        ),
                        Flexible(
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: () {
                                if (state.statusGetClinic ==
                                    FormzSubmissionStatus.inProgress) {
                                  return data.length + 1;
                                }
                                return data.length;
                              }(),
                              itemBuilder: (context, index) {
                                if (index == data.length &&
                                    state.statusGetClinic ==
                                        FormzSubmissionStatus.inProgress) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Card(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            data[index].name ?? '',
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
                                        title:
                                            Text(data[index].phoneNumber ?? ''),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.maps_home_work_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        title: Text(data[index].address ?? ''),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
