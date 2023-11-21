import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'DetalleBoxeador.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Load JSON',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _boxeadores = [];

  Future<void> obtenerDatosBoxeo() async {
    List<dynamic> data = await Boxeo.obtenerDatosBoxeoApi();

    if (data.isNotEmpty) {
      setState(() {
        _boxeadores = data;
      });
    } else {
      print('Error al obtener datos de la API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Carlos Farres S2AM 23-24',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgregarBoxeador(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://media.istockphoto.com/id/467020352/es/v%C3%ADdeo/boxers-corner.jpg?s=640x640&k=20&c=1tc_47f7KQOkWgG1RCWGDUX7d4t2JLWUALdbubXb9xM='),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: obtenerDatosBoxeo,
                child: const Text('Cargar Datos'),
              ),
              _boxeadores.isNotEmpty
                  ? Flexible(
                      child: ListView.builder(
                        itemCount: _boxeadores.length,
                        itemBuilder: (context, index) {
                          return Container(
                            key: ValueKey(_boxeadores[index]["name"]),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 158, 192, 223),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: 70,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleBoxeador(
                                        boxeo: Boxeo.fromJson(
                                            _boxeadores[index])),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          _boxeadores[index]["img"],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _boxeadores[index]["name"],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

//AGREGAR BOXEADOR
class AgregarBoxeador extends StatelessWidget {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _victoriasController = TextEditingController();
  final TextEditingController _derrotasController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  Future<void> _agregarBoxeador() async {
    final response = await http.post(
      Uri.https('654e8160cbc325355742eca0.mockapi.io', '/api/boxeo/boxeo'),
      body: {
        "name": _nombreController.text,
        "descripcion": _descripcionController.text,
        "img": _imgController.text,
        "edad": _edadController.text,
        "victorias": _victoriasController.text,
        "derrotas": _derrotasController.text,
        "score": _scoreController.text,
      },
    );

    if (response.statusCode == 201) {
      print("Boxeador agregado con éxito");
    } else {
      print("Error al agregar el boxeador");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Boxeador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripcion'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imgController,
              decoration: const InputDecoration(labelText: 'Imagen'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _victoriasController,
              decoration: const InputDecoration(labelText: 'Victorias'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _derrotasController,
              decoration: const InputDecoration(labelText: 'Derrotas'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(labelText: 'Score'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _agregarBoxeador(); // Primero realiza la acción deseada
                Navigator.pop(context, true); // Luego vuelve a la pantalla anterior
              },
              child: const Text('Añadir'),
            ),
          ],
        ),
      ),
    );
  }
}
