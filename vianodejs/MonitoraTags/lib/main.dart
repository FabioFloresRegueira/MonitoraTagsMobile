import 'dart:convert';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';

Future<List<dynamic>> fetchBD(String metodo) async {
  //await http.get(Uri.parse('http://localhost:3001/monitorar/api/tags'));
  final xUrl = 'http://192.168.0.85:3001/monitorar/api/tags/$metodo';

  final response = await http.get(Uri.parse(xUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Falha ao carregar as Tags de monitoramento de serviços. url invalida: $xUrl');
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          //brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tags de Monitoramento de Vigencias'),
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
  void _reflesh() {
    setState(() {
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(widget.title),
      drawer: const MNULateral(),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: Image.asset(
                    '../assets/logoTCR.jpg',
                    fit: BoxFit.contain,
                    height: 64,
                    opacity: const AlwaysStoppedAnimation(.5),
                  ),
                ),
              ]),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0),
                child: Divider(),
              ),
              */
              //
              Center(
                child: Row(
                  children: <Widget>[
                    Row(
                      children: [
                        SingleChoice(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
              //
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0),
                child: Divider(),
              ),
              //
              Expanded(
                child: Futuresync(
                  xfiltro: 'ativos',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBarBottom(
        fabLocation: FloatingActionButtonLocation.endDocked,
        // ignore: dead_code
        shape: true ? CircularNotchedRectangle() : null,
      ),
    );
  }
}

/* ********************************************* */
// APBAR
/* ********************************************* */
PreferredSizeWidget appBarMain(String title) {
  return AppBar(
    backgroundColor: Colors.deepPurple[400],
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Muda a cor do texto para vermelho
            fontSize: 18, // Muda o tamanho do texto para 20
          ),
        ),
      ],
    ),
  );
}

/* *****************************************
Drawer - Manu Lateral
****************************************** */
class MNULateral extends StatelessWidget {
  const MNULateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset('assets/taglogo.jpg'),
          ),
          accountName: const Text('Tags de Serviços'),
          accountEmail: const Text('monitoramento@tags.com.br'),

          /*
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/lista-de-servicos.appspot.com/o/img-LstServi%C3%A7os.png?alt=media&token=bc36509e-7354-494c-9d80-7c41ad7b07f0'),
            ),
          ),
          */
        ),
        ListTile(
            leading: const Icon(
              Icons.engineering,
              size: 20,
            ),
            title: const Text('Parametrizar HostName'),
            //subtitle: Text('Finalizar Seção'),
            onTap: () {}),
        const Divider(),
        ListTile(
            leading: const Icon(
              Icons.help_outline,
              size: 20,
            ),
            title: const Text('Ajuda'),
            //subtitle: Text('Finalizar Seção'),
            onTap: () {}),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            size: 20,
          ),

          title: const Text('Sair'),
          //subtitle: Text('Finalizar Seção'),
          onTap: () => {},
        ),
      ],
    ));
  }
}

/* ********************************************* */
// fILTRO
/* ********************************************* */
enum Opcoes {
  ativos,
  vigencia0a30,
  vigencia31a60,
  vigencia61a90,
  vigenciamaior90,
  inativos
}

