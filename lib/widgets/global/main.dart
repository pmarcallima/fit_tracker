import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { return MaterialApp( title: 'Flutter Demo', theme: ThemeData( // This is the theme of your application. TRY THIS: Try running your application with "flutter run". You'll see the application has a purple toolbar. Then, without quitting the app, try changing the seedColor in the colorScheme below to Colors.green and then invoke "hot reload" (save your changes or press the "hot reload" button in a Flutter-supported IDE, or press "r" if you used the command line to start the app). Notice that the counter didn't reset back to zero; the application state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        scaffoldBackgroundColor: Color(0xffCF0A0A),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: screenSize.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Texto centralizado
              Text.rich(
                TextSpan(
                  text: 'FitTracker', // texto padrão
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '\nDesafie amigos, \nalcance metas e ganhem juntos!',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Espaço entre o texto e os botões
              Form(
                
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                         TextFormField(
                          decoration: InputDecoration(
                            iconColor: Color(0xffEEEEEE),
                            fillColor: Color(0xffEEEEEE),
                            filled: true,
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
              SizedBox(height: 15), // Espaço entre o texto e os botões
                         TextFormField(
                          decoration: InputDecoration(
                            iconColor: Color(0xffDC5F00),
                            fillColor: Color(0xffEEEEEE),
                            filled: true,
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                  ],
                ),
                ),
              ),
              SizedBox(height: 20), // Espaço entre o texto e os botões
              Column(
                mainAxisSize: MainAxisSize.min, // Ajusta o tamanho dos botões
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Defina o que acontece quando o botão é pressionado
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text('Fazer login'),
                  ),
                  SizedBox(height: 8.0), // Espaço entre os botões
                  ElevatedButton(
                    onPressed: () {
                      // Defina o que acontece quando o botão é pressionado
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color(0xff363636),
                      foregroundColor: Colors.white,
            
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text('Criar uma conta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
