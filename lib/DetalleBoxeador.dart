import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Importa el paquete http
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

class DetalleBoxeador extends StatefulWidget {
 // final Map<String, dynamic> boxeador;
  final Boxeo boxeo;

  const DetalleBoxeador({Key? key, required this.boxeo}) : super(key: key);

  @override
  State<DetalleBoxeador> createState() => _DetalleBoxeadorState();
}

class _DetalleBoxeadorState extends State<DetalleBoxeador> {
  int _score = 0; // Inicializado en 0, se actualizará con el valor de la API

@override
  void initState() {
    super.initState();
    // Llama a la función para cargar el puntaje del boxeador desde la API
    cargarPuntajeBoxeador();
  }


  // Función para obtener el puntaje del boxeador desde la API
Future<void> cargarPuntajeBoxeador() async {
  List<dynamic> data = await Boxeo.obtenerDatosBoxeoApi();

  if (data.isNotEmpty) {
    setState(() {
      _score = int.parse(data[0]["score"].toString());
    });
    print('Boxeador ENCONTRADO en la API');
  } else {
    print('Boxeador no encontrado en la API');
  }
}
  
//MODAL SCORE MENOR A 5
Future<void> _mostrarModal() async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¡ES MUCHO MEJOR QUE UN 5!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boxeo.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila: Imagen del boxeador y detalles
            Row(
              children: [
                // Izquierda: Imagen del boxeador
                Image.network(
                  widget.boxeo.imageUrl ?? "",
                  width: 250,
                  height: 250,
                ),
                const SizedBox(width: 20),
                // Derecha: Detalles del boxeador
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Edad: ${widget.boxeo.edad}", style: const TextStyle(fontSize: 15),),
                      Text("Victorias: ${widget.boxeo.victorias}", style: const TextStyle(fontSize: 15),),
                      Text("Derrotas: ${widget.boxeo.derrotas}", style: const TextStyle(fontSize: 15),),
                      Text("Descripción: ${widget.boxeo.descripcion}", style: const TextStyle(fontSize: 15),),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Centrado: Score, Slider y Botón
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Puntuación: ${_score.toInt()}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Slider(
                  min: 0,
                  max: 10,
                  value: _score.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _score = value.round();
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                  // Actualiza la puntuación en la API utilizando una solicitud PUT
                  await http.put(
                    Uri.https('654e8160cbc325355742eca0.mockapi.io', '/api/boxeo/boxeo/${widget.boxeo.apiname}'),
                    body: {
                      "score": _score.toString(),
                    },
                  );

                  // Muestra un mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Puntuación actualizada con éxito'),
                    ),
                  );
                  },
                  child: const Text("Guardar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
