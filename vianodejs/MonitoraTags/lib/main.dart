import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeline_tile/timeline_tile.dart';

Future<List<dynamic>> fetchclientes() async {
  final response =
      //await http.get(Uri.parse('http://localhost:3001/monitorar/api/tags'));
      await http.get(Uri.parse('http://192.168.0.85:3001/monitorar/api/tags'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falha ao carregar as Tags de monitoramento de serviços.');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MonitoraTags',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monitorar Vigencias'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _refleh() {
    setState(() {
      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title)),

      body: FutureBuilder<List<dynamic>>(
        future: fetchclientes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Erro: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      /**TIMELINE**/
                      TimelineTile(
                        isFirst: index == 0,
                        isLast: index == snapshot.data!.length - 1,
                        indicatorStyle: IndicatorStyle(
                          width: 30,
                          //color: Colors.deepPurpleAccent,
                          color: (snapshot.data![index]['Diasvigencia']) >= 90
                              ? Colors.blueAccent
                              : (snapshot.data![index]['Diasvigencia']) >= 60
                                  ? Colors.greenAccent
                                  : (snapshot.data![index]['Diasvigencia']) >=
                                          30
                                      ? Colors.yellowAccent
                                      : Colors.redAccent,

                          indicatorXY: 0.5,
                          padding: const EdgeInsets.all(8),
                          iconStyle: IconStyle(
                              color: Colors.white,
                              //iconData: Icons.access_alarm,
                              iconData:
                                  (snapshot.data![index]['Diasvigencia']) >= 90
                                      ? Icons.alarm_on
                                      : (snapshot.data![index]
                                                  ['Diasvigencia']) >=
                                              60
                                          ? Icons.alarm
                                          : (snapshot.data![index]
                                                      ['Diasvigencia']) >=
                                                  30
                                              ? Icons.access_alarm
                                              : Icons.access_time),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Colors.indigo,
                        ),
                        afterLineStyle: const LineStyle(color: Colors.indigo),
                        /***/
                        endChild: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            //color: Colors.white70,
                            color: (snapshot.data![index]['status'] != null &&
                                    snapshot.data![index]['status'] > 0)
                                ? (snapshot.data![index]['Diasvigencia']) >= 90
                                    ? Colors.blue
                                    : (snapshot.data![index]['Diasvigencia']) >=
                                            60
                                        ? Colors.green
                                        : (snapshot.data![index]
                                                    ['Diasvigencia']) >=
                                                30
                                            ? Colors.yellow
                                            : Colors.red
                                : Colors.black54,

                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 12.0),
                          /***/

                          child: Column(
                            children: [
                              Text(
                                '${snapshot.data![index]['descricao']}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${snapshot.data![index]['categoria']}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    ': Acionado o envio de mensagems. . .  ')));
                                      },
                                      icon: const Icon(Icons.email),
                                      color: Colors.white),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.tiktok),
                                      color: Colors.white),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data![index]['infor']}'
                                        .toString()
                                        .trim(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Faltam ${snapshot.data![index]['Diasvigencia']} dias para o término da vigência que ocorrerá em ${snapshot.data![index]['vigencia']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _refleh,
        tooltip: 'Atualizar',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//===================================================//
class BarradeBotoes extends StatelessWidget {
  const BarradeBotoes({super.key});
//===================================================//
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 50,
      child: ButtonBar(alignment: MainAxisAlignment.start, children: [
        TextButton(
            child: const Text('Confirmar'),
            onPressed: () {
              "";
            }),
        TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              "";
            }),
        TextButton(
            child: const Text('Reprogramar'),
            onPressed: () {
              "";
            }),
      ]),
    );
  }
}

class BotoesAcao extends StatelessWidget {
  const BotoesAcao({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(': Acionado o envio de mensagems. . .  ')));
              },
              icon: const Icon(Icons.email),
              color: Colors.white),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tiktok),
              color: Colors.white),
        ]);
  }
}



/*

return Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.indigo,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        ': Faltam ${snapshot.data![index]['Diasvigencia']} dias para o término da vigência que ocorrerá em ${snapshot.data![index]['vigencia']}     ')));
                              },
                              icon: const Icon(Icons.access_alarm),
                              color: Colors.black),
                        ]),
                        title: Text(
                          snapshot.data![index]['descricao'],
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          snapshot.data![index]['categoria'],
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        ': ${snapshot.data![index]['infor']}')));
                              },
                              icon: const Icon(Icons.info),
                              color: Colors.white),
                        ]),
                      ),
                      //--------------------------------------------------
/*                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Ações devem ser tomadas. ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
*/
                      //--------------------------------------------------
                      //const BarradeBotoes()
                    ],
                  ),
                );
              },
*/