class SingleChoice extends StatefulWidget {
  const SingleChoice({super.key});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  Opcoes opcoesView = Opcoes.ativos;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Opcoes>(
      segments: const <ButtonSegment<Opcoes>>[
        ButtonSegment<Opcoes>(
            value: Opcoes.ativos,
            //label: Text('Todos'),
            tooltip: 'Todos os Ativos',
            icon: Icon(Icons.filter, color: Colors.black)),
        ButtonSegment<Opcoes>(
            value: Opcoes.vigencia0a30,
            //label: Text('30'),
            tooltip: '0 a 30 Dias',
            icon: Icon(
              Icons.filter_1,
              color: Colors.red,
            )),
        ButtonSegment<Opcoes>(
            value: Opcoes.vigencia31a60,
            //label: Text('60'),
            tooltip: '31 a 60 Dias',
            icon: Icon(
              Icons.filter_2,
              color: Colors.yellow,
            )),
        ButtonSegment<Opcoes>(
            value: Opcoes.vigencia61a90,
            //label: Text('90'),
            tooltip: '60 a 90 Dias',
            icon: Icon(
              Icons.filter_3,
              color: Colors.green,
            )),
        ButtonSegment<Opcoes>(
            value: Opcoes.vigenciamaior90,
            //label: Text('Maior'),
            tooltip: 'Maior que 90 Dias',
            icon: Icon(
              Icons.filter_4,
              color: Colors.blue,
            )),
        ButtonSegment<Opcoes>(
            value: Opcoes.inativos,
            //label: Text('Inativo'),

            tooltip: 'Todos os Inativos',
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            )),
      ],
      selected: <Opcoes>{opcoesView},
      onSelectionChanged: (Set<Opcoes> newSelection) {
        setState(() {
          //Por padrão, há apenas um único segmento que pode ser
          //selecionado de uma só vez, por isso seu valor é sempre o primeiro
          //no conjunto selecionado.
          opcoesView = newSelection.first;
        });
      },
    );
  }
}

/* ********************************************* */
// TAGs DE SERVIÇOS
/* ********************************************* */
class Futuresync extends StatelessWidget {
  const Futuresync({super.key, required this.xfiltro});

  final String xfiltro;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchBD(xfiltro),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Erro: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          leading: IconButton(
                            //Icons.arrow_drop_down_circle,
                            icon: const Icon(Icons.info_outline_rounded),
                            onPressed: () {
                              showAlertDialog1(
                                  context,
                                  snapshot.data![index]['infor'].toString(),
                                  snapshot.data![index]['vigencia'].toString());
                            },
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
                          ),
                          title: Text(
                              snapshot.data![index]['descricao'].toString(),
                              style: const TextStyle(
                                  //color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            snapshot.data![index]['categoria'].toString(),
                            //style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          trailing: SizedBox(
                            width: 70,
                            height: 50,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data![index]['Diasvigencia']
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors
                                          .black, // Muda a cor do texto para vermelho
                                      fontSize:
                                          20, // Muda o tamanho do texto para 20
                                    ),
                                  ),
                                  const Text(
                                    'Dias',
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Muda a cor do texto para vermelho
                                      fontSize:
                                          10, // Muda o tamanho do texto para 20
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /*
                        
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Vigencia: ${snapshot.data![index]['vigencia'].toString()}',
                            //style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            snapshot.data![index]['infor'].toString(),
                            //style:TextStyle(color: Colors.black.withOpacity(0.6)),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        
                        */

                        /*
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 50.0),
                          child: Divider(
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
                          ),
                        ),
                        */

                        //Image.asset('assets/card-sample-image.jpg'),
                        //Image.asset('assets/card-sample-image-2.jpg'),
                      ],
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

showAlertDialog1(BuildContext context, String infor, String vigencia) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alerta = AlertDialog(
    backgroundColor: Colors.white,
    title: Text(
        'Atenção !, a data final para renovação é ${vigencia.substring(0, 10)}'),
    titleTextStyle: const TextStyle(fontSize: 20, color: Colors.redAccent),
    content: Text(infor),
    contentTextStyle: const TextStyle(fontSize: 15, color: Colors.black),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

/* ********************************************* */
// Bottom APBAR
/* ********************************************* */
class AppBarBottom extends StatelessWidget {
  const AppBarBottom({
    super.key,
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.deepPurple[400],
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Atualizar dados',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                //fetchBD(Opcoes.inativos.toString());
              },
            ),
            IconButton(
              tooltip: 'Menu Lateral',
              icon: const Icon(Icons.filter_alt_off_outlined),
              onPressed: () {
                _configurandoModalBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ********************************************* */
// Bottom Modal Sheet
/* ********************************************* */
void _configurandoModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Músicas'),
                onTap: () => {}),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Videos'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.satellite),
              title: const Text('Tempo'),
              onTap: () => {},
            ),
          ],
        );
      });
}
