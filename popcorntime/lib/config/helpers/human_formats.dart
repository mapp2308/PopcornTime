// Clase que proporciona formatos de visualización para números de forma más legible para los humanos.
// Utiliza la biblioteca intl para dar formato a los números en una representación compacta de moneda.

import 'package:intl/intl.dart';

class HumanFormats {

  // Método estático que formatea un número en una representación compacta de moneda.
  // El parámetro `number` es el número que se va a formatear.
  // El parámetro `decimals` especifica la cantidad de decimales (por defecto es 0).
  static String number(double number, [int decimals = 0]) {

    // Usa la clase NumberFormat de la biblioteca intl para formatear el número en formato de moneda.
    // `compactCurrency` permite mostrar el número de manera más compacta, sin el símbolo de la moneda.
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals, // Establece la cantidad de decimales.
      symbol: '', // No muestra el símbolo de la moneda.
      locale: 'en' // Establece el idioma del formato (en este caso, inglés).
    ).format(number);

    // Retorna el número formateado.
    return formattedNumber;
  }

}
