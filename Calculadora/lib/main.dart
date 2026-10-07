import 'package:flutter/material.dart';

void main() {
  runApp(const MiCalculadora());
}

class MiCalculadora extends StatelessWidget {
  const MiCalculadora({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String display = '0';
  String operacion = '';

  double? numeroAnterior;
  String? operador;
  bool nuevoNumero = true;

  void presionarNumero(String numero) {
    setState(() {
      if (nuevoNumero) {
        display = numero;
        nuevoNumero = false;
      } else {
        if (display == '0') {
          display = numero;
        } else {
          display += numero;
        }
      }
    });
  }

  void presionarPunto() {
    setState(() {
      if (nuevoNumero) {
        display = '0.';
        nuevoNumero = false;
      } else if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void presionarOperador(String op) {
    setState(() {
      numeroAnterior = double.tryParse(display);
      operador = op;

      operacion = '$display $op';

      nuevoNumero = true;
    });
  }

  void calcular() {
    if (numeroAnterior == null || operador == null) return;

    double numeroActual = double.tryParse(display) ?? 0;
    double resultado = 0;

    setState(() {
      operacion = '$numeroAnterior $operador $numeroActual';
    });

    switch (operador) {
      case '+':
        resultado = numeroAnterior! + numeroActual;
        break;

      case '-':
        resultado = numeroAnterior! - numeroActual;
        break;

      case '×':
        resultado = numeroAnterior! * numeroActual;
        break;

      case '÷':
        if (numeroActual == 0) {
          setState(() {
            display = 'Error';
            nuevoNumero = true;
          });
          return;
        }

        resultado = numeroAnterior! / numeroActual;
        break;
    }

    setState(() {
      if (resultado == resultado.toInt()) {
        display = resultado.toInt().toString();
      } else {
        display = resultado.toStringAsFixed(2);
      }

      numeroAnterior = null;
      operador = null;
      nuevoNumero = true;
    });
  }

  void limpiar() {
    setState(() {
      display = '0';
      operacion = '';
      numeroAnterior = null;
      operador = null;
      nuevoNumero = true;
    });
  }

  Color colorResultado() {
    if (display == 'Error') {
      return Colors.red;
    }

    double valor = double.tryParse(display) ?? 0;

    if (valor > 0) {
      return Colors.blue;
    }

    if (valor < 0) {
      return Colors.red;
    }

    return Colors.grey;
  }

  Widget boton(
    String texto, {
    Color? color,
    Color? textoColor,
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.white,
          foregroundColor: textoColor ?? Colors.black87,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        title: const Text(
          'Calculadora',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          // DISPLAY
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  // Operación
                  Text(
                    operacion,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Resultado
                  Text(
                    display,
                    style: TextStyle(
                      fontSize: 58,
                      fontWeight: FontWeight.bold,
                      color: colorResultado(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTONES
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.15,
                children: [

                  boton(
                    'C',
                    color: Colors.red.shade400,
                    textoColor: Colors.white,
                    onPressed: limpiar,
                  ),

                  boton(
                    '÷',
                    color: Colors.orange.shade400,
                    textoColor: Colors.white,
                    onPressed: () => presionarOperador('÷'),
                  ),

                  boton(
                    '×',
                    color: Colors.orange.shade400,
                    textoColor: Colors.white,
                    onPressed: () => presionarOperador('×'),
                  ),

                  boton(
                    '-',
                    color: Colors.orange.shade400,
                    textoColor: Colors.white,
                    onPressed: () => presionarOperador('-'),
                  ),

                  boton('7', onPressed: () => presionarNumero('7')),
                  boton('8', onPressed: () => presionarNumero('8')),
                  boton('9', onPressed: () => presionarNumero('9')),

                  boton(
                    '+',
                    color: Colors.orange.shade400,
                    textoColor: Colors.white,
                    onPressed: () => presionarOperador('+'),
                  ),

                  boton('4', onPressed: () => presionarNumero('4')),
                  boton('5', onPressed: () => presionarNumero('5')),
                  boton('6', onPressed: () => presionarNumero('6')),

                  boton(
                    '=',
                    color: Colors.green.shade500,
                    textoColor: Colors.white,
                    onPressed: calcular,
                  ),

                  boton('1', onPressed: () => presionarNumero('1')),
                  boton('2', onPressed: () => presionarNumero('2')),
                  boton('3', onPressed: () => presionarNumero('3')),

                  boton(
                    '.',
                    onPressed: presionarPunto,
                  ),

                  boton('0', onPressed: () => presionarNumero('0')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}