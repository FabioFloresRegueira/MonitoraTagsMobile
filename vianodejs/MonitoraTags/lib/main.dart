import 'dart:convert';
import 'package:flutter/material.dart';
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
      appBar: appBarMain(widget.title),
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

              Center(
                child: Row(
                  children: <Widget>[
                    Row(
                      children: [
                        //Spacer(),
                        /*
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors
                                .black, // Muda a cor do texto para vermelho
                            fontSize: 14, // Muda o tamanho do texto para 20
                          ),
                        ),
                        */
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

      /*
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _refleh,
          label: const Text('Atualizar'),
          icon: const Icon(Icons.refresh)),
      */

      floatingActionButton: true
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Atualizar',
              child: const Icon(Icons.refresh))
          // ignore: dead_code
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const AppBarBottom(
        fabLocation: FloatingActionButtonLocation.endDocked,
        // ignore: dead_code
        shape: true ? CircularNotchedRectangle() : null,
      ),
    );
  }
}

enum Calendar { todos, dias0a30, dias31a60, dias61a90, diasmaior90, inativos }

class SingleChoice extends StatefulWidget {
  const SingleChoice({super.key});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  Calendar calendarView = Calendar.todos;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Calendar>(
      segments: const <ButtonSegment<Calendar>>[
        ButtonSegment<Calendar>(
            value: Calendar.todos,
            //label: Text('Todos'),
            tooltip: 'Todos os Ativos',
            icon: Icon(Icons.filter, color: Colors.black)),
        ButtonSegment<Calendar>(
            value: Calendar.dias0a30,
            //label: Text('30'),
            tooltip: '0 a 30 Dias',
            icon: Icon(
              Icons.filter_1,
              color: Colors.red,
            )),
        ButtonSegment<Calendar>(
            value: Calendar.dias31a60,
            //label: Text('60'),
            tooltip: '31 a 60 Dias',
            icon: Icon(
              Icons.filter_2,
              color: Colors.yellow,
            )),
        ButtonSegment<Calendar>(
            value: Calendar.dias61a90,
            //label: Text('90'),
            tooltip: '60 a 90 Dias',
            icon: Icon(
              Icons.filter_3,
              color: Colors.green,
            )),
        ButtonSegment<Calendar>(
            value: Calendar.diasmaior90,
            //label: Text('Maior'),
            tooltip: 'Maior que 90 Dias',
            icon: Icon(
              Icons.filter_4,
              color: Colors.blue,
            )),
        ButtonSegment<Calendar>(
            value: Calendar.inativos,
            //label: Text('Inativo'),

            tooltip: 'Todos os Inativos',
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            )),
      ],
      selected: <Calendar>{calendarView},
      onSelectionChanged: (Set<Calendar> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          calendarView = newSelection.first;
        });
      },
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
            IconButton(
              tooltip: 'Menu Lateral',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Filtro',
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                const ModalFiltro();
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum AnimationStyles { defaultStyle, custom, none }

const List<(AnimationStyles, String)> animationStyleSegments =
    <(AnimationStyles, String)>[
  (AnimationStyles.defaultStyle, 'Default'),
  (AnimationStyles.custom, 'Custom'),
  (AnimationStyles.none, 'None'),
];

class ModalFiltro extends StatefulWidget {
  const ModalFiltro({super.key});

  @override
  State<ModalFiltro> createState() => _ModalFiltroState();
}

class _ModalFiltroState extends State<ModalFiltro> {
  Set<AnimationStyles> _animationStyleSelection = <AnimationStyles>{
    AnimationStyles.defaultStyle
  };

  AnimationStyle? _animationStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SegmentedButton<AnimationStyles>(
            selected: _animationStyleSelection,
            onSelectionChanged: (Set<AnimationStyles> styles) {
              setState(() {
                _animationStyle = switch (styles.first) {
                  AnimationStyles.defaultStyle => null,
                  AnimationStyles.custom => AnimationStyle(
                      duration: const Duration(seconds: 3),
                      reverseDuration: const Duration(seconds: 1),
                    ),
                  AnimationStyles.none => AnimationStyle.noAnimation,
                };
                _animationStyleSelection = styles;
              });
            },
            segments: animationStyleSegments
                .map<ButtonSegment<AnimationStyles>>(
                    ((AnimationStyles, String) shirt) {
              return ButtonSegment<AnimationStyles>(
                  value: shirt.$1, label: Text(shirt.$2));
            }).toList(),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('showModalBottomSheet'),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                sheetAnimationStyle: _animationStyle,
                builder: (BuildContext context) {
                  return SizedBox.expand(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal bottom sheet'),
                          ElevatedButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

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
                return Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white70,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.arrow_drop_down_circle,
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
                        title:
                            Text(snapshot.data![index]['descricao'].toString(),
                                style: const TextStyle(
                                    //color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          snapshot.data![index]['categoria'].toString(),
                          //style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        trailing: SizedBox(
                          width: 80,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
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
                      //Image.asset('assets/card-sample-image.jpg'),
                      //Image.asset('assets/card-sample-image-2.jpg'),
                    ],
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
