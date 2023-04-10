import 'package:flutter/material.dart';

class DetailInformasiPage extends StatefulWidget {
  final data;
  const DetailInformasiPage({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  _DetailInformasiPageState createState() => _DetailInformasiPageState();
}

class _DetailInformasiPageState extends State<DetailInformasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            'Detail Informasi',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
            width: double.infinity,
            color: Colors.pink[100],
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.data.judul,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    Container(
                      width: double.infinity,
                      child: Card(
                          color: Theme.of(context).colorScheme.secondary,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data.deskripsi,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Penulis: ' + widget.data.penulis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.data.createdAt
                                          .toString()
                                          .split(" ")[0],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )));
  }
}
