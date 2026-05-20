import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['es', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? esText = '',
    String? enText = '',
  }) =>
      [esText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // CrearCuenta
  {
    'het11y23': {
      'es': 'Atrás',
      'en': 'Regresar',
    },
    'ov0ot4ta': {
      'es': 'Crear cuenta',
      'en': 'Create Account',
    },
    'k90ilmts': {
      'es': 'Introducir los siguientes datos para tener acceso a la app',
      'en': 'Enter the following information to access the app',
    },
    '3iv4w74m': {
      'es': 'Su email...',
      'en': 'Your email...',
    },
    '7qfkyqyi': {
      'es': 'Ingresar su email...',
      'en': 'Enter your email...',
    },
    'oxap95s4': {
      'es': 'Contraseña',
      'en': 'Password',
    },
    '8i1n0q3k': {
      'es': 'Crear su contraseña...',
      'en': 'Create your password...',
    },
    'qpihcv9r': {
      'es': 'Confirmar contraseña',
      'en': 'Confirm Password',
    },
    'vsojondh': {
      'es': 'Confirmar contraseña creada...',
      'en': 'Confirm password created...',
    },
    '5bbpg07z': {
      'es': 'Crear cuenta',
      'en': 'Create Account',
    },
    '2k73rd1y': {
      'es': 'Introducir los siguientes datos para tener acceso al sistema',
      'en': 'Enter the following information to access the app',
    },
    'ffck6v44': {
      'es': 'Su email...',
      'en': 'Your email...',
    },
    'p2hmf3hr': {
      'es': 'Ingresar su email...',
      'en': 'Enter your email...',
    },
    'vqiocunq': {
      'es': 'Contraseña',
      'en': 'Password',
    },
    'wdnp8bwm': {
      'es': 'Crear su contraseña...',
      'en': 'Create your password...',
    },
    '5ir96mfj': {
      'es': 'Confirmar contraseña',
      'en': 'Confirm Password',
    },
    'utczpfm5': {
      'es': 'Confirmar contraseña creada...',
      'en': 'Confirm password created...',
    },
    '254wtjhq': {
      'es': 'Nombre de Usuario',
      'en': 'Confirm Password',
    },
    '9n851v6k': {
      'es': 'Nombre de Usuario',
      'en': 'Confirm password created...',
    },
    'twgwm4aq': {
      'es': 'Celular',
      'en': 'Confirm Password',
    },
    'favn11p7': {
      'es': 'Celular',
      'en': 'Confirm password created...',
    },
    'dbw2omq1': {
      'es': 'Elegir responsable',
      'en': '',
    },
    'ea9dvaas': {
      'es': '',
      'en': '',
    },
    'wccai1kx': {
      'es': 'Seleccionar responsable',
      'en': 'Title',
    },
    'pe971i4h': {
      'es': 'Search...',
      'en': '',
    },
    'v2w6hdye': {
      'es': 'REPOSICION',
      'en': '',
    },
    '8jgxph61': {
      'es': 'TRANSFERENCIA',
      'en': '',
    },
    '0q2vg7t0': {
      'es': 'ALTA',
      'en': '',
    },
    'f38gaud7': {
      'es': 'BAJA',
      'en': '',
    },
    'm53yk9eo': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    '2vt1j33k': {
      'es': 'Elegir permiso',
      'en': '',
    },
    'qnymj7fi': {
      'es': '',
      'en': '',
    },
    'ravqc9mg': {
      'es': 'Seleccionar permiso',
      'en': '',
    },
    'gpscseo9': {
      'es': 'Search...',
      'en': '',
    },
    '996xfqyw': {
      'es': 'Administrador',
      'en': '',
    },
    'h2rx8cj3': {
      'es': 'Bodega',
      'en': '',
    },
    '7cgldfna': {
      'es': 'Editor',
      'en': '',
    },
    '2fdp4gxy': {
      'es': 'Lectura',
      'en': '',
    },
    'jaifjobe': {
      'es': 'Crear cuenta de usuario',
      'en': 'Create Account',
    },
    'gv52lsc2': {
      'es': 'Home',
      'en': 'home',
    },
  },
  // UbicaLugar
  {
    's2lieymo': {
      'es': 'Escribir dirección',
      'en': '',
    },
    'gojhutio': {
      'es': 'Seleccionar',
      'en': '',
    },
    '16t023fh': {
      'es': 'UBICAR LUGAR',
      'en': '',
    },
    'krw2sm3z': {
      'es': 'Home',
      'en': '',
    },
  },
  // InfraccionesMotos
  {
    '7dmj2240': {
      'es': 'Infracciones',
      'en': 'Welcome',
    },
    '0e4ynq0f': {
      'es': 'Seleccionar tipo de infracción',
      'en': '',
    },
    '3ny933qs': {
      'es': 'Clave: ',
      'en': '',
    },
    '6767du4h': {
      'es': 'Tipo: ',
      'en': '',
    },
    '2xqcbc47': {
      'es': 'Infracciones',
      'en': 'Home',
    },
  },
  // Parametros1
  {
    'x9wvvg4u': {
      'es': 'Detalles Infracción',
      'en': '',
    },
    'l3uvomfv': {
      'es': 'FOLIO MULTA:',
      'en': 'Featured from this place:',
    },
    't9402cze': {
      'es': 'NOMBRE DEL OFICIAL:',
      'en': 'Featured from this place:',
    },
    'eo394dqu': {
      'es': 'NOMBRE DEL INFRACTOR:',
      'en': 'Featured from this place:',
    },
    '4tu0a1yg': {
      'es': 'Descripción Infracción',
      'en': '',
    },
    'hw133sk5': {
      'es': 'COSTO MULTA MXN:',
      'en': 'Featured from this place:',
    },
    't7icbrij': {
      'es': 'Escanear  Documentos para pago',
      'en': '',
    },
    'nibjb3nl': {
      'es': 'Pagar y generar comprobante',
      'en': '',
    },
    '0dhllaxm': {
      'es': 'Recomendar',
      'en': 'Recommend',
    },
  },
  // InfraccionesBusqueda
  {
    'o1xfsmms': {
      'es': 'Infracciones',
      'en': 'Welcome',
    },
    '6earf1cq': {
      'es': 'Infracción por Código',
      'en': '',
    },
    '6e0bs3va': {
      'es': 'Clave: ',
      'en': '',
    },
    '7sj6loiz': {
      'es': 'Tipo: ',
      'en': '',
    },
    'ru9p9rky': {
      'es': 'Infracciones',
      'en': 'Home',
    },
  },
  // EditarDatosPersonales
  {
    'p5t1lgb0': {
      'es': 'Datos Personales',
      'en': 'Create start news',
    },
    'xtysurqb': {
      'es': 'Nombre Oficial',
      'en': 'Title',
    },
    '9no8emhh': {
      'es': 'Nombre completo Oficial',
      'en': 'Post Title',
    },
    'oxbe8z5d': {
      'es': 'Telefono',
      'en': 'Description',
    },
    'vkt6umgi': {
      'es': '10 Dígitos llamadas',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'ytakg3m1': {
      'es': 'WhatsApp',
      'en': 'Description',
    },
    'aubf1lxx': {
      'es': '10 dígitos WhatsApp',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'uqgncvxd': {
      'es': 'Correo',
      'en': 'Description',
    },
    'xzmbhnu4': {
      'es': 'Correo electrónico',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'vju7gyqa': {
      'es': 'Firma del Oficial de Comercio',
      'en': '',
    },
    '61hdxjn0': {
      'es': 'Actualizar Datos',
      'en': 'Save',
    },
    'y1fslpbu': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Activos
  {
    'd60agfek': {
      'es': 'Inicio',
      'en': '',
    },
    'orygccqm': {
      'es': 'Imn. valuados',
      'en': '',
    },
    'o8vhulm7': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'ytokrdg1': {
      'es': 'Activos',
      'en': '',
    },
    'htg43cs3': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    '00wjw3xr': {
      'es': 'Nuevo bien',
      'en': '',
    },
    'kj3yhtn7': {
      'es': 'Descripción',
      'en': '',
    },
    'furgg0sr': {
      'es': 'Fecha de alta',
      'en': '',
    },
    'wnkjasm7': {
      'es': 'Nombre depositario',
      'en': '',
    },
    '12uzy6wt': {
      'es': 'Fecha adquisición',
      'en': '',
    },
    'fwsymqi0': {
      'es': 'No. inventario',
      'en': '',
    },
    'l8sj9u93': {
      'es': 'Origen recurso',
      'en': '',
    },
    'e1zhw1ut': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // ListaComercios
  {
    'rekr2rqd': {
      'es': 'Establecimiento',
      'en': 'Welcome',
    },
    'f0c5u46c': {
      'es': 'Seleccionar Acción',
      'en': '',
    },
    'jugpzbs0': {
      'es': 'Giro',
      'en': '',
    },
    'beh5o0he': {
      'es': 'Identificador: ',
      'en': '',
    },
    'dfq6xa6e': {
      'es': 'Pago',
      'en': '',
    },
    'x66oct00': {
      'es': 'Ver Información',
      'en': '',
    },
    'l2xc7d53': {
      'es': 'Editar Info',
      'en': '',
    },
    '4amw4ojx': {
      'es': 'Editar Foto Principal',
      'en': '',
    },
    'yiamsa08': {
      'es': 'Editar Posición',
      'en': '',
    },
    '39xrh5h3': {
      'es': 'Editar Fotos Complementarias',
      'en': '',
    },
    'wrrhkibb': {
      'es': 'Comercios',
      'en': 'Home',
    },
  },
  // VerComercio
  {
    'ecppvadx': {
      'es': 'Datos del Establecimiento',
      'en': 'Create start news',
    },
    '5mkvtq5o': {
      'es': 'CodigoQR',
      'en': '',
    },
    '6w9dj2gm': {
      'es': '[Some hint text...]',
      'en': '',
    },
    '6umuw19e': {
      'es': 'Nombre Propietario',
      'en': 'Title',
    },
    'wirmp8kt': {
      'es': 'Nombre completo propietario',
      'en': 'Post Title',
    },
    'r2ad4r51': {
      'es': 'Domicilio Particular',
      'en': 'Description',
    },
    '5d1zf706': {
      'es': 'Dirección del propietario',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'obcdj4hc': {
      'es': 'Persona Física o Moral',
      'en': 'Description',
    },
    'ocid9v7i': {
      'es': 'Persona Física o Moral',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'vdjb9klq': {
      'es': 'RFC',
      'en': 'Description',
    },
    '3p4tcqou': {
      'es': 'RFC',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'ukzzzsbj': {
      'es': 'Nacionalidad Propietario',
      'en': 'Description',
    },
    'p6mikrct': {
      'es': 'Nacionalidad',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'brh3ky32': {
      'es': 'Nombre del Establecimiento',
      'en': 'Description',
    },
    '8r2carl5': {
      'es': 'Nombre del Establecimiento',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '7fq7oo4u': {
      'es': 'Domicilio Negocio',
      'en': 'Description',
    },
    '6rau2fmp': {
      'es': 'Dirección del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'gvhmqnr1': {
      'es': 'Colonia Negocio',
      'en': 'Description',
    },
    'ugpvueyu': {
      'es': 'Colonia del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'q0qagga7': {
      'es': 'Número Negocio',
      'en': 'Description',
    },
    '9wsv5dig': {
      'es': 'Número del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'sht2w0r4': {
      'es': 'Tipo Negocio',
      'en': '',
    },
    'niy3imul': {
      'es': 'Diario',
      'en': '',
    },
    'qi6kvkkw': {
      'es': 'Anual',
      'en': '',
    },
    'o2t1u1xr': {
      'es': 'Ruta',
      'en': '',
    },
    '60bj8i25': {
      'es': 'TiendaAbarrotes',
      'en': '',
    },
    'nx1u9x3y': {
      'es': 'Tienda de Ropa',
      'en': '',
    },
    '8jl5zblz': {
      'es': 'Restaurante',
      'en': '',
    },
    'du03ajhd': {
      'es': 'Zapatería',
      'en': '',
    },
    'ck9cxt7g': {
      'es': 'Tienda con bebidas Alcoholicas',
      'en': '',
    },
    '23trng6x': {
      'es': 'Papelería',
      'en': '',
    },
    'sdnq756w': {
      'es': 'Giro',
      'en': 'Description',
    },
    'g36413f3': {
      'es': 'Giro',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '6ce44br4': {
      'es': 'Movimiento',
      'en': 'Description',
    },
    'am66il1d': {
      'es': 'Movimiento',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'xd826rdr': {
      'es': 'PagoAdicional',
      'en': 'Description',
    },
    's83ak5nu': {
      'es': 'Pago Adicional',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '4ddafsb0': {
      'es': 'Ultimo Pago Anual',
      'en': 'Description',
    },
    'a01bcuto': {
      'es': 'Ultimo Pago Anual',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'r3w0nwde': {
      'es': 'Ultimo Pago Diario',
      'en': 'Description',
    },
    'm8pzizf5': {
      'es': 'Ultimo Pago Diario',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'dtjbx8yh': {
      'es': 'Superficie M2',
      'en': 'Description',
    },
    'm9lap03f': {
      'es': 'Superficie en M2',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'cu3urpx7': {
      'es': 'Descripción Actividad Comercial',
      'en': 'Description',
    },
    'wwls2yhm': {
      'es': 'Descripción Actividad Comercial',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '3085snel': {
      'es': 'Fecha Inicio Operaciones',
      'en': 'Description',
    },
    'kyd4ximh': {
      'es': 'Fecha Inicio Operaciones',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '2ye5svm1': {
      'es': 'WhatsApp',
      'en': 'Description',
    },
    'rfcte6ea': {
      'es': '10 dígitos WhatsApp',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '0gosb01o': {
      'es': 'Correo',
      'en': 'Description',
    },
    'r7f343km': {
      'es': 'Correo electrónico',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'uj6n1n2o': {
      'es': 'Foto Principal',
      'en': 'Tap to load image',
    },
    'js74qfpn': {
      'es': 'Elegir fotos complementarias',
      'en': '',
    },
    '1t2yhnie': {
      'es': 'Ver ubicación',
      'en': '',
    },
    'c1fmzzu5': {
      'es': 'Ver comentario',
      'en': '',
    },
    'pfw5ijkh': {
      'es': 'Firma Personal Comercio',
      'en': '',
    },
    '9rkhn0rf': {
      'es': 'Firma Dueño o encargado',
      'en': '',
    },
    '6fik5ye9': {
      'es': 'Regresar',
      'en': 'Save',
    },
    '20rxw3zs': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // PrecioM2
  {
    'ntek9n8s': {
      'es': 'Datos Personales',
      'en': 'Create start news',
    },
    'i6jgxmbk': {
      'es': 'Nombre Oficial',
      'en': 'Title',
    },
    's0vlgxfv': {
      'es': 'Nombre completo Oficial',
      'en': 'Post Title',
    },
    'l694yf3h': {
      'es': 'Telefono',
      'en': 'Description',
    },
    'o2khcnfc': {
      'es': '10 Dígitos llamadas',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '7hbi4iv6': {
      'es': 'WhatsApp',
      'en': 'Description',
    },
    'w2f8bx29': {
      'es': '10 dígitos WhatsApp',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'fqbj913h': {
      'es': 'Correo',
      'en': 'Description',
    },
    '5it3s7oz': {
      'es': 'Correo electrónico',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'cyp27ioj': {
      'es': 'Firma del Oficial de Comercio',
      'en': '',
    },
    'iafzolqn': {
      'es': 'Actualizar Datos',
      'en': 'Save',
    },
    'bdqy8n2j': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Edicion
  {
    'qk8x6umz': {
      'es': 'Establecimiento',
      'en': 'Welcome',
    },
    'uo63rapx': {
      'es': 'Seleccionar Acción',
      'en': '',
    },
    'qemdcxue': {
      'es': 'Giro',
      'en': '',
    },
    'yy9mgk1q': {
      'es': 'QR: ',
      'en': '',
    },
    'k3le97gu': {
      'es': 'Pago',
      'en': '',
    },
    'ufm3kzae': {
      'es': 'Ver Información',
      'en': '',
    },
    'jjt6kl84': {
      'es': 'Editar Info',
      'en': '',
    },
    'aa77byba': {
      'es': 'Editar Foto Principal',
      'en': '',
    },
    'm536xwsq': {
      'es': 'Editar Posición',
      'en': '',
    },
    'kfe2dmw8': {
      'es': 'Editar Fotos Complementarias',
      'en': '',
    },
    'm9lx63k0': {
      'es': 'Eliminar Comercio',
      'en': '',
    },
    '50m1n8rr': {
      'es': 'Comercios',
      'en': 'Home',
    },
  },
  // FormatoComercio
  {
    '11kh9g53': {
      'es': 'Datos del Establecimiento',
      'en': 'Create start news',
    },
    '75r6qac4': {
      'es': 'CodigoQR',
      'en': '',
    },
    'h5emyoco': {
      'es': '[Some hint text...]',
      'en': '',
    },
    'i7oq63lu': {
      'es': 'Nombre Propietario',
      'en': 'Title',
    },
    'jqg5af3g': {
      'es': 'Nombre completo propietario',
      'en': 'Post Title',
    },
    'p8v9na65': {
      'es': 'Domicilio Particular',
      'en': 'Description',
    },
    '4qha83zl': {
      'es': 'Dirección del propietario',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'k8zokjvy': {
      'es': 'Tipo Persona',
      'en': '',
    },
    'nxezbbe0': {
      'es': 'Física',
      'en': '',
    },
    '4k52bck8': {
      'es': 'Moral',
      'en': '',
    },
    '8i4uxmea': {
      'es': 'RFC',
      'en': 'Description',
    },
    'zeq9ot3e': {
      'es': 'RFC',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '7ux5b5nr': {
      'es': 'Nacionalidad Propietario',
      'en': 'Description',
    },
    'q8hgxwnb': {
      'es': 'Nacionalidad',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '0kfr6na5': {
      'es': 'MEXICANO(A)',
      'en': '',
    },
    '5jalx9ph': {
      'es': 'Nombre del Establecimiento',
      'en': 'Description',
    },
    '66uemxlz': {
      'es': 'Nombre del Establecimiento',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'rqnk4zce': {
      'es': 'Domicilio Negocio',
      'en': 'Description',
    },
    'ie72a1zk': {
      'es': 'Dirección del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'i5tsexaf': {
      'es': 'Colonia Negocio',
      'en': 'Description',
    },
    'tr0a8den': {
      'es': 'Colonia del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '3ypcvsqv': {
      'es': 'Número Negocio',
      'en': 'Description',
    },
    'v2jn2sww': {
      'es': 'Número del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'b09kpffz': {
      'es': '',
      'en': '',
    },
    'd2p561p3': {
      'es': 'Tipo Negocio',
      'en': '',
    },
    'h726fnyp': {
      'es': 'TiendaAbarrotes',
      'en': '',
    },
    'vzp9k86o': {
      'es': 'Tienda de Ropa',
      'en': '',
    },
    'sez3c9ic': {
      'es': 'Restaurante',
      'en': '',
    },
    '1aln2umk': {
      'es': 'Zapatería',
      'en': '',
    },
    'g9y0koa0': {
      'es': 'Tienda con bebidas Alcoholicas',
      'en': '',
    },
    'iv38ajht': {
      'es': 'Papelería',
      'en': '',
    },
    'm196t6ws': {
      'es': 'Ninguno',
      'en': '',
    },
    'uvkxs6rd': {
      'es': 'Pago Adicional',
      'en': '',
    },
    'oneykb52': {
      'es': 'Diario',
      'en': '',
    },
    'bpsxt9re': {
      'es': 'Anual',
      'en': '',
    },
    'jojicidf': {
      'es': '',
      'en': '',
    },
    '2frd960w': {
      'es': 'Tipo de Pago',
      'en': '',
    },
    'otut05ug': {
      'es': 'Diario',
      'en': '',
    },
    'hq6z530y': {
      'es': 'Anual',
      'en': '',
    },
    '5uouhdcx': {
      'es': 'Último Pago Anual. Si Paga Diario \nseleccionar fecha actual',
      'en': '',
    },
    '6qcze60c': {
      'es': 'Último Pago',
      'en': '',
    },
    '8rf2ah5q': {
      'es': '',
      'en': '',
    },
    '042zo3p1': {
      'es': 'Ruta',
      'en': '',
    },
    'pgbrtulf': {
      'es': 'TiendaAbarrotes',
      'en': '',
    },
    's242shz4': {
      'es': 'Tienda de Ropa',
      'en': '',
    },
    'ss8fr8r7': {
      'es': 'Restaurante',
      'en': '',
    },
    '5w9rc09q': {
      'es': 'Zapatería',
      'en': '',
    },
    'h9nxwuwb': {
      'es': 'Tienda con bebidas Alcoholicas',
      'en': '',
    },
    'gazll0nt': {
      'es': 'Papelería',
      'en': '',
    },
    'h09hrltn': {
      'es': '',
      'en': '',
    },
    '0sqs142v': {
      'es': 'Movimiento',
      'en': '',
    },
    'v2af3ag1': {
      'es': 'Fijo',
      'en': '',
    },
    'alr31oat': {
      'es': 'Semifijo',
      'en': '',
    },
    'i3xykriz': {
      'es': 'Ambulante',
      'en': '',
    },
    '4ocpwa3k': {
      'es': 'Superficie M2',
      'en': 'Description',
    },
    'cwa92gvu': {
      'es': 'Superficie en M2',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'wmyv6hck': {
      'es': 'Descripción Actividad Comercial',
      'en': 'Description',
    },
    't8drjh0u': {
      'es': 'Descripción Actividad Comercial',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'e736r0sg': {
      'es': 'Fecha Inicio Operaciones',
      'en': 'Description',
    },
    'm8xq1hct': {
      'es': 'Fecha Inicio Operaciones',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'd26322sx': {
      'es': 'WhatsApp',
      'en': 'Description',
    },
    '0e7o3ch8': {
      'es': '10 dígitos WhatsApp',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '6rp1cv56': {
      'es': '0',
      'en': '',
    },
    'unwqxp21': {
      'es': 'Correo',
      'en': 'Description',
    },
    'pypki0g2': {
      'es': 'Correo electrónico',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'az039sqo': {
      'es': 'Foto Principal',
      'en': 'Tap to load image',
    },
    'gmzkromk': {
      'es': 'Elegir fotos complementarias',
      'en': '',
    },
    '1y0lhj2m': {
      'es': 'Seleccionar Imagenes',
      'en': '',
    },
    'l6ea350o': {
      'es': 'Ubicación Establecimiento',
      'en': '',
    },
    'px1z33ro': {
      'es': 'Firma Personal Comercio',
      'en': '',
    },
    'bbtq6ynf': {
      'es': 'Firma Dueño o encargado',
      'en': '',
    },
    '4bvt5qzj': {
      'es': 'Guardar',
      'en': 'Save',
    },
    'q88bleae': {
      'es': 'Agegar Comercio',
      'en': 'Upload news',
    },
  },
  // EditComercio
  {
    'y5rizfm4': {
      'es': 'Datos del Establecimiento',
      'en': 'Create start news',
    },
    'jjw7yr6x': {
      'es': 'CodigoQR',
      'en': '',
    },
    '69jd4o1t': {
      'es': '[Some hint text...]',
      'en': '',
    },
    'x0k9qo35': {
      'es': 'Nombre Propietario',
      'en': 'Title',
    },
    'ktcjg8jt': {
      'es': 'Nombre completo propietario',
      'en': 'Post Title',
    },
    'yeqk4k9h': {
      'es': 'Domicilio Particular',
      'en': 'Description',
    },
    'atog1tyr': {
      'es': 'Dirección del propietario',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'ujsm791l': {
      'es': 'Persona Física o Moral',
      'en': 'Description',
    },
    '0vr1yjv7': {
      'es': 'Persona Física o Moral',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '96bipwyp': {
      'es': 'RFC',
      'en': 'Description',
    },
    'zrrotuey': {
      'es': 'RFC',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'j15xj61y': {
      'es': 'Nacionalidad Propietario',
      'en': 'Description',
    },
    'u2o1p9ef': {
      'es': 'Nacionalidad',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'n1dnj4ly': {
      'es': 'Nombre del Establecimiento',
      'en': 'Description',
    },
    '1oc1idr1': {
      'es': 'Nombre del Establecimiento',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'jpdrwhnq': {
      'es': 'Domicilio Negocio',
      'en': 'Description',
    },
    '7as3fb3e': {
      'es': 'Dirección del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'irsx6kmz': {
      'es': 'Colonia Negocio',
      'en': 'Description',
    },
    'vx69x16g': {
      'es': 'Colonia del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'ueqwyhve': {
      'es': 'Número Negocio',
      'en': 'Description',
    },
    'q8dd6laz': {
      'es': 'Número del Negocio',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'rqdbh770': {
      'es': 'Cambiar fecha anual',
      'en': '',
    },
    'w6q32w5l': {
      'es': 'Tipo Negocio',
      'en': '',
    },
    'xytjkqa2': {
      'es': 'TiendaAbarrotes',
      'en': '',
    },
    '2a00ye3j': {
      'es': 'Tienda de Ropa',
      'en': '',
    },
    '5vvp7qlk': {
      'es': 'Restaurante',
      'en': '',
    },
    'zrf2a6zp': {
      'es': 'Zapatería',
      'en': '',
    },
    'bnv7vkqx': {
      'es': 'Tienda con bebidas Alcoholicas',
      'en': '',
    },
    'utysdxqu': {
      'es': 'Papelería',
      'en': '',
    },
    'p8vlx4kh': {
      'es': 'Tipo Negocio',
      'en': '',
    },
    '8cbrtsps': {
      'es': 'Diario',
      'en': '',
    },
    'm2ufymti': {
      'es': 'Anual',
      'en': '',
    },
    'uavvm6da': {
      'es': 'Tipo Negocio',
      'en': '',
    },
    'nurnnqiw': {
      'es': 'TiendaAbarrotes',
      'en': '',
    },
    'klnyzown': {
      'es': 'Tienda de Ropa',
      'en': '',
    },
    'bfj8qfb8': {
      'es': 'Restaurante',
      'en': '',
    },
    '63lgg3sr': {
      'es': 'Zapatería',
      'en': '',
    },
    'f6kbwmn9': {
      'es': 'Tienda con bebidas Alcoholicas',
      'en': '',
    },
    'c3v4nk36': {
      'es': 'Papelería',
      'en': '',
    },
    'phbmhzse': {
      'es': 'Superficie M2',
      'en': 'Description',
    },
    'ugqh4ah8': {
      'es': 'Superficie en M2',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'mrq718vt': {
      'es': 'Descripción Actividad Comercial',
      'en': 'Description',
    },
    '3wxf4w8y': {
      'es': 'Descripción Actividad Comercial',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'rxdbgaij': {
      'es': 'Fecha Inicio Operaciones',
      'en': 'Description',
    },
    '38ko9dxr': {
      'es': 'Fecha Inicio Operaciones',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'agipmsyx': {
      'es': 'WhatsApp',
      'en': 'Description',
    },
    'r7wrpb4a': {
      'es': '10 dígitos WhatsApp',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'ahi5gt44': {
      'es': 'Correo',
      'en': 'Description',
    },
    'zk9ftqcy': {
      'es': 'Correo electrónico',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'jylo2fon': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    '4a5ekyar': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // CostoM2
  {
    'zjyokgvp': {
      'es': 'Precio M2',
      'en': 'Create start news',
    },
    'hxb9vg38': {
      'es': 'Costo M2',
      'en': 'Title',
    },
    'jbrmwz2p': {
      'es': 'Costo en pesos del M2',
      'en': 'Post Title',
    },
    'ivr4qd48': {
      'es': 'Actualizar Datos',
      'en': 'Save',
    },
    'tzng04i9': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // QRPage
  {
    'qruyw3jh': {
      'es': 'Establecimiento',
      'en': 'Welcome',
    },
    'gjzt9f3x': {
      'es': 'Seleccionar Acción',
      'en': '',
    },
    'e5gskzpl': {
      'es': 'Giro',
      'en': '',
    },
    'v08ci80z': {
      'es': 'Identificador: ',
      'en': '',
    },
    '34eb1ck8': {
      'es': 'Tipo de Pago: ',
      'en': '',
    },
    'ru5tcxmo': {
      'es': 'Último Pago: ',
      'en': '',
    },
    'r4f5l1sr': {
      'es': 'Estado: ',
      'en': '',
    },
    'zssthzsy': {
      'es': 'Costo:',
      'en': '',
    },
    'zt2asflj': {
      'es': 'Costo (\$):',
      'en': '',
    },
    'q2965qg1': {
      'es': 'Pagar Anual',
      'en': '',
    },
    '1kphhmdd': {
      'es': 'Pagar',
      'en': '',
    },
    'ptanmhj3': {
      'es': 'Ver Información',
      'en': '',
    },
    'kpuhbkvo': {
      'es': 'Ir a Edición',
      'en': '',
    },
    'yfofs9w8': {
      'es': 'Ver Comentarios',
      'en': '',
    },
    '4ljrws0g': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    'evtwmwu2': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    'wv91tl7k': {
      'es': 'Infracciones',
      'en': 'Home',
    },
  },
  // ReenviarPassword
  {
    'kszu4qw1': {
      'es': 'Atrás',
      'en': 'Behind',
    },
    'kzc7geef': {
      'es': 'Restablecer',
      'en': 'My account',
    },
    '9zrp3oye': {
      'es': 'Ingresar correo',
      'en': 'Enter created account data',
    },
    't5jeqs30': {
      'es': 'Email',
      'en': 'E-mail',
    },
    'x11kjhtn': {
      'es': 'Escribir email',
      'en': 'write email',
    },
    '0gsmq3i2': {
      'es': 'Ingresar',
      'en': 'Get into',
    },
    'c586kyww': {
      'es': 'Home',
      'en': 'home',
    },
  },
  // CuentaDiario
  {
    'fp5tviet': {
      'es': 'Total Cuenta',
      'en': 'Welcome',
    },
    'ocwwsnoz': {
      'es': 'Total Hoy tipo Diario: ',
      'en': '',
    },
    'uy82w4dv': {
      'es': 'Fecha: ',
      'en': '',
    },
    'litq62j0': {
      'es': 'Total Hoy de tipo Anual: ',
      'en': '',
    },
    'j7iikbr1': {
      'es': 'Fecha: ',
      'en': '',
    },
    'qc5mo9wv': {
      'es': 'Cobrador',
      'en': '',
    },
    'w4974ol2': {
      'es': 'Option 1',
      'en': '',
    },
    '4177fwa6': {
      'es': 'Total Hoy Tipo Diario: ',
      'en': '',
    },
    'vwsc7726': {
      'es': 'Fecha: ',
      'en': '',
    },
    'lyxt2t30': {
      'es': 'Total Hoy de  Tipo Anual: ',
      'en': '',
    },
    'na2j4xfx': {
      'es': 'Fecha: ',
      'en': '',
    },
    'qlh0if5a': {
      'es': 'Total de Negocios Diarios',
      'en': '',
    },
    'gjc5ij02': {
      'es': 'Cobrados hoy:',
      'en': '',
    },
    'smqyvb4i': {
      'es': 'Total de Negocios Anuales',
      'en': '',
    },
    'cbohmgzv': {
      'es': 'Sin adeudo:',
      'en': '',
    },
    'fnncwm3i': {
      'es': 'Generar E-Ticket Diario',
      'en': '',
    },
    '8eelyav6': {
      'es': 'Generar E-Ticket Anual',
      'en': '',
    },
    '0rgazlmz': {
      'es': 'Identificador: ',
      'en': '',
    },
    '75ibsa84': {
      'es': 'último Pago: ',
      'en': '',
    },
    '3282usoi': {
      'es': 'Ver Lugar',
      'en': '',
    },
    'yg31hh71': {
      'es': 'Giro',
      'en': '',
    },
    '4hjlnyst': {
      'es': 'Identificador: ',
      'en': '',
    },
    'iappp9x9': {
      'es': 'Tipo de Pago: ',
      'en': '',
    },
    'gy10j5y9': {
      'es': 'Último Pago: ',
      'en': '',
    },
    '51e195wp': {
      'es': 'Estado: ',
      'en': '',
    },
    'l3apgkyq': {
      'es': 'Ver Información',
      'en': '',
    },
    'eczn1f21': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // EditarUMAS
  {
    'c4h3xzpe': {
      'es': 'UMAS',
      'en': 'Create start news',
    },
    'xya15yuj': {
      'es': 'Año UMA',
      'en': 'Title',
    },
    'wipggiw1': {
      'es': 'Año UMA',
      'en': 'Post Title',
    },
    'u6hpab1r': {
      'es': 'Precio UMA \$',
      'en': 'Description',
    },
    'petm6ygc': {
      'es': 'Precio UMA',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'hhi7w2of': {
      'es': 'Cantidad de UMAS por M2',
      'en': 'Description',
    },
    'd9fiq0lk': {
      'es': 'Cantidad de UMAS por M2',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '0y2emnky': {
      'es': 'Actualizar Datos',
      'en': 'Save',
    },
    'lgmfo0uo': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Vencidos
  {
    'znvte7es': {
      'es': 'Anuales Vencidos',
      'en': 'Welcome',
    },
    'z8qsu6dl': {
      'es': 'Vencidos',
      'en': '',
    },
    'nypqhgux': {
      'es': 'Giro',
      'en': '',
    },
    'jjsivdf8': {
      'es': 'Identificador: ',
      'en': '',
    },
    'h7yvcnf6': {
      'es': 'Tipo de Pago: ',
      'en': '',
    },
    'cc5aqyyw': {
      'es': 'Último Pago: ',
      'en': '',
    },
    '4xmzoa8d': {
      'es': 'Ver en Maps',
      'en': '',
    },
    'z8nw42ou': {
      'es': 'Formato Pago',
      'en': '',
    },
    'czixaqau': {
      'es': 'Estado: ',
      'en': '',
    },
    '7bwshqsl': {
      'es': 'Ver Información',
      'en': '',
    },
    'n6fiqr1i': {
      'es': 'Ver Comentarios',
      'en': '',
    },
    'b45znx4x': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    'ayt4en4i': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    '7snkn2rx': {
      'es': 'Vencidos',
      'en': 'Home',
    },
  },
  // PagosDiarios
  {
    '9cp68gom': {
      'es': 'Pendientes Hoy',
      'en': 'Welcome',
    },
    'ou3knr6w': {
      'es': 'Pendiente de Pagar Hoy',
      'en': '',
    },
    '0mofrr0x': {
      'es': 'Ruta',
      'en': '',
    },
    't59foaym': {
      'es': 'Option 1',
      'en': '',
    },
    'a2fhfaz2': {
      'es': 'Negocios ruta',
      'en': '',
    },
    'v79mbyco': {
      'es': 'Negocios Restantes',
      'en': '',
    },
    '5szpj9a9': {
      'es': 'Ver en Maps',
      'en': '',
    },
    'oblej60f': {
      'es': 'QR: ',
      'en': '',
    },
    'rwi09skk': {
      'es': 'último Pago: ',
      'en': '',
    },
    'trlwbkfs': {
      'es': 'Impresión',
      'en': '',
    },
    'zces00sf': {
      'es': 'Ver Lugar',
      'en': '',
    },
    'bvdfblam': {
      'es': 'Formato Pago',
      'en': '',
    },
    'fqsxod3y': {
      'es': 'Ver Coment.',
      'en': '',
    },
    'zaj2239g': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    '2hizhco9': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    '7oohy2yx': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // ComercioInicio
  {
    'hko3kwfc': {
      'es': 'Correo Usuario:',
      'en': '',
    },
    'ik6oesk3': {
      'es': 'Nombre de Personal:',
      'en': '',
    },
    'ieftimt6': {
      'es': 'Editar Perfil',
      'en': '',
    },
    'g0jj00am': {
      'es': 'Info. Usuarios',
      'en': '',
    },
    'zb1ig8dm': {
      'es': 'Ver Rutas',
      'en': '',
    },
    'ob0ux3r1': {
      'es': 'Ajustar UMA',
      'en': '',
    },
    'ow8t38c4': {
      'es': 'Nuevo Usuario',
      'en': '',
    },
    '3k4gz9un': {
      'es': 'Nueva Ruta',
      'en': '',
    },
    '154lavhh': {
      'es': 'Nuevo Giro',
      'en': '',
    },
    'vwm0jqr1': {
      'es': 'Buscar con QR',
      'en': '',
    },
    'uw1vayvb': {
      'es': 'Buscar Propietario',
      'en': '',
    },
    'uo79ujlv': {
      'es': 'Nuevo comercio',
      'en': '',
    },
    '7kdjjpz4': {
      'es': 'Descargar Comercios',
      'en': '',
    },
    'w9wv5z8w': {
      'es': 'Cerrar Sesión',
      'en': '',
    },
    'flp59suw': {
      'es': 'Comercio Municipal',
      'en': 'Welcome',
    },
    '5kxx2m43': {
      'es': 'Menú Principal Comercio',
      'en': '',
    },
    '9eowxeud': {
      'es': 'Ver pagos',
      'en': '',
    },
    'h7o3y69z': {
      'es': 'Pendientes Diarios',
      'en': '',
    },
    '738yufgb': {
      'es': 'Pendientes Anual',
      'en': '',
    },
    'pvk8bi54': {
      'es': 'Ver comercios por Giro',
      'en': '',
    },
    '2p5wu9k7': {
      'es': 'Cerrar sesión',
      'en': '',
    },
    'se9i1hd1': {
      'es': 'Ir a inicio',
      'en': '',
    },
    'zk3wbxx1': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // CrearBien
  {
    '6jdc0nuo': {
      'es': 'Regresar',
      'en': '',
    },
    'go8isgts': {
      'es': 'Agregar Nuevo Activo',
      'en': '',
    },
    'r8c5rw4e': {
      'es': 'ID',
      'en': '',
    },
    'j14fay33': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'mvmtn73u': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'smgg8530': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'olr3fnjv': {
      'es': 'ID anterior',
      'en': '',
    },
    '8ygl16tx': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    'x7tld0t3': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    'jyst4ayd': {
      'es': 'Número de ID anterior del bien',
      'en': '',
    },
    '7s1s6m6e': {
      'es': 'Importe',
      'en': '',
    },
    '2bqvpxt8': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'jb3bddin': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'jrie5k0v': {
      'es': 'Importe del bien',
      'en': '',
    },
    '5y9a0m9h': {
      'es': 'Avalúo',
      'en': '',
    },
    'duroe6fm': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Title',
    },
    's5kcfmei': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Post Title',
    },
    'f9hz5pvi': {
      'es': 'Importe del avalúo',
      'en': '',
    },
    't5e8flps': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'hdpj7wgq': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'eio4cqe9': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    '9y7xgt2t': {
      'es': 'Option 1',
      'en': '',
    },
    'bnufo4gx': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'gbr32vg0': {
      'es': 'Depositario',
      'en': '',
    },
    'cl88y7cr': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'v2drsf02': {
      'es': 'Nombre del titular',
      'en': 'Post Title',
    },
    'bioi09bm': {
      'es': 'SIN DEPOSITARIO INICIAL',
      'en': '',
    },
    '1yl7zc35': {
      'es': 'Option 1',
      'en': '',
    },
    'nziqsnrv': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'vroencqv': {
      'es': 'Usuario del Bien',
      'en': '',
    },
    'whbw5xw4': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'wla2thhk': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'y5tfrx5s': {
      'es': 'SIN USUARIO INICIAL',
      'en': '',
    },
    '3udzy4yf': {
      'es': 'Option 1',
      'en': '',
    },
    'fw6cizay': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    '4q2vtvu3': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'q4p0jlmh': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'rsgg3kf1': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    '3w3rr17u': {
      'es': 'Option 1',
      'en': '',
    },
    'r19s8dvr': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'soqneiis': {
      'es': 'Verifica vs',
      'en': '',
    },
    '7t6ggbak': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    'eamqw0oa': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'xxpelahs': {
      'es': 'Search...',
      'en': '',
    },
    'pcskssfj': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    'xfdjcyse': {
      'es': 'RESGUARDO INDIVIDUAL',
      'en': '',
    },
    'frnnb565': {
      'es': 'OTRO',
      'en': '',
    },
    'ilancxbg': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    'ycf3pp4c': {
      'es': 'Factura',
      'en': '',
    },
    'nxs6fe8g': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    'g12xe76s': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'smxhysr2': {
      'es': 'Option 1',
      'en': '',
    },
    'fhfta6on': {
      'es': 'Factura',
      'en': '',
    },
    'hx87h3th': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'spny5ill': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    '78uziimi': {
      'es': 'Fecha de avaluo',
      'en': '',
    },
    'm59rbwc3': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'htrljoac': {
      'es': 'Ejercicio',
      'en': '',
    },
    '3iwg0eug': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    '3sazsovc': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    'opp0pzq5': {
      'es': '2025',
      'en': '',
    },
    'u8ncoskx': {
      'es': 'Año fiscal',
      'en': '',
    },
    '2hvv7b61': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'gcant721': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    'chakue3y': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    'zoh857mc': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'ky5ag46w': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'bh7a3nbj': {
      'es': 'Tipo de recurso',
      'en': '',
    },
    'suf5aypb': {
      'es': 'Tipo de recurso',
      'en': 'Title',
    },
    'sg1e2cro': {
      'es': 'Tipo de recurso',
      'en': 'Post Title',
    },
    '08qmsg1i': {
      'es': 'PRESUPUESTAL',
      'en': '',
    },
    '5rppvv6c': {
      'es': 'Option 1',
      'en': '',
    },
    'h27qruvb': {
      'es': 'Tipo de recurso',
      'en': '',
    },
    'zbrb3uuf': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'n4473wpr': {
      'es': 'Nombre del proveedor',
      'en': 'Title',
    },
    'vclf8y7z': {
      'es': 'Nombre delproveedor',
      'en': 'Post Title',
    },
    'kllndzp9': {
      'es': 'Option 1',
      'en': '',
    },
    'smcbwbvh': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'k44dlfbi': {
      'es': 'Resguardo',
      'en': '',
    },
    '8he7y26x': {
      'es': 'Folio resguardo',
      'en': 'Title',
    },
    's3h4rh0g': {
      'es': 'Folio resguardo',
      'en': 'Post Title',
    },
    'pr6c8f6q': {
      'es': 'Número de folio de resguardo',
      'en': '',
    },
    '0e27veo1': {
      'es': 'Marca comercial',
      'en': '',
    },
    '9g7zxqo5': {
      'es': 'Marca',
      'en': 'Title',
    },
    'igzij7ik': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    'fhh4f547': {
      'es': 'Option 1',
      'en': '',
    },
    'npuajsls': {
      'es': 'Marca',
      'en': '',
    },
    'udyo3xaa': {
      'es': 'Serie',
      'en': '',
    },
    '3lldxq7s': {
      'es': 'Número de serie',
      'en': 'Title',
    },
    'dhodq891': {
      'es': 'Número de serie',
      'en': 'Post Title',
    },
    'cufi8594': {
      'es': 'Número de serie del Bien',
      'en': '',
    },
    '2dpve7lt': {
      'es': 'Clase de activo (Depreciación)',
      'en': '',
    },
    'qgbvkkp3': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    '15dpf8xs': {
      'es': 'Clase de activo (Depreciación)',
      'en': 'Post Title',
    },
    'jm668w7i': {
      'es': 'Option 1',
      'en': '',
    },
    'nw3s1vfh': {
      'es': 'Clase de activo',
      'en': '',
    },
    'e6ljlng1': {
      'es': '¿El bien es contable?',
      'en': '',
    },
    'iyoixe3y': {
      'es': 'SI',
      'en': '',
    },
    'hozk4drx': {
      'es': '¿Es contable?',
      'en': '',
    },
    'bxw5od2g': {
      'es': 'Search...',
      'en': '',
    },
    '7zuhz21i': {
      'es': 'SI',
      'en': '',
    },
    'zoburlpa': {
      'es': 'NO',
      'en': '',
    },
    'h51dgp20': {
      'es': 'Estado del bien',
      'en': '',
    },
    'pqo6ie7y': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'kab4jnez': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    'j276das6': {
      'es': 'Search...',
      'en': '',
    },
    'ouai56in': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    '0rzh2qsz': {
      'es': 'REGULAR',
      'en': '',
    },
    '9lufrflz': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    '5wlglefo': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'em60p1iw': {
      'es': 'Estado del bien',
      'en': '',
    },
    'p85kinax': {
      'es': 'Color del bien',
      'en': '',
    },
    '2sxvatqt': {
      'es': 'Color',
      'en': 'Title',
    },
    'gh8ws72t': {
      'es': 'Color',
      'en': 'Post Title',
    },
    '4yklmaeg': {
      'es': 'Option 1',
      'en': '',
    },
    'z0likxhm': {
      'es': 'Color',
      'en': '',
    },
    'sudae488': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'k2hidfvy': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'eelfncap': {
      'es': 'Option 1',
      'en': '',
    },
    'ptdu6gh5': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'gtutcsvc': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'x0f5pbb5': {
      'es': 'Option 1',
      'en': '',
    },
    'yj4lgd67': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'so1fw2er': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '9bvto9bc': {
      'es': 'Option 1',
      'en': '',
    },
    'cvnjotlp': {
      'es': 'Licitación',
      'en': '',
    },
    '6la6usjt': {
      'es': 'Licitación',
      'en': 'Title',
    },
    'z235lfe3': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    '3wk0h5nl': {
      'es': 'Option 1',
      'en': '',
    },
    'i66kf3kt': {
      'es': 'Licitación',
      'en': '',
    },
    'w9qagusw': {
      'es': 'Placa',
      'en': '',
    },
    '77vklk05': {
      'es': 'Placa',
      'en': 'Title',
    },
    '8br6ffdm': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    'rl2d3wog': {
      'es': 'Placa',
      'en': '',
    },
    'r3luv1m5': {
      'es': 'Distrito',
      'en': '',
    },
    'bjrgs37n': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    'pkp394tl': {
      'es': 'Search...',
      'en': '',
    },
    'wr5slwzy': {
      'es': 'Xalapa',
      'en': '',
    },
    'ewx6mv19': {
      'es': 'Distrito',
      'en': '',
    },
    '6z9iiqpd': {
      'es': 'Inmueble',
      'en': '',
    },
    '974ap6bi': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    '4thmvpus': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    '5bxe4948': {
      'es': 'Almacén general',
      'en': '',
    },
    'qh921ox1': {
      'es': 'Option 1',
      'en': '',
    },
    'x7vpprwe': {
      'es': 'Inmueble',
      'en': '',
    },
    'h19ro25f': {
      'es': 'Zona',
      'en': 'Title',
    },
    'wboizpnz': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    '5a50z26i': {
      'es': 'CE',
      'en': '',
    },
    'd4ewp8cr': {
      'es': 'Option 1',
      'en': '',
    },
    'rc4idxp5': {
      'es': 'Modelo',
      'en': '',
    },
    'u6nfwknq': {
      'es': 'Modelo',
      'en': 'Title',
    },
    'bearw0yz': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    '1h2cghum': {
      'es': 'Option 1',
      'en': '',
    },
    'pamz8wjr': {
      'es': 'Modelo',
      'en': '',
    },
    'q3867ylp': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    'bybycvq4': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'q7e9op3x': {
      'es': 'No aplica',
      'en': '',
    },
    'pp5o5jb9': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '57f3aj54': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'kmddq68h': {
      'es': 'No aplica',
      'en': '',
    },
    'glwpuih5': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    'ctaxqr7n': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'a6e5hc3e': {
      'es': 'No aplica',
      'en': '',
    },
    'uj8km10a': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '0kcnlwnx': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    '3e58m57y': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'l4w1gbc4': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'idqkbhyf': {
      'es': 'Imagen del bien',
      'en': '',
    },
    '66g3mrs8': {
      'es': 'Imagen del bien',
      'en': '',
    },
    'do5f6zyw': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    'k4z3lv0j': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    'r7prd9yt': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    'zgllw48d': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    '487vbvhc': {
      'es': 'Crear',
      'en': 'Save',
    },
    'r8q7rfm5': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // QRPageNombreNegocio
  {
    'w5nxgb4r': {
      'es': 'Establecimiento',
      'en': 'Welcome',
    },
    'jt7bl5dg': {
      'es': 'Seleccionar Acción',
      'en': '',
    },
    '9vio5ryl': {
      'es': 'Giro',
      'en': '',
    },
    'tgixfp9h': {
      'es': 'Identificador: ',
      'en': '',
    },
    'n7k1l2u7': {
      'es': 'Tipo de Pago: ',
      'en': '',
    },
    'y9grw006': {
      'es': 'Último Pago: ',
      'en': '',
    },
    'prxj2tfy': {
      'es': 'Estado: ',
      'en': '',
    },
    'w6qnn4qy': {
      'es': 'Costo:',
      'en': '',
    },
    '3nbmbux5': {
      'es': 'Costo (\$):',
      'en': '',
    },
    'vot1phby': {
      'es': 'Pagar Anual',
      'en': '',
    },
    'sqwydew1': {
      'es': 'Pagar',
      'en': '',
    },
    '3uy0j9ff': {
      'es': 'Ver Información',
      'en': '',
    },
    'y22kpd7c': {
      'es': 'Infracciones',
      'en': 'Home',
    },
  },
  // BusquedaNombreNegocio
  {
    'b4jxt0f7': {
      'es': 'Establecimiento',
      'en': 'Welcome',
    },
    'jx8anf31': {
      'es': 'Ingresar Nombre Establecimiento',
      'en': '',
    },
    'uycqp6eu': {
      'es': 'Option 1',
      'en': '',
    },
    'iks8rpj9': {
      'es': 'Giro',
      'en': '',
    },
    '82z3h9vb': {
      'es': 'QR: ',
      'en': '',
    },
    'vgxzr5kr': {
      'es': 'Pago',
      'en': '',
    },
    'hgqstot9': {
      'es': 'IR A FORMATO DE PAGO',
      'en': '',
    },
    'asamrbfj': {
      'es': 'Ver Información',
      'en': '',
    },
    '5t7trlt8': {
      'es': 'Editar Info',
      'en': '',
    },
    '7ic3019z': {
      'es': 'Editar Foto Principal',
      'en': '',
    },
    'hrl3qlbg': {
      'es': 'Editar Posición',
      'en': '',
    },
    'z4ubbjep': {
      'es': 'Editar Fotos Complementarias',
      'en': '',
    },
    'ji46bs4o': {
      'es': 'Ver Comentarios',
      'en': '',
    },
    'c7gnnvm1': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    'eg0nbq54': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    '8ipcuspw': {
      'es': 'Eliminar Comercio',
      'en': '',
    },
    'e4906opz': {
      'es': 'Comercios',
      'en': 'Home',
    },
  },
  // EditPortada
  {
    'q59evkrs': {
      'es': 'Datos del Establecimiento',
      'en': 'Create start news',
    },
    '6wm4dfw2': {
      'es': 'Foto Principal',
      'en': 'Tap to load image',
    },
    '34utsuf7': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    'm8uhszmo': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // EditUbicacion
  {
    '7xx34kqt': {
      'es': 'Datos del Establecimiento',
      'en': 'Create start news',
    },
    'eyt4dw6u': {
      'es': 'Ubicación Establecimiento',
      'en': '',
    },
    'r92c0kl4': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    '8jrmsmzf': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // EditFotosComp
  {
    'u6nzlbb8': {
      'es': 'Datos del Establecimiento',
      'en': 'Create start news',
    },
    'rvtb6aui': {
      'es': 'Seleccionar Imagenes',
      'en': '',
    },
    'stnz5k3n': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    '2y5620iz': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // CrearGiro
  {
    '907qvl40': {
      'es': 'Crear Giro',
      'en': 'Create start news',
    },
    'ui66alyy': {
      'es': 'Nombre Giro de Negocio',
      'en': 'Title',
    },
    'ghmmeyk1': {
      'es': 'Nombre Giro de Negocio',
      'en': 'Post Title',
    },
    'oo7b8p0g': {
      'es': 'Número de UMAS por apertura',
      'en': 'Description',
    },
    '62ox9mnw': {
      'es': 'Número de UMAS por apertura',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    '97ejnq4t': {
      'es': 'UMAS Refrendo por metro lineal de frente',
      'en': 'Description',
    },
    'wnmo9n11': {
      'es': 'UMAS Refrendo por metro lineal de frente',
      'en':
          'Description of the publication that will be seen in the news of the &quot;Home&quot; section.',
    },
    'g1y9nste': {
      'es': 'Crear Giro',
      'en': 'Save',
    },
    'xlc6srql': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // DescripcionRuta
  {
    't6slbpqf': {
      'es': 'Descripción Ruta',
      'en': 'Welcome',
    },
    '6ojekq2k': {
      'es': 'Seleccionar Ruta',
      'en': '',
    },
    '4m7omgn4': {
      'es': 'Ruta',
      'en': '',
    },
    'p23499mg': {
      'es': 'Option 1',
      'en': '',
    },
    '09v1o4on': {
      'es': 'Descripción Ruta',
      'en': '',
    },
    'es6mif36': {
      'es': 'Descripción:',
      'en': '',
    },
    '3bwvdf4t': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // TotalComercios
  {
    'pj7vm70i': {
      'es': 'Total Comercios',
      'en': 'Welcome',
    },
    'yhek7dok': {
      'es': 'Lista de comercios de pago diario',
      'en': '',
    },
    'pn950foe': {
      'es': 'Identificador: ',
      'en': '',
    },
    'ereomjo1': {
      'es': 'último Pago: ',
      'en': '',
    },
    'g6fecvj0': {
      'es': 'Tipo Pago: ',
      'en': '',
    },
    'lgnu5et6': {
      'es': 'Ver Información',
      'en': '',
    },
    'g26mgis5': {
      'es': 'Lista de comercios de pago anual',
      'en': '',
    },
    'vicrullf': {
      'es': 'Identificador: ',
      'en': '',
    },
    'fgq2sz4w': {
      'es': 'último Pago: ',
      'en': '',
    },
    '2m7kgf6s': {
      'es': 'Tipo Pago: ',
      'en': '',
    },
    '0gfhpj69': {
      'es': 'Ver Información',
      'en': '',
    },
    'mcx6o54c': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // DescripcionRutaCopy
  {
    'zok05hex': {
      'es': 'Descripción Ruta',
      'en': 'Welcome',
    },
    'c6k8e4l4': {
      'es': 'Seleccionar Ruta',
      'en': '',
    },
    'fk97xqjk': {
      'es': 'Ruta',
      'en': '',
    },
    'uockattd': {
      'es': 'Option 1',
      'en': '',
    },
    'c6se5flb': {
      'es': 'Descripción Ruta',
      'en': '',
    },
    '6cq4mxwj': {
      'es': 'Descripción:',
      'en': '',
    },
    '94mmxsxw': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // VerComercioImprimir
  {
    'kjt6ey2m': {
      'es': 'CÓDIGO QR DE COMERCIO:',
      'en': '',
    },
    'layddqjo': {
      'es': 'FECHA REGISTRO',
      'en': '',
    },
    'qo52hdou': {
      'es': 'NOMBRE PROPIETARIO',
      'en': '',
    },
    'oz06f6tm': {
      'es': 'DOMICILIO PARTICULAR:',
      'en': '',
    },
    'si7hwy67': {
      'es': 'TIPO PERSONA:',
      'en': '',
    },
    'ih1sye3l': {
      'es': 'RFC:',
      'en': '',
    },
    '9l710wwd': {
      'es': 'NOMBRE DE NEGOCIO:',
      'en': '',
    },
    'u3tta1qx': {
      'es': 'DIRECCIÓN DE NEGOCIO:',
      'en': '',
    },
    'ji1cias2': {
      'es': 'COLONIA:',
      'en': '',
    },
    'hp28ka2q': {
      'es': 'NÚMERO:',
      'en': '',
    },
    't4ejar4v': {
      'es': 'GIRO:',
      'en': '',
    },
    'je49ix7v': {
      'es': 'SUPERFICIE M2:',
      'en': '',
    },
    'eyzwi4r4': {
      'es': 'DESCRIPCIÓN ACTIVIDAD COMERCIAL',
      'en': '',
    },
    '6z68n9v3': {
      'es': 'FECHA DE ÚLTIMO PAGO ANUAL:',
      'en': '',
    },
    'it54hvsl': {
      'es': 'INICIO DE OPERACIONES:',
      'en': '',
    },
    'aq0wn7v4': {
      'es': 'FOLIO DOCUMENTO: ',
      'en': '',
    },
    's36le8ye': {
      'es': 'TESORERA MUNICIPAL',
      'en': '',
    },
    '6uqgy3xf': {
      'es':
          'NOTA: EL PRESENTE DOCUMENTO NO ES UNA LICENCIA DE FUNCIONAMIENTO.  NO GENERA NINGUNA OBLICACIÓN POR PARTE DEL AYUNTAMIENTO \nASÍ COMO NO ES VÁLIDO COMO REFERENCIA DE EMPADRONAMIENTO.  LOS DATOS SE HAN PPROPORCIONADO DE FORMA VOLUNTARIA POR EL\n CIUDADANO. LA INFORMACIÓN ESTÁ SUJETA AL AVISO DE PRIVACIDAD: \nhttp://transparencia.angelrcabada.gob.mx/datos-personales/',
      'en': '',
    },
    'z7ygeiv3': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // BusquedaNombrePropietario
  {
    'zyo87z5s': {
      'es': 'Establecimiento',
      'en': 'Welcome',
    },
    's63uyetp': {
      'es': 'Comercios',
      'en': 'Home',
    },
  },
  // Descarga
  {
    'mptc54px': {
      'es': 'Descargar Comercios',
      'en': '',
    },
    'ls9tzsdn': {
      'es': 'Home',
      'en': '',
    },
  },
  // MapaColores
  {
    'z9owjp6p': {
      'es': 'Pendientes Hoy',
      'en': 'Welcome',
    },
    'hdd6za81': {
      'es': 'Pendiente de Pagar Hoy',
      'en': '',
    },
    'tj64gwuz': {
      'es': 'Ruta',
      'en': '',
    },
    'cs025vtt': {
      'es': 'Option 1',
      'en': '',
    },
    'lwtbxvem': {
      'es': 'RUTA ARAUCARIAS XALAPA',
      'en': '',
    },
    'v6z0ymfq': {
      'es': 'HUMBOLDT',
      'en': '',
    },
    '2htokjca': {
      'es': 'AV. CARRETERA COSTERA DEL GOLFO',
      'en': '',
    },
    'j2tqpa6x': {
      'es': 'Anual',
      'en': '',
    },
    'wbrjoh0z': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // DescargaCopy
  {
    'exo3b1et': {
      'es': 'Descargar Comercios',
      'en': '',
    },
    'tzk52hpe': {
      'es': 'Home',
      'en': '',
    },
  },
  // ArchivoInfracciones
  {
    'pxhh1puj': {
      'es': 'Infracciones',
      'en': 'Welcome',
    },
    'v7o4to1o': {
      'es': 'Infracciones pendientes de pago',
      'en': '',
    },
    '8eaiiyge': {
      'es': 'Fecha: ',
      'en': '',
    },
    'cd0uuh35': {
      'es': 'Infracciones',
      'en': 'Home',
    },
  },
  // FiltrosGiro
  {
    'rzbikivs': {
      'es': 'Total Comercios',
      'en': 'Welcome',
    },
    '8osyrkyn': {
      'es': 'Sin Giro',
      'en': '',
    },
    '267vhm79': {
      'es': 'Seleccionar GIRO...',
      'en': '',
    },
    'h3mlyd7q': {
      'es': 'Search for an item...',
      'en': '',
    },
    'skvfsc3y': {
      'es': 'Option 1',
      'en': '',
    },
    '93vnkyzw': {
      'es': 'Lista de comercios por GIRO',
      'en': '',
    },
    'pvdlddvg': {
      'es': 'Identificador: ',
      'en': '',
    },
    '0lszmp6r': {
      'es': 'último Pago: ',
      'en': '',
    },
    '2b17sgdu': {
      'es': 'Tipo Pago: ',
      'en': '',
    },
    '25lbvv34': {
      'es': 'Ver Información',
      'en': '',
    },
    'w5evo8gb': {
      'es': 'Ver Coment.',
      'en': '',
    },
    'vkbjcike': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    'zl5jjka8': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    'n68a1cg9': {
      'es': 'Lista de comercios por GIRO',
      'en': '',
    },
    '1mcdegmh': {
      'es': 'Identificador: ',
      'en': '',
    },
    '4nxq68dk': {
      'es': 'último Pago: ',
      'en': '',
    },
    'bjc2s6us': {
      'es': 'Tipo Pago: ',
      'en': '',
    },
    'olv03mnx': {
      'es': 'Ver Información',
      'en': '',
    },
    'pz8efaqu': {
      'es': 'Ver Coment.',
      'en': '',
    },
    'kfaiph3y': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    'q6pikur4': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    'fmmh5s5n': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // PendientesAnual
  {
    'qtq2pcgs': {
      'es': 'Pendientes Hoy',
      'en': 'Welcome',
    },
    'c9glxw79': {
      'es': 'Pendiente de Pagar Anual',
      'en': '',
    },
    'f04yyndy': {
      'es': 'Elegir ruta',
      'en': '',
    },
    'ipaenu7c': {
      'es': 'Ruta',
      'en': '',
    },
    'mr3xpq0a': {
      'es': 'Option 1',
      'en': '',
    },
    'qnoksdl5': {
      'es': 'Negocios ruta',
      'en': '',
    },
    '29jjgotq': {
      'es': 'Negocios Restantes',
      'en': '',
    },
    '5dzte2i0': {
      'es': 'Ver en Maps',
      'en': '',
    },
    'h8w8mftn': {
      'es': 'QR: ',
      'en': '',
    },
    'mb9kt2xn': {
      'es': 'último Pago: ',
      'en': '',
    },
    'xe5bt8an': {
      'es': 'Impresión',
      'en': '',
    },
    'oz48t53b': {
      'es': 'Ver Lugar',
      'en': '',
    },
    '06avzngy': {
      'es': 'Formato Pago',
      'en': '',
    },
    'rtwhypa2': {
      'es': 'Ver Comen.',
      'en': '',
    },
    '9za50vg9': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    '3dw75xp0': {
      'es': 'Agreg. Escan.',
      'en': '',
    },
    'ipj3b5oj': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // PagosDiariosCopy
  {
    'hax200hg': {
      'es': 'Pendientes Hoy',
      'en': 'Welcome',
    },
    'gl7gu8xu': {
      'es': 'Pendiente de Pagar Hoy',
      'en': '',
    },
    '5k0cpp2d': {
      'es': 'Ruta',
      'en': '',
    },
    'o9e8t1ay': {
      'es': 'Option 1',
      'en': '',
    },
    'vxe5mx2n': {
      'es': 'Negocios ruta',
      'en': '',
    },
    'fd0r2amd': {
      'es': 'Negocios Restantes',
      'en': '',
    },
    'dwchf5t1': {
      'es': 'Ver en Maps',
      'en': '',
    },
    'nmuhl2xe': {
      'es': 'QR: ',
      'en': '',
    },
    '84f0qqld': {
      'es': 'último Pago: ',
      'en': '',
    },
    't0sseoba': {
      'es': 'Impresión',
      'en': '',
    },
    '16fs3ht3': {
      'es': 'Ver Lugar',
      'en': '',
    },
    'wjt3whb8': {
      'es': 'Formato Pago',
      'en': '',
    },
    '4mnisp0s': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // PagosDia
  {
    'rx9p10tq': {
      'es': 'Total Cuenta',
      'en': 'Welcome',
    },
    '819c80yb': {
      'es': 'Total de tipo Diario: ',
      'en': '',
    },
    'sbbuk8ce': {
      'es': 'Fecha: ',
      'en': '',
    },
    '2g5lqr34': {
      'es': 'Total de tipo Anual: ',
      'en': '',
    },
    'ztfyy8ye': {
      'es': 'Fecha: ',
      'en': '',
    },
    '8fnyyiuv': {
      'es': 'Cobrador',
      'en': '',
    },
    'ywbriyrh': {
      'es': 'Option 1',
      'en': '',
    },
    '3ynxpr29': {
      'es': 'Seleccionar fecha',
      'en': '',
    },
    'tvlkat8f': {
      'es': 'Total por cobrador Tipo Diario: ',
      'en': '',
    },
    '2u7pb246': {
      'es': 'Fecha: ',
      'en': '',
    },
    'jh9v9aws': {
      'es': 'Total por cobrador  Tipo Anual: ',
      'en': '',
    },
    'eeigk2ru': {
      'es': 'Fecha: ',
      'en': '',
    },
    'tp9xfe6p': {
      'es': 'Total de Negocios Diarios',
      'en': '',
    },
    'sho1w3lm': {
      'es': 'Cobrados hoy:',
      'en': '',
    },
    'j3i4bmvt': {
      'es': 'Total de Negocios Anuales',
      'en': '',
    },
    '78sy5c3u': {
      'es': 'Sin adeudo:',
      'en': '',
    },
    'equxa3ez': {
      'es': 'Descargar cobros TOTALES Anuales',
      'en': '',
    },
    '8j60c8y9': {
      'es': 'Descargar cobros Anuales por fecha',
      'en': '',
    },
    'buhmx10h': {
      'es': 'Descargar cobros Anuales por cobrador',
      'en': '',
    },
    'xkxjqczv': {
      'es': 'Descargar cobros TOTALES Diarios',
      'en': '',
    },
    '7b339tae': {
      'es': 'Descargar cobros Diarios por fecha',
      'en': '',
    },
    'f6ba5ru7': {
      'es': 'Descargar cobros Diarios por cobrador',
      'en': '',
    },
    'byj3rmqn': {
      'es': 'Generar E-Ticket Diario',
      'en': '',
    },
    'vs4f3ohr': {
      'es': 'Generar E-Ticket Anual',
      'en': '',
    },
    '2laja3w2': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // CuentaDiarioCopyCopy
  {
    'kesvjsyo': {
      'es': 'Total Cuenta',
      'en': 'Welcome',
    },
    '12tkndqm': {
      'es': 'Total Hoy tipo Diario: ',
      'en': '',
    },
    'j8l5somd': {
      'es': 'Fecha: ',
      'en': '',
    },
    'jjg7mjd4': {
      'es': 'Total Hoy de tipo Anual: ',
      'en': '',
    },
    'q2egy91q': {
      'es': 'Fecha: ',
      'en': '',
    },
    '4n6vhlge': {
      'es': 'Cobrador',
      'en': '',
    },
    'dyyz85v7': {
      'es': 'Option 1',
      'en': '',
    },
    'da9ppmj3': {
      'es': 'Seleccionar fecha',
      'en': '',
    },
    '3h718lj0': {
      'es': 'Total Hoy Tipo Diario: ',
      'en': '',
    },
    'te2ys3m1': {
      'es': 'Fecha: ',
      'en': '',
    },
    'hdlyp6cz': {
      'es': 'Total Hoy de  Tipo Anual: ',
      'en': '',
    },
    'f1jr3bm4': {
      'es': 'Fecha: ',
      'en': '',
    },
    'damzw689': {
      'es': 'Total de Negocios Diarios',
      'en': '',
    },
    'u78dcmqp': {
      'es': 'Cobrados hoy:',
      'en': '',
    },
    'i6ns518w': {
      'es': 'Total de Negocios Anuales',
      'en': '',
    },
    'gswap7sk': {
      'es': 'Sin adeudo:',
      'en': '',
    },
    'fs4gft35': {
      'es': 'Descargar cobros Anuales',
      'en': '',
    },
    'f3v1f1iy': {
      'es': 'Descargar cobros Diarios',
      'en': '',
    },
    'b60hi971': {
      'es': 'Generar E-Ticket Diario',
      'en': '',
    },
    'n8mpwbo0': {
      'es': 'Generar E-Ticket Anual',
      'en': '',
    },
    's0tmkg2v': {
      'es': 'último Pago: ',
      'en': '',
    },
    'vaojd7wg': {
      'es': 'Ver Lugar',
      'en': '',
    },
    '3ukpv53k': {
      'es': 'Tipo de Pago: ',
      'en': '',
    },
    'dju4oro0': {
      'es': 'Último Pago: ',
      'en': '',
    },
    'yo6hyfix': {
      'es': 'Estado: ',
      'en': '',
    },
    'dyyxkdur': {
      'es': 'Ver Información',
      'en': '',
    },
    'b5ro8msc': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // ListaPagosAnuales
  {
    'y3thd4ov': {
      'es': 'Fecha',
      'en': '',
    },
    'lbrhuqkr': {
      'es': 'Modificar',
      'en': '',
    },
    'kyguozwy': {
      'es': 'Modificar',
      'en': '',
    },
    'lomww4ih': {
      'es': 'Home',
      'en': '',
    },
  },
  // ListaPagosAnualesCopy
  {
    '23melmks': {
      'es': 'Fecha',
      'en': '',
    },
    'fey4qi41': {
      'es': 'Modificar',
      'en': '',
    },
    'ecl69k31': {
      'es': 'Home',
      'en': '',
    },
  },
  // VerComentarios
  {
    'ovvp40m5': {
      'es': 'Comentarios por comercio',
      'en': 'Welcome',
    },
    '9kngww9o': {
      'es': 'ELIMINAR REPORTE',
      'en': '',
    },
    '2jrl26fa': {
      'es': 'Fecha de reporte: ',
      'en': '',
    },
    'p07w3ihj': {
      'es': 'Quién reporta: ',
      'en': '',
    },
    'oho8r8hd': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // EscanearDocumento
  {
    '4j26xmaa': {
      'es': 'Escanear documento',
      'en': 'Welcome',
    },
    'iztcy6w9': {
      'es': 'Nombre de documento',
      'en': '',
    },
    'waibjmjs': {
      'es': 'Nombre de documento',
      'en': '',
    },
    'qr1dudxq': {
      'es': 'Nombre de documento',
      'en': '',
    },
    'szhjbd76': {
      'es': 'Seleccionar imagen',
      'en': '',
    },
    '005yryml': {
      'es': 'Seleccionar PDF',
      'en': '',
    },
    'pljolw6n': {
      'es': 'Guardar',
      'en': '',
    },
    'zmi97p5w': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // VerEscaneo
  {
    '9olxgt6j': {
      'es': 'Ver documento escaneado',
      'en': 'Welcome',
    },
    '0yaufl6b': {
      'es': 'Fecha de captura: ',
      'en': '',
    },
    'k6axcf6l': {
      'es': 'Quién captura: ',
      'en': '',
    },
    'eaef6i4v': {
      'es': 'Ver PDF',
      'en': '',
    },
    'dojrsr6w': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // AnualRecordatorio
  {
    'ksj4gawu': {
      'es': 'Pendientes Hoy',
      'en': 'Welcome',
    },
    'snlkk2b6': {
      'es': 'Pendiente de Pagar Anual',
      'en': '',
    },
    '3u014scj': {
      'es': 'Elegir ruta',
      'en': '',
    },
    'mu9gj655': {
      'es': 'Ruta',
      'en': '',
    },
    'dho9gib9': {
      'es': 'Option 1',
      'en': '',
    },
    'ub0gjqlg': {
      'es': 'Negocios ruta',
      'en': '',
    },
    '6iocs163': {
      'es': 'Negocios Restantes',
      'en': '',
    },
    'fvxx1159': {
      'es': 'Ver en Maps',
      'en': '',
    },
    'r58zwygg': {
      'es': 'QR: ',
      'en': '',
    },
    'b54qetps': {
      'es': 'último Pago: ',
      'en': '',
    },
    'q3a5amxu': {
      'es': 'Impresión',
      'en': '',
    },
    'sjd1vu5m': {
      'es': 'Ver Lugar',
      'en': '',
    },
    '9r6rtw6m': {
      'es': 'Formato Pago',
      'en': '',
    },
    'bajjhste': {
      'es': 'Ver Comentarios',
      'en': '',
    },
    'vzoep62q': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    'ue31kefu': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    'epyvtrk2': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // VerEscaneoCopy
  {
    'jslf6aup': {
      'es': 'Ver documento escaneado',
      'en': 'Welcome',
    },
    'f56f8gdn': {
      'es': 'Fecha de captura: ',
      'en': '',
    },
    'l99cwccp': {
      'es': 'Quién captura: ',
      'en': '',
    },
    'dt7zeyjj': {
      'es': 'Ver PDF',
      'en': '',
    },
    '8ttw87h2': {
      'es': 'Ver PDF',
      'en': '',
    },
    'aamzw0jr': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // PendientesAnualCopy
  {
    '8hk6cau6': {
      'es': 'Pendientes Hoy',
      'en': 'Welcome',
    },
    '2qpi7gsy': {
      'es': 'Pendiente de Pagar Anual',
      'en': '',
    },
    'kv5vmkea': {
      'es': 'Elegir ruta',
      'en': '',
    },
    'ym2d80h7': {
      'es': 'Ruta',
      'en': '',
    },
    'mjqpzh3a': {
      'es': 'Option 1',
      'en': '',
    },
    '1ky1gqys': {
      'es': 'Negocios ruta',
      'en': '',
    },
    '6fd07l20': {
      'es': 'Negocios Restantes',
      'en': '',
    },
    'crq9ewfk': {
      'es': 'Ver en Maps',
      'en': '',
    },
    'x7m7ldk0': {
      'es': 'QR: ',
      'en': '',
    },
    'wkoai9am': {
      'es': 'último Pago: ',
      'en': '',
    },
    'loe85fqs': {
      'es': 'Ver Comentarios',
      'en': '',
    },
    '50unko14': {
      'es': 'Ver Escaneos',
      'en': '',
    },
    '9jrjcafu': {
      'es': 'Agregar Escaneos',
      'en': '',
    },
    'jivuybjr': {
      'es': 'Pago Diario',
      'en': 'Home',
    },
  },
  // InfoUsuarios
  {
    'lk1d52sx': {
      'es': 'Información por usuario',
      'en': 'Welcome',
    },
    'ilvgk5p9': {
      'es': 'Nombre: ',
      'en': '',
    },
    'hp34lk42': {
      'es': 'Comercios registrados: ',
      'en': '',
    },
    'uyzv5elk': {
      'es': 'Mi Cuenta',
      'en': 'Home',
    },
  },
  // LoginPJEV
  {
    'kxg07dtn': {
      'es': 'Iniciar sesión',
      'en': 'Enter created account data',
    },
    'nrk91wfv': {
      'es': 'Correo',
      'en': 'Enter created account data',
    },
    'd2r4z4bj': {
      'es': '',
      'en': 'E-mail',
    },
    '91uq1lk1': {
      'es': 'Tu cuenta de correo',
      'en': 'write email',
    },
    'v0ldpyhr': {
      'es': 'Contraseña',
      'en': 'Enter created account data',
    },
    '63qas81x': {
      'es': '',
      'en': 'Password',
    },
    '8unrea98': {
      'es': 'Entrar',
      'en': 'Get into',
    },
    '4zc7w2vr': {
      'es': 'Iniciar sesión',
      'en': 'Enter created account data',
    },
    'fnt8h3g0': {
      'es': 'Correo',
      'en': 'Enter created account data',
    },
    'kofvevxd': {
      'es': '',
      'en': 'E-mail',
    },
    'pgc7x4in': {
      'es': 'Tu cuenta de correo',
      'en': 'write email',
    },
    'fr7fxqch': {
      'es': 'Contraseña',
      'en': 'Enter created account data',
    },
    '880u9yqz': {
      'es': '',
      'en': 'Password',
    },
    'cazuxtvt': {
      'es': '··············',
      'en': '',
    },
    'akugau0o': {
      'es': 'Entrar',
      'en': 'Get into',
    },
    '34kat7e8': {
      'es': 'Home',
      'en': 'home',
    },
  },
  // Bitacora
  {
    'o3gjs2h2': {
      'es': 'Inicio',
      'en': '',
    },
    'knpkx2j3': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '9wqti678': {
      'es': 'Vers. 0.5.4',
      'en': '',
    },
    '320xqm22': {
      'es': 'Bitácoras',
      'en': '',
    },
    'whlaaqdu': {
      'es': 'Nuevo',
      'en': '',
    },
    '9jw5p7uh': {
      'es': 'Descripción',
      'en': '',
    },
    '4rmh809z': {
      'es': 'Fecha de bitácora',
      'en': '',
    },
    'l9qrzmmg': {
      'es': 'Quien realizó',
      'en': '',
    },
    'y97u7f4b': {
      'es': 'Tipo acción',
      'en': '',
    },
    'pcff2yr4': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // EditarBien
  {
    'r73mavt5': {
      'es': 'Regresar',
      'en': '',
    },
    'p1ggjcf1': {
      'es': 'Editar Activo',
      'en': '',
    },
    'cmce8763': {
      'es': 'ID',
      'en': '',
    },
    'ns20ef52': {
      'es': 'Inventario',
      'en': 'Title',
    },
    't0ozvs9n': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'ux2892vz': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'l3rxp2up': {
      'es': 'ID anterior',
      'en': '',
    },
    '16zkwq20': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    '8dqy45bq': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    'mp8cg2uk': {
      'es': 'Número de ID anterior del bien',
      'en': '',
    },
    '3tl51583': {
      'es': 'Importe',
      'en': '',
    },
    'a484fkk5': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'u37t4jf9': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'zmdcdis3': {
      'es': 'Importe del bien',
      'en': '',
    },
    'f00xyu9d': {
      'es': 'Avalúo',
      'en': '',
    },
    'shktgoo4': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Title',
    },
    'dajpz9ng': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Post Title',
    },
    'zkja1b2y': {
      'es': 'Importe del avalúo',
      'en': '',
    },
    'cjopjm8y': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '2c1mziwq': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    '30lxe75s': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    '9vnlbjk0': {
      'es': 'Option 1',
      'en': '',
    },
    '2offzv6c': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '7li910w2': {
      'es': 'Depositario',
      'en': '',
    },
    'xxtdwwpc': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'stpgzk99': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'r7i1lt5s': {
      'es': 'Option 1',
      'en': '',
    },
    'wkr15es9': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'zrc9i5x3': {
      'es': 'Origen del recurso',
      'en': '',
    },
    '3au7ehj7': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'qpdsa5ak': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    '8s2jl27s': {
      'es': 'Option 1',
      'en': '',
    },
    'ialle2aw': {
      'es': 'Origen del recurso',
      'en': '',
    },
    '6xeeuq07': {
      'es': 'Usuario',
      'en': '',
    },
    'x59044p2': {
      'es': 'Usuario',
      'en': 'Title',
    },
    '2a9xvwzt': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    '50bg3cgn': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'l016hcjw': {
      'es': 'Verifica vs',
      'en': '',
    },
    'yldnmikg': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'bdetx07e': {
      'es': 'Search...',
      'en': '',
    },
    'ctxjfevv': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    'f5pq6oz3': {
      'es': 'RESGUARDO INDIVIDUAL',
      'en': '',
    },
    'jyyrsog8': {
      'es': 'OTRO',
      'en': '',
    },
    'm0g9nesi': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    '864x7f8p': {
      'es': 'Factura',
      'en': '',
    },
    't2usmm82': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    '47x3lvkx': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'kdmnysty': {
      'es': 'Option 1',
      'en': '',
    },
    'obx0ie9l': {
      'es': 'Factura',
      'en': '',
    },
    'lkjf4kvt': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'pflw26ab': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    '1pgd487m': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    '5i59qjzg': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    '5epi3kww': {
      'es': 'Ejercicio',
      'en': '',
    },
    '6di4yfn6': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    'tekv9hgr': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    's4luyagn': {
      'es': 'Año fiscal',
      'en': '',
    },
    'rjaprpms': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    'r5b1wgm0': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    'k2klsye1': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    'nhnd7zwj': {
      'es': 'Option 1',
      'en': '',
    },
    'juvr1l7j': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'fml0y6hv': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'htz4ojk2': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    'fl7svo0q': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    'x834jp0b': {
      'es': 'Option 1',
      'en': '',
    },
    'd84uypgh': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'i6ie2rot': {
      'es': 'Resguardo',
      'en': '',
    },
    'd4gb7xrg': {
      'es': 'Folio resguardo',
      'en': 'Title',
    },
    '5jtuw05y': {
      'es': 'Folio resguardo',
      'en': 'Post Title',
    },
    'skaz7xyv': {
      'es': 'Número de folio de resguardo',
      'en': '',
    },
    '4jlwg1ea': {
      'es': 'Marca comercial',
      'en': '',
    },
    'v3q8g0yu': {
      'es': 'Marca',
      'en': 'Title',
    },
    'fdim31ch': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    '6m7gb1pa': {
      'es': 'Option 1',
      'en': '',
    },
    '1qryeq2d': {
      'es': 'Marca',
      'en': '',
    },
    'wjelh7k2': {
      'es': 'Documento cotejo',
      'en': '',
    },
    'z7ml3m3e': {
      'es': 'FACTURA',
      'en': '',
    },
    '9mz034if': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'mogctyp6': {
      'es': 'Search...',
      'en': '',
    },
    'b64zlat6': {
      'es': 'FACTURA',
      'en': '',
    },
    't2mksbpm': {
      'es': 'RESGUARDO',
      'en': '',
    },
    '6w66vvr1': {
      'es': 'OFICIO',
      'en': '',
    },
    '506jozes': {
      'es': 'LISTADO ELECTRONICO',
      'en': '',
    },
    'yzz14sx2': {
      'es': 'RELACION',
      'en': '',
    },
    '3t9r8xo4': {
      'es': 'NINGUNO',
      'en': '',
    },
    'hd9cdq0j': {
      'es': 'OTRO',
      'en': '',
    },
    'qqeh6tmc': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    '3s1gmuj4': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'mgnrznxa': {
      'es': 'Clase de activo',
      'en': 'Post Title',
    },
    'k17po113': {
      'es': 'Option 1',
      'en': '',
    },
    's86n2ud7': {
      'es': 'Clase de activo',
      'en': '',
    },
    'w4n73x0t': {
      'es': 'Estado del bien',
      'en': '',
    },
    'mhvzo9ok': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    'icn0bevs': {
      'es': 'Search...',
      'en': '',
    },
    'rxrh9sgx': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'ijxwlmi7': {
      'es': 'REGULAR',
      'en': '',
    },
    'o552avht': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    'e1648vez': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'haf8kf2l': {
      'es': 'Estado del bien',
      'en': '',
    },
    'c91wo515': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'xcj5o4a9': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    '2vtx1zdy': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    't6ecboff': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    '5e85xab9': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'vgmgr7hc': {
      'es': 'Color del bien',
      'en': '',
    },
    '9iq30ub4': {
      'es': 'Color',
      'en': 'Title',
    },
    'hvo5iqmb': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'g7wolvjp': {
      'es': 'Option 1',
      'en': '',
    },
    'atqtumky': {
      'es': 'Color',
      'en': '',
    },
    '5f4hors3': {
      'es': 'Modelo',
      'en': '',
    },
    'xuf095ne': {
      'es': 'Modelo',
      'en': 'Title',
    },
    'w8dkj4lv': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    '410xuguv': {
      'es': 'Option 1',
      'en': '',
    },
    'go8emjan': {
      'es': 'Modelo',
      'en': '',
    },
    'yudgl0gc': {
      'es': 'Licitación',
      'en': '',
    },
    'zsy8n01s': {
      'es': 'Licitación',
      'en': 'Title',
    },
    '78ztn90q': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    '30ll4cgy': {
      'es': 'Option 1',
      'en': '',
    },
    'rrxh97m5': {
      'es': 'Licitación',
      'en': '',
    },
    '18ym971x': {
      'es': 'Placa',
      'en': '',
    },
    'e9b5q4s1': {
      'es': 'Placa',
      'en': 'Title',
    },
    'dwd9z5h9': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    'ag1p93wy': {
      'es': 'Placa',
      'en': '',
    },
    'aw7nna0c': {
      'es': 'Dsitrito',
      'en': '',
    },
    'gi46l6th': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    'whls27zf': {
      'es': 'Search...',
      'en': '',
    },
    '1z3lyx05': {
      'es': 'Xalapa',
      'en': '',
    },
    't1s6h717': {
      'es': 'Distrito',
      'en': '',
    },
    'wpgmw41j': {
      'es': 'Inmueble',
      'en': '',
    },
    '9hn3v5il': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    'nd2hc9ej': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    'ek4uhg16': {
      'es': 'Option 1',
      'en': '',
    },
    'ubup55ol': {
      'es': 'Inmueble',
      'en': '',
    },
    'cp5rh2qc': {
      'es': 'Zona',
      'en': 'Title',
    },
    'wl1j3t19': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    '36ftfwb1': {
      'es': 'Option 1',
      'en': '',
    },
    'g60vgrgj': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    'sz8sises': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'c7jv48pd': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '5a1z1hvm': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    't5fz37ro': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    '0uixlwt0': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'twj8y8te': {
      'es': 'No aplica',
      'en': '',
    },
    'ef601npz': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '7k9oamc8': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'uxj4tw3j': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'um9lagkv': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '96f0hxqs': {
      'es': 'Imagen del bien',
      'en': '',
    },
    'o4pw1oyu': {
      'es': 'Imagen del bien',
      'en': '',
    },
    'buvdsjgs': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    'cbpxpo31': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    '9wlbgcyj': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    'qxs4t7jf': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    'xq2aqk4n': {
      'es': 'Search...',
      'en': '',
    },
    'iw28coz3': {
      'es': 'ANEXO 1',
      'en': '',
    },
    'rulcge1e': {
      'es': 'ANEXO 2',
      'en': '',
    },
    'qggmdb2y': {
      'es': 'ANEXO 3',
      'en': '',
    },
    'r3h4f4se': {
      'es': 'ANEXO 4',
      'en': '',
    },
    'sztkwrom': {
      'es': '¿El bien es contable?',
      'en': '',
    },
    'qy5wbnqy': {
      'es': '¿Es contable?',
      'en': '',
    },
    'l8wwmwss': {
      'es': 'Search...',
      'en': '',
    },
    '72ss1zcn': {
      'es': 'SI',
      'en': '',
    },
    'p306d0rw': {
      'es': 'NO',
      'en': '',
    },
    'yeqyror3': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    'sv2d58vp': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Catalogos
  {
    'p0v7hkfl': {
      'es': 'Inicio',
      'en': '',
    },
    'o0cy1gzu': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '3nxwp5mi': {
      'es': 'Vers. 0.5.4',
      'en': '',
    },
    'ky3yt201': {
      'es': 'Distritos',
      'en': '',
    },
    'ddc3e424': {
      'es': 'Nuevo',
      'en': '',
    },
    '1td7nphr': {
      'es': 'Descripción',
      'en': '',
    },
    '0yrbacph': {
      'es': 'Fecha de alta',
      'en': '',
    },
    'f60ivsxd': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Depositarios
  {
    'qsx0skcd': {
      'es': 'Inicio',
      'en': '',
    },
    '4dxtb2sx': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'yy7z6dpo': {
      'es': 'Depositarios',
      'en': '',
    },
    'pe5m89kc': {
      'es': 'Buscar',
      'en': '',
    },
    'dlak1yxz': {
      'es': 'Nuevo',
      'en': '',
    },
    'nd23q83v': {
      'es': 'Nombre:',
      'en': '',
    },
    'rjfnbvis': {
      'es': 'Cargo:',
      'en': '',
    },
    'svgun4zk': {
      'es': 'Fecha de alta:',
      'en': '',
    },
    'wdo7p8po': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Depreciacion
  {
    'wre5zqkj': {
      'es': 'Inicio',
      'en': '',
    },
    '6h937vyw': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'ur8eslej': {
      'es': 'Clase de activos. Base para el cálculo de depreciación.',
      'en': '',
    },
    'e103ms3p': {
      'es': 'Nuevo',
      'en': '',
    },
    '7081qd1g': {
      'es': 'Nombre',
      'en': '',
    },
    'oqj4p9s9': {
      'es': 'Porcentaje depreciación %',
      'en': '',
    },
    'ac78f7o6': {
      'es': 'Vida útil (años)',
      'en': '',
    },
    'rn1crh42': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Ubicaciones
  {
    '1pv6qq3r': {
      'es': 'Inicio',
      'en': '',
    },
    'purbz9hg': {
      'es': 'Salir',
      'en': '',
    },
    '0kvqk3yb': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'c4r7s9vy': {
      'es': 'Niveles de organización PJEV',
      'en': '',
    },
    'ijxoqzq2': {
      'es': 'Crear nuevo nivel',
      'en': '',
    },
    'tw37ihme': {
      'es': 'Borrar nivel',
      'en': '',
    },
    '5s3x0lm1': {
      'es': 'Nivel 1. Organización',
      'en': '',
    },
    'rsi2smmk': {
      'es': 'Nivel 2. Dirección',
      'en': '',
    },
    'u4au3jbw': {
      'es': 'Nivel 3. Jurisdicción',
      'en': '',
    },
    '3uj1msfu': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Reportes
  {
    '4ov4sc09': {
      'es': 'Inicio',
      'en': '',
    },
    'g1yykjs9': {
      'es': 'Anexo 1 a 2',
      'en': '',
    },
    '624qxgr7': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '5x5gewkb': {
      'es': 'Sección para la obtención de reportes',
      'en': '',
    },
    '5ac77vpy': {
      'es': 'Resguardo individual',
      'en': '',
    },
    'ei4a86ld': {
      'es': 'Resguardo vale',
      'en': '',
    },
    'jj7hplkp': {
      'es': 'Reporte por usuario',
      'en': '',
    },
    'iir1stn8': {
      'es': 'ANEXO 1. Bienes muebles localizados',
      'en': '',
    },
    'tpk44zo4': {
      'es': 'Reporte ANEXO 1',
      'en': '',
    },
    'sq7pwavo': {
      'es': 'ANEXO 2. Bienes muebles NO localizados',
      'en': '',
    },
    'hqjuy5bv': {
      'es': 'Reporte ANEXO 2',
      'en': '',
    },
    'n29ajo00': {
      'es': 'ANEXO 3. Bienes muebles dados de ALTA',
      'en': '',
    },
    '1djl8zjd': {
      'es': 'Reporte ANEXO 3',
      'en': '',
    },
    '7va9hrnc': {
      'es': 'ANEXO 4. Bienes muebles propuestos para BAJA',
      'en': '',
    },
    'ksjj3kl6': {
      'es': 'Reporte ANEXO 4',
      'en': '',
    },
    'w73fljyy': {
      'es': 'ANEXO 5. Total de bienes muebles de todos los anexos',
      'en': '',
    },
    'w7jp90ij': {
      'es': 'Reporte ANEXO 5',
      'en': '',
    },
    'o06q7p8s': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // CrearBienCopy
  {
    'k59qif5i': {
      'es': 'Regresar',
      'en': '',
    },
    'ovv32057': {
      'es': 'Agregar nuevo Activo',
      'en': '',
    },
    'hd5q4xgk': {
      'es': 'ID',
      'en': '',
    },
    '7ezvyaks': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'va8e3f0y': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    '83jnfw5g': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'srp6ehze': {
      'es': 'Serie',
      'en': '',
    },
    '3q9n6tnw': {
      'es': 'Número de serie',
      'en': 'Title',
    },
    'fcpwjas2': {
      'es': 'Número de serie',
      'en': 'Post Title',
    },
    '659guepq': {
      'es': 'Número de serie del Bien',
      'en': '',
    },
    'py06weq5': {
      'es': 'Inventario',
      'en': '',
    },
    'r8300boh': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'hubeb2y2': {
      'es': 'Número de inventario',
      'en': 'Post Title',
    },
    'si63phmj': {
      'es': 'Número de inventario del Bien',
      'en': '',
    },
    'cmne5u5b': {
      'es': 'Importe',
      'en': '',
    },
    '5dbv32qq': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'nhdx1xgu': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'hf3unr2z': {
      'es': 'Importe del bien',
      'en': '',
    },
    'cfxf2afe': {
      'es': 'Titular',
      'en': '',
    },
    'r4cqrhex': {
      'es': 'Titular del bien',
      'en': 'Title',
    },
    '3zq58lqf': {
      'es': 'Nombre del titular',
      'en': 'Post Title',
    },
    'hqjt8kaa': {
      'es': 'SIN TITULAR INICIAL',
      'en': '',
    },
    'tr7syfgk': {
      'es': 'Option 1',
      'en': '',
    },
    'k0f4hnz6': {
      'es': 'Nombre del titular del bien',
      'en': '',
    },
    'crrmfqjw': {
      'es': 'Depositario',
      'en': '',
    },
    't8wktuqc': {
      'es': 'Depositario',
      'en': 'Title',
    },
    'r2roey75': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    '0tzmpuns': {
      'es': 'SIN DEPOSITARIO INICIAL',
      'en': '',
    },
    'ybp84f3o': {
      'es': 'Option 1',
      'en': '',
    },
    'kof053oh': {
      'es': 'Nombre de depositario del Bien',
      'en': '',
    },
    'o2rrv45q': {
      'es': 'Encargado',
      'en': '',
    },
    '7ylokmza': {
      'es': 'Nombre del encargado',
      'en': 'Title',
    },
    'mlw6hgql': {
      'es': 'Nombre del encargado',
      'en': 'Post Title',
    },
    'tpofr54p': {
      'es': 'SIN ENCARGADO INICIAL',
      'en': '',
    },
    '3qkd1hke': {
      'es': 'Option 1',
      'en': '',
    },
    'ioo9lwp6': {
      'es': 'Nombre del encargado del bien',
      'en': '',
    },
    'gwpbjurg': {
      'es': 'Verifica vs',
      'en': '',
    },
    '16wvv18v': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    'wo1wnjvl': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'aeva0g1c': {
      'es': 'Search...',
      'en': '',
    },
    '9y345y3r': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    '3enld8p2': {
      'es': 'RESGUARDO INDIVIDUAL',
      'en': '',
    },
    'kx4ktpvt': {
      'es': 'OTRO',
      'en': '',
    },
    'ozug7cyo': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    'ctogq64g': {
      'es': 'Resguardo',
      'en': '',
    },
    '8e6x1db4': {
      'es': 'Folio resguardo',
      'en': 'Title',
    },
    'zmjd6xte': {
      'es': 'Folio resguardo',
      'en': 'Post Title',
    },
    'p0ty0w2x': {
      'es': 'Número de folio de resguardo',
      'en': '',
    },
    'sqorifwb': {
      'es': 'Documento cotejo',
      'en': '',
    },
    'pwp3ctgj': {
      'es': 'FACTURA',
      'en': '',
    },
    'z7esomq3': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'vxov2cs4': {
      'es': 'Search...',
      'en': '',
    },
    'g4nj8wf2': {
      'es': 'FACTURA',
      'en': '',
    },
    'kzitqisx': {
      'es': 'RESGUARDO',
      'en': '',
    },
    'zlb89xvt': {
      'es': 'OFICIO',
      'en': '',
    },
    '9bue00se': {
      'es': 'LISTADO ELECTRONICO',
      'en': '',
    },
    'whtn18w2': {
      'es': 'RELACION',
      'en': '',
    },
    'zwbrcnes': {
      'es': 'NINGUNO',
      'en': '',
    },
    'gyfj35kl': {
      'es': 'OTRO',
      'en': '',
    },
    'v1i8yvky': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    '2p2hdap6': {
      'es': 'Ejercicio',
      'en': '',
    },
    's20rxdlm': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    '9chbudkc': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    '3qgj2op6': {
      'es': '2025',
      'en': '',
    },
    'lxfq4nzr': {
      'es': 'Año fiscal',
      'en': '',
    },
    'kjxfv39n': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'mtiwjtin': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'nm9awmkk': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    '4ynh5ccp': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    'qo8a3ukn': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    'dcclx7jz': {
      'es': 'Option 1',
      'en': '',
    },
    'e7whvg1y': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    '7ztgobgg': {
      'es': 'Factura',
      'en': '',
    },
    'gmi2jxja': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    'aiqecefp': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'uanxq0m7': {
      'es': 'Option 1',
      'en': '',
    },
    'jira8n4n': {
      'es': 'Factura',
      'en': '',
    },
    '5ivcvnkj': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '25jh7cks': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    'ofw07yf2': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    'wpg82hmt': {
      'es': 'Option 1',
      'en': '',
    },
    'c66e10uq': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '92y0fx6b': {
      'es': 'Tipo de recurso',
      'en': '',
    },
    'xo482hq6': {
      'es': 'Tipo de recurso',
      'en': 'Title',
    },
    'w9um1gwr': {
      'es': 'Tipo de recurso',
      'en': 'Post Title',
    },
    'muble8q0': {
      'es': 'PRESUPUESTAL',
      'en': '',
    },
    'oknihjgi': {
      'es': 'Option 1',
      'en': '',
    },
    'fn4ut5t7': {
      'es': 'Tipo de recurso',
      'en': '',
    },
    '5bi6r9rp': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'uj7i6rs7': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'niqwuyi9': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'xwomk8p0': {
      'es': 'Option 1',
      'en': '',
    },
    'jyn9jkas': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'gnjus304': {
      'es': 'Marca comercial',
      'en': '',
    },
    'ea5crah3': {
      'es': 'Marca',
      'en': 'Title',
    },
    'tqpjhskh': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    'ac2z7uxf': {
      'es': 'Option 1',
      'en': '',
    },
    'kuhr1pxi': {
      'es': 'Marca',
      'en': '',
    },
    '6s2ph6i7': {
      'es': 'Clase de activo (Depreciación)',
      'en': '',
    },
    'v29ruf67': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'wxpv5znw': {
      'es': 'Clase de activo (Depreciación)',
      'en': 'Post Title',
    },
    'nn5b6z96': {
      'es': 'Option 1',
      'en': '',
    },
    '5uql9icd': {
      'es': 'Clase de activo',
      'en': '',
    },
    '5oi6wma4': {
      'es': '¿El bien es contable?',
      'en': '',
    },
    'a8ozi7hd': {
      'es': 'Estado del bien',
      'en': '',
    },
    '082uheeg': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'sqsd1t7l': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    'a2ydz525': {
      'es': 'Search...',
      'en': '',
    },
    'ni2lhxjm': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'b1mr0cvn': {
      'es': 'REGULAR',
      'en': '',
    },
    '0qxmasw5': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    'x1uah2uc': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'o3bxkj5t': {
      'es': 'Estado del bien',
      'en': '',
    },
    'nunay4d9': {
      'es': 'Color del bien',
      'en': '',
    },
    '02q13wrd': {
      'es': 'Color',
      'en': 'Title',
    },
    '8gxxm7hn': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'wby8bkve': {
      'es': 'Option 1',
      'en': '',
    },
    'a1fuznm1': {
      'es': 'Color',
      'en': '',
    },
    'rbqochb3': {
      'es': 'Categoría',
      'en': '',
    },
    'b52smiwu': {
      'es': 'Categoría',
      'en': 'Title',
    },
    '0v9nh8ur': {
      'es': 'Categoría',
      'en': 'Post Title',
    },
    '0qnh8qxy': {
      'es': 'Option 1',
      'en': '',
    },
    'jrwac2im': {
      'es': 'Categoría',
      'en': '',
    },
    'bjx860o2': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'yzk77qz7': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'dvnd07fm': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    'k7at7cap': {
      'es': 'Option 1',
      'en': '',
    },
    'nzdyberv': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'mj0cmvhb': {
      'es': 'Licitación',
      'en': '',
    },
    'hs2bkphy': {
      'es': 'Licitación',
      'en': 'Title',
    },
    '0p70y93j': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    'esaxw3i0': {
      'es': 'Option 1',
      'en': '',
    },
    'xxd7gqn5': {
      'es': 'Licitación',
      'en': '',
    },
    'ai7qfmjq': {
      'es': 'Inmueble',
      'en': '',
    },
    '3nwiy2u2': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    'amejx5dg': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    '1jj7v7yv': {
      'es': 'Almacén general',
      'en': '',
    },
    'ht6q3sxk': {
      'es': 'Option 1',
      'en': '',
    },
    'jxhauyjg': {
      'es': 'Inmueble',
      'en': '',
    },
    'hbgatbxr': {
      'es': 'Modelo',
      'en': '',
    },
    '031e24z5': {
      'es': 'Modelo',
      'en': 'Title',
    },
    '96e1e5z6': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    'rpzzyznt': {
      'es': 'Option 1',
      'en': '',
    },
    'eo2khau8': {
      'es': 'Modelo',
      'en': '',
    },
    'porae8zm': {
      'es': 'Placa',
      'en': '',
    },
    'euwte4on': {
      'es': 'Placa',
      'en': 'Title',
    },
    'kl1hul6d': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    'lrhn1omp': {
      'es': 'Placa',
      'en': '',
    },
    'ks26l35q': {
      'es': 'Dsitrito',
      'en': '',
    },
    'd4x9cgn1': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    'sh8jkwze': {
      'es': 'Search...',
      'en': '',
    },
    'yyyhbj5j': {
      'es': 'Xalapa',
      'en': '',
    },
    'pecvplr5': {
      'es': 'Distrito',
      'en': '',
    },
    'a8f6uvi8': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'zqx2ott9': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    '4dm697cu': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    'a2wt32vd': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'peppdaev': {
      'es': 'Ubicación específica',
      'en': '',
    },
    '5852abie': {
      'es': 'Zona',
      'en': 'Title',
    },
    'bvxhi74j': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    'eioj6wom': {
      'es': 'CE',
      'en': '',
    },
    'hcaxf6m1': {
      'es': 'Option 1',
      'en': '',
    },
    'vek4vd66': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    'healmkef': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'oilf9o3y': {
      'es': 'No aplica',
      'en': '',
    },
    'k4gcjn58': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '76z7pgq9': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'hav607nw': {
      'es': 'No aplica',
      'en': '',
    },
    '9ak0ado3': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    '9pbg02nd': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'p1a5s855': {
      'es': 'No aplica',
      'en': '',
    },
    '7jv43691': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'irmjgx2l': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    '3atjlvea': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    's95qimnx': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'bjf3surc': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    'l158f5s4': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    'ynxkrqlv': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    'm3rg7why': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    'd1vme3og': {
      'es': 'Crear',
      'en': 'Save',
    },
    '2xn3zgds': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Home
  {
    '0onzc6wr': {
      'es': 'Almacen',
      'en': '',
    },
    'cyrxb5p3': {
      'es': 'Activos',
      'en': '',
    },
    'vmkc5qik': {
      'es': 'Reporte Gral.',
      'en': '',
    },
    'oxk8h2fr': {
      'es': 'Libro de Invent.',
      'en': '',
    },
    '54e9c694': {
      'es': 'Avalúos',
      'en': '',
    },
    'm04pwvgu': {
      'es': 'Depreciación',
      'en': '',
    },
    'lgakppu1': {
      'es': 'Dep. Acum.',
      'en': '',
    },
    'b2nr2b1i': {
      'es': 'Descarga Excel',
      'en': '',
    },
    'i7cwfg4k': {
      'es': 'Depreciación',
      'en': '',
    },
    'plx2zuif': {
      'es': 'Anexos',
      'en': '',
    },
    'l1lp6f6q': {
      'es': 'Trans. Masiva',
      'en': '',
    },
    '6d2e5o9v': {
      'es': 'Siprofev',
      'en': '',
    },
    'e8g5i7aa': {
      'es': 'Usuarios',
      'en': '',
    },
    'lvpstzel': {
      'es': 'Catálogos',
      'en': '',
    },
    'wgc0743i': {
      'es': 'Niveles de Organización',
      'en': '',
    },
    '324z2c68': {
      'es': 'Depositarios',
      'en': '',
    },
    't6we2c1d': {
      'es': 'Clase de Activo',
      'en': '',
    },
    'r7dqjude': {
      'es': 'Distritos',
      'en': '',
    },
    'oynp1b91': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'nm2o3jap': {
      'es': 'Vers. 2.0.0',
      'en': '',
    },
    'i7n5pdjb': {
      'es': 'Sistema de control de inventarios del PJEV',
      'en': '',
    },
    '3fz66tcb': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    'hr0y0ptf': {
      'es': 'Vale de Movimiento',
      'en': '',
    },
    'ciw47xdr': {
      'es': 'Lista de Vales',
      'en': '',
    },
    'q2eyoa3e': {
      'es': 'Crear Nuevo Bien',
      'en': '',
    },
    '06pun2c4': {
      'es': 'Subir Cárdex',
      'en': '',
    },
    'j1p12bym': {
      'es': 'Buscar por 2 Nivel',
      'en': '',
    },
    'nj56qb6t': {
      'es': 'Ir a Anexos',
      'en': '',
    },
    'py5ec0o9': {
      'es': 'Buscar por ID-Anterior',
      'en': '',
    },
    'y1kr7my7': {
      'es': 'Etiquetas',
      'en': '',
    },
    'ivlvh3wu': {
      'es': 'Buscar Bien',
      'en': '',
    },
    'ja63m8xb': {
      'es': 'Editar Anexo',
      'en': '',
    },
    'kjambemc': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Baja
  {
    '3zbf0b3f': {
      'es': 'Regresar',
      'en': '',
    },
    'qsas2ha3': {
      'es': 'ASIGNAR FOLIO DE CONTROL DE VALES DE MOVIMIENTOS',
      'en': '',
    },
    'jgb057vz': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'kg4bg1nq': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'wxjhgkyr': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'ssbvab33': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'ajyb8xth': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    'fne5t2lw': {
      'es': 'Nombre de quien solicita el movimiento',
      'en': 'Post Title',
    },
    'q7ad0ssd': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    'uc1s5uiu': {
      'es': '',
      'en': '',
    },
    '7mevksh7': {
      'es': 'Seleccionar',
      'en': 'Title',
    },
    'rjazap2b': {
      'es': 'Search...',
      'en': '',
    },
    'l0m9l0th': {
      'es': 'ALTA',
      'en': '',
    },
    'cjjmopkh': {
      'es': 'BAJA',
      'en': '',
    },
    'vhj1o8y0': {
      'es': 'REPOSICION',
      'en': '',
    },
    'n7phdf19': {
      'es': 'TRANSFERENCIA',
      'en': '',
    },
    'x6wftsen': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    'u2ymaq52': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'b9wx74s4': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '3vxbujnt': {
      'es': 'Option 1',
      'en': '',
    },
    '77h9unne': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'tctvet7d': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'omz5i2tw': {
      'es': 'Option 1',
      'en': '',
    },
    'gyij6nn1': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'xf0bpl6p': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'beod23mm': {
      'es': 'Option 1',
      'en': '',
    },
    'oxxc8qhb': {
      'es': 'ID',
      'en': '',
    },
    '7parsyy1': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'outgcfnm': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'v9v0rg0o': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'jdhguck7': {
      'es': 'Importe',
      'en': '',
    },
    '1tviv4kb': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'fp23diam': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'o7b1e1ny': {
      'es': 'Importe del bien',
      'en': '',
    },
    'xowpcrz4': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'ra281cfp': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    '0ox1lq2i': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'd8j4jhhd': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'ozlhyaue': {
      'es': 'Depositario',
      'en': '',
    },
    'wulhoe9r': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'tk9dotta': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    '0rjv429p': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'wy9l6wrz': {
      'es': 'Usuario',
      'en': '',
    },
    '5w8xp0v7': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'uwxi9lt6': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    '7ygvapog': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'i94vdzzx': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '6lgc0gbw': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    '5n78tvc0': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'zseslkvu': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    's1wzyzsp': {
      'es': 'Estado del bien',
      'en': '',
    },
    '2zzolqt1': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    '3honar31': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    '5gtz8vxk': {
      'es': 'Search...',
      'en': '',
    },
    'kqau6hv3': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    '480b4tv8': {
      'es': 'REGULAR',
      'en': '',
    },
    '9c8hwiix': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    'j0bhe1vh': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    '45euv5d3': {
      'es': 'Estado del bien',
      'en': '',
    },
    'yd55egch': {
      'es': 'GENERAR MOVIMIENTO',
      'en': 'Save',
    },
    'leenua0i': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Vales
  {
    'yqaail92': {
      'es': 'Inicio',
      'en': '',
    },
    'tq5p810b': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '7sed8bd3': {
      'es': 'Vers. 1.8.5',
      'en': '',
    },
    'iskt8jra': {
      'es': 'Archivo de vales de movimiento de bienes',
      'en': '',
    },
    'yu7d01h3': {
      'es': 'Buscar por folio',
      'en': '',
    },
    'kkofoxi2': {
      'es': 'Agregar nuevo vale',
      'en': '',
    },
    'e7q62b7a': {
      'es': 'Folio del vale',
      'en': '',
    },
    '2xusnf58': {
      'es': 'Fecha',
      'en': '',
    },
    'xvrr24no': {
      'es': 'Tipo de vale',
      'en': '',
    },
    'w7po941w': {
      'es': 'Nombre quien realiza',
      'en': '',
    },
    'plqivjng': {
      'es': 'Estado',
      'en': '',
    },
    'qtuk5xzx': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Verbien
  {
    'rium8shv': {
      'es': 'Regresar',
      'en': '',
    },
    '3or22p0h': {
      'es': 'ESTADO DEL BIEN: ',
      'en': '',
    },
    'gt22bfq7': {
      'es': 'ID',
      'en': '',
    },
    '10r0he8h': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'mp5fyakj': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'fu7c4xs8': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'a1xq0ynf': {
      'es': 'ID anterior',
      'en': '',
    },
    'kud88u3h': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    'n0rd7fvb': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    'lbbgay68': {
      'es': 'Número de ID anterior del bien',
      'en': '',
    },
    'zbu5el8t': {
      'es': 'Importe',
      'en': '',
    },
    'xev4rrzc': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    '38tgjxka': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'imjeh8r7': {
      'es': 'Importe del bien',
      'en': '',
    },
    'o6nsqnq4': {
      'es': 'Avalúo',
      'en': '',
    },
    'ufh6u4js': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Title',
    },
    'ig4rza5y': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Post Title',
    },
    '8w4s8hxf': {
      'es': 'Importe del avalúo',
      'en': '',
    },
    'k9g0zaze': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'f5qmlhvi': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'so89eho7': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'il4ozjma': {
      'es': 'Option 1',
      'en': '',
    },
    'kwkwbpj8': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'orgt0gol': {
      'es': 'Depositario',
      'en': '',
    },
    'fm4ltmo9': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'na3s2xpu': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'ku04m5xd': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'yniokqu0': {
      'es': 'Usuario',
      'en': '',
    },
    'lm8z17qy': {
      'es': 'Usuario',
      'en': 'Title',
    },
    '45y06p5c': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'sj5f18ln': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'i4755dbo': {
      'es': 'Origen del recurso',
      'en': '',
    },
    '0qeqip85': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'du79b3gc': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    'p6kfbfcr': {
      'es': 'Option 1',
      'en': '',
    },
    '0pwz8hzt': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'cw74ggui': {
      'es': 'Verifica vs',
      'en': '',
    },
    'mwaws3la': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    '14d05i8h': {
      'es': 'Search...',
      'en': '',
    },
    'en2kkw5x': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    '1yf9gl15': {
      'es': 'Documento cotejo',
      'en': '',
    },
    'e3ekkgge': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'gz8yot4w': {
      'es': 'Search...',
      'en': '',
    },
    'stcq2p2s': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    'q3iqhxgw': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'jzkjr78r': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'u6pmojw4': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'cw20uefx': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'j773cp84': {
      'es': 'Ejercicio',
      'en': '',
    },
    'ubfmttyv': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    'ckjk3pb3': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    '749349xu': {
      'es': 'Año fiscal',
      'en': '',
    },
    '86n762zb': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    '06ovqhem': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    '66djybfp': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    '80ey3uwm': {
      'es': 'Option 1',
      'en': '',
    },
    'tmluab2m': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'nueh0a3c': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'js9g0b7n': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    'wzulkpqa': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    'u905rx13': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'jr5qxoor': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'x9i4z2i4': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '4jvqx615': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    'sybkqlzc': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    '7crptfy9': {
      'es': 'Option 1',
      'en': '',
    },
    '10seiezn': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'qgajywua': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'cb7m8jqj': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'dsyxonoq': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'gemjhiup': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'amn967ar': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'dszk6nhv': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '46ivy1bl': {
      'es': 'Marca comercial',
      'en': '',
    },
    'p2225okt': {
      'es': 'Marca',
      'en': 'Title',
    },
    '92d74y7p': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    'lv8wxi8h': {
      'es': 'Option 1',
      'en': '',
    },
    'sr0ocz54': {
      'es': 'Marca',
      'en': '',
    },
    'olrrs2dn': {
      'es': 'Factura',
      'en': '',
    },
    'nzdaw56b': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    '6y1cpr5j': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    '10fukw9a': {
      'es': 'Option 1',
      'en': '',
    },
    '8njbq0ph': {
      'es': 'Factura',
      'en': '',
    },
    'ksa1l35a': {
      'es': 'Clase de activo (Depreciación)',
      'en': '',
    },
    'z6js697d': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'kl88dxbz': {
      'es': 'Clase de activo',
      'en': 'Post Title',
    },
    'f9rokcoq': {
      'es': 'Clase de activo',
      'en': '',
    },
    '1r99wrau': {
      'es': 'Estado del bien',
      'en': '',
    },
    'lhagw3dt': {
      'es': 'Search...',
      'en': '',
    },
    'z0ufzoi9': {
      'es': 'Estado del bien',
      'en': '',
    },
    'n9iyncs3': {
      'es': 'Color del bien',
      'en': '',
    },
    '0t1ckkqr': {
      'es': 'Color',
      'en': 'Title',
    },
    'kuqc9yex': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'yg5wcc0t': {
      'es': 'Option 1',
      'en': '',
    },
    'rrncgvtz': {
      'es': 'Color',
      'en': '',
    },
    '4n98rp80': {
      'es': 'Modelo',
      'en': '',
    },
    'pxd19kea': {
      'es': 'Modelo',
      'en': 'Title',
    },
    'jqpq8wn9': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    'u7abqm29': {
      'es': 'Option 1',
      'en': '',
    },
    'ptybqzb4': {
      'es': 'Modelo',
      'en': '',
    },
    'izyowc1p': {
      'es': 'Placa',
      'en': '',
    },
    'se720u3d': {
      'es': 'Placa',
      'en': 'Title',
    },
    'yznix9vy': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    '6qibtr5o': {
      'es': 'Placa',
      'en': '',
    },
    'zgslpdrn': {
      'es': 'Dsitrito',
      'en': '',
    },
    'rw2f4pfc': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    '3ewaxtv0': {
      'es': 'Search...',
      'en': '',
    },
    'yyb2tbww': {
      'es': 'Distrito',
      'en': '',
    },
    'bsxiegsb': {
      'es': 'Licitación',
      'en': '',
    },
    'm7yvoxrh': {
      'es': 'Licitación',
      'en': 'Title',
    },
    '404b3eg6': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    'gnb3p527': {
      'es': 'Option 1',
      'en': '',
    },
    'fn4w7dzl': {
      'es': 'Licitación',
      'en': '',
    },
    'p9g2eyce': {
      'es': 'Categoría',
      'en': '',
    },
    'nube0vo8': {
      'es': 'Categoría',
      'en': 'Title',
    },
    '5uzlc1p0': {
      'es': 'Categoría',
      'en': 'Post Title',
    },
    'c0fy754f': {
      'es': 'Option 1',
      'en': '',
    },
    'qdy1fu6r': {
      'es': 'Categoría',
      'en': '',
    },
    '8588tyom': {
      'es': 'Inmueble',
      'en': '',
    },
    '3zeypwh4': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    'aqy5qa1i': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    '84908gww': {
      'es': 'Option 1',
      'en': '',
    },
    'cswkfndu': {
      'es': 'Inmueble',
      'en': '',
    },
    'znv5r06t': {
      'es': 'Zona',
      'en': 'Title',
    },
    've4cq25e': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    'b45jskyj': {
      'es': 'Option 1',
      'en': '',
    },
    '5a5ykebd': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    'rbccltyw': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'ko65u788': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '75ur9srn': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'u7kimh0y': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    'r47c286o': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'xvt6lv3q': {
      'es': 'No aplica',
      'en': '',
    },
    'q2wldr2t': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'q65dbzla': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'e0uv2mrn': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'on9cmx2u': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '6ouotavo': {
      'es': 'Imagen del bien',
      'en': '',
    },
    '1uggtpfz': {
      'es': 'Imagen del bien',
      'en': '',
    },
    '9mdq8i0h': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    'lkciws36': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    '0etk5rhn': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    'ysutxucd': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    'hp83uk3t': {
      'es': 'Editar',
      'en': 'Save',
    },
    'gxb20llm': {
      'es': 'ID no localizado. Regresar',
      'en': '',
    },
    'or54369s': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // AltaRepTransMant
  {
    '8yd0rv66': {
      'es': 'Regresar',
      'en': '',
    },
    '2mb4pjmg': {
      'es': 'ASIGNAR FOLIO PARA CONTROL DE VALES DE MOVIMIENTO DE BIENES',
      'en': '',
    },
    '6afbbcm7': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'z5wpbwbu': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'vax4japl': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    '6y6v5pav': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'owvz997h': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    '3mgx9tql': {
      'es': 'Nombre de quien solicita',
      'en': 'Post Title',
    },
    '84bxg4h8': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    '54kjnuzu': {
      'es': '',
      'en': '',
    },
    'yhvfk6aw': {
      'es': 'TIPO',
      'en': 'Title',
    },
    '38fljalc': {
      'es': 'Search...',
      'en': '',
    },
    'z4gkxb10': {
      'es': 'ALTA',
      'en': '',
    },
    'onhw5lk9': {
      'es': 'REPOSICION',
      'en': '',
    },
    'hry2p5ym': {
      'es': 'TRANSFERENCIA',
      'en': '',
    },
    'gocbvuwp': {
      'es': 'ID',
      'en': '',
    },
    'snhqr8lo': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'ena1ztdf': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    's2ytcfy7': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'ot8jjnw6': {
      'es': 'Importe',
      'en': '',
    },
    'c42r5qqr': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    '21kkwzp8': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    '4pvl33mh': {
      'es': 'Importe del bien',
      'en': '',
    },
    'c0gvuitn': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'rvn2ll55': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'rntptkoh': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'd0c83oco': {
      'es': 'Option 1',
      'en': '',
    },
    'gg1jul79': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '3m0qy20e': {
      'es': 'Depositario',
      'en': '',
    },
    'bmb9edbt': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'lvcaa4wr': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'c3e52o8a': {
      'es': 'Option 1',
      'en': '',
    },
    'dvtzp6zt': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    '3oj2rk3u': {
      'es': 'Usuario',
      'en': '',
    },
    'o274k7z8': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'qbih8usk': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'y3on31rd': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    '67i1jkbt': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '24wew79x': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'ktjc23m2': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    '98yb7sh0': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'tr1qxntc': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    'tisxz4iz': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // MantenimientoVale
  {
    'rja322q5': {
      'es': 'Regresar',
      'en': '',
    },
    'd5r3w4m2': {
      'es':
          'ASIGNAR FOLIO PARA CONTROL DE VALES DE MOVIMIENTO DE MANTENIMIENTO',
      'en': '',
    },
    'de1i3var': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'wyjtbile': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'gysart7a': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'akl8bkdw': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'trynk5e0': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    'bpkuoo3k': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'b5ahydx3': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    'san19sym': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    'eulfq1ze': {
      'es': 'MANTENIMIENTO',
      'en': 'Title',
    },
    '1oaar1h2': {
      'es': 'Search...',
      'en': '',
    },
    'fbh9lk7f': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    'c48trhdu': {
      'es': 'ID',
      'en': '',
    },
    '1p84a55x': {
      'es': 'Inventario',
      'en': 'Title',
    },
    '4wc3nezq': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    '4an0heki': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'yn0y5650': {
      'es': 'Importe',
      'en': '',
    },
    '5xwvzyqb': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'jemhu53a': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'kp3l10cn': {
      'es': 'Importe del bien',
      'en': '',
    },
    'h63bev1o': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '20r3ltaz': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'cug127fo': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'pnd448eo': {
      'es': 'Option 1',
      'en': '',
    },
    'r2fiawxx': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '3xprqf21': {
      'es': 'Depositario',
      'en': '',
    },
    'uurxw18f': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    '2r73dud6': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    '9s1if98m': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    '3o5shnhw': {
      'es': 'Usuario',
      'en': '',
    },
    '3j68vra8': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'lsdus7hl': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'wumqw4tv': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    '6alc37bn': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '8ocgd4h2': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'kegon1gi': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    '5qdfkasp': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'c17x7urf': {
      'es': 'MANTENIMIENTO',
      'en': 'Save',
    },
    'nmdfvfe6': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Transferencia
  {
    'x2m416i4': {
      'es': 'Regresar',
      'en': '',
    },
    'cznyyz88': {
      'es': 'ASIGNAR FOLIO PARA CONTROL DE VALES DE MOVIMIENTO DE BIENES',
      'en': '',
    },
    '2en3et4l': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'p3l0ok5v': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'ms5nlc4h': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'xop7dj42': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'g1j6yatm': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    'qedb4zly': {
      'es': 'Nombre de quien solicita',
      'en': 'Post Title',
    },
    'eu0g13z6': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    'sghhbv5o': {
      'es': '',
      'en': '',
    },
    'v4ztgkq9': {
      'es': 'TIPO DE VALE',
      'en': 'Title',
    },
    'frk8rgn1': {
      'es': 'Search...',
      'en': '',
    },
    '9av8ozn6': {
      'es': 'REPOSICION',
      'en': '',
    },
    'tndsftsl': {
      'es': 'TRANSFERENCIA',
      'en': '',
    },
    'p2lxq3ym': {
      'es': 'ALTA',
      'en': '',
    },
    '452wx7nr': {
      'es': 'BAJA',
      'en': '',
    },
    'hrvgiac6': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    'wle52ww6': {
      'es': 'ID',
      'en': '',
    },
    'qngtw20c': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'v7lfcduk': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    '3czhq4jn': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'm7omqp83': {
      'es': 'Importe',
      'en': '',
    },
    'robmgyy3': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    '0x3mp1l4': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'lxlm9isq': {
      'es': 'Importe del bien',
      'en': '',
    },
    'sw9r5fzg': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'ol110luq': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'sk5yoo94': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'oid3g8or': {
      'es': 'Option 1',
      'en': '',
    },
    'icyo97nr': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '9jsdy25f': {
      'es': 'Depositario',
      'en': '',
    },
    'qpoqyl4f': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'jnjz415h': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'ighl3bba': {
      'es': 'Option 1',
      'en': '',
    },
    'vnbhjnl0': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'ek4qnka3': {
      'es': 'Usuario',
      'en': '',
    },
    '03jl401u': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'apm9ufw2': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'c0mby8j8': {
      'es': 'Option 1',
      'en': '',
    },
    '2sp7hcmh': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'f6cwfhuq': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'do2l5xal': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'fbuqprk2': {
      'es': 'Option 1',
      'en': '',
    },
    '89my7ozh': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'hb2rfsyw': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'uc5vozmr': {
      'es': 'Option 1',
      'en': '',
    },
    '83o1o1mb': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '3sbexst9': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '5c84m9ce': {
      'es': 'Option 1',
      'en': '',
    },
    '62jl06zd': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'k1v2aryy': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    't42ak3yx': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'zsiuq8zm': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '9ylzf6ts': {
      'es': 'Estado del bien',
      'en': '',
    },
    'cpm5gl85': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'a96xzy1u': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    'j9h1gytk': {
      'es': 'Search...',
      'en': '',
    },
    'y095yc3c': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'xus83i1q': {
      'es': 'REGULAR',
      'en': '',
    },
    'fls3z334': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    '224dcxvh': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'mvjtnmu8': {
      'es': 'Estado del bien',
      'en': '',
    },
    'c6njgama': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    'u51ie7jd': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // VerbienCopy
  {
    'v5y093ay': {
      'es': 'Regresar',
      'en': '',
    },
    '636x1iyo': {
      'es': 'ESTADO DEL BIEN: ',
      'en': '',
    },
    '0jithk8l': {
      'es': 'ID',
      'en': '',
    },
    'fx9mhn1m': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'zp6qnnbj': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    '64ygb481': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    '0a0bd2ka': {
      'es': 'Importe',
      'en': '',
    },
    'sc7lqmz0': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'h4dhtayn': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'dmhsiias': {
      'es': 'Importe del bien',
      'en': '',
    },
    '6bh8jsmd': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'ud2jybvf': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    '0tdxn26f': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'zmcdgd30': {
      'es': 'Option 1',
      'en': '',
    },
    'jo3hzr1m': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'f3m2xkls': {
      'es': 'Depositario',
      'en': '',
    },
    'h8red9ty': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'gdbly81q': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    '2mkx33si': {
      'es': 'Option 1',
      'en': '',
    },
    '2qk67sh0': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'la4is2zn': {
      'es': 'Usuario',
      'en': '',
    },
    'yxjm8jd1': {
      'es': 'Usuario',
      'en': 'Title',
    },
    '3gwzmjuf': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    '7zk7hu40': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'ixmiwikg': {
      'es': 'Verifica vs',
      'en': '',
    },
    'cz8o79ob': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'xx1k3ee1': {
      'es': 'Search...',
      'en': '',
    },
    'en8yln90': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    '1bd69r39': {
      'es': 'RESGUARDO INDIVIDUAL',
      'en': '',
    },
    'q7dv34pb': {
      'es': 'OTRO',
      'en': '',
    },
    '3ng5e8bw': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    'z6f1aevu': {
      'es': 'Resguardo',
      'en': '',
    },
    'm3ba5ep6': {
      'es': 'Folio resguardo',
      'en': 'Title',
    },
    'k9ojua6t': {
      'es': 'Folio resguardo',
      'en': 'Post Title',
    },
    'cwm6hceq': {
      'es': 'Número de folio de resguardo',
      'en': '',
    },
    'wdyxo2di': {
      'es': 'Documento cotejo',
      'en': '',
    },
    'jg4lm08p': {
      'es': 'FACTURA',
      'en': '',
    },
    '37dvb47u': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'ic5aiys4': {
      'es': 'Search...',
      'en': '',
    },
    'je1ira30': {
      'es': 'FACTURA',
      'en': '',
    },
    'noj58cnk': {
      'es': 'RESGUARDO',
      'en': '',
    },
    'n1c2le5d': {
      'es': 'OFICIO',
      'en': '',
    },
    'w441mgpi': {
      'es': 'LISTADO ELECTRONICO',
      'en': '',
    },
    '27p08co1': {
      'es': 'RELACION',
      'en': '',
    },
    'mpsfv9p7': {
      'es': 'NINGUNO',
      'en': '',
    },
    '74dmqkqr': {
      'es': 'OTRO',
      'en': '',
    },
    'ydw3g3uz': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    'ryxst2pw': {
      'es': 'Ejercicio',
      'en': '',
    },
    '0jzyc5cq': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    'hdxxpapz': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    '7v5b7pmt': {
      'es': 'Año fiscal',
      'en': '',
    },
    '6zzdo1np': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    '3dihszvr': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'jjamrsif': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    'oyg8j1d5': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    'dd5r5lll': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    '4w1qzrpt': {
      'es': 'Option 1',
      'en': '',
    },
    'eazymewh': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'gq6w7otg': {
      'es': 'Factura',
      'en': '',
    },
    'nv4dq0gn': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    'qv2skd82': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'sa10gshr': {
      'es': 'Option 1',
      'en': '',
    },
    '9kzp62vt': {
      'es': 'Factura',
      'en': '',
    },
    'wru3p7da': {
      'es': 'Marca comercial',
      'en': '',
    },
    '9h3qz0jv': {
      'es': 'Marca',
      'en': 'Title',
    },
    'vhgor4od': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    '2lf50se7': {
      'es': 'Option 1',
      'en': '',
    },
    'c6301d6h': {
      'es': 'Marca',
      'en': '',
    },
    'l5ljwuvj': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'jffh7od4': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    '9d6s5o8q': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    'eixeki1q': {
      'es': 'Option 1',
      'en': '',
    },
    'aapfbmvl': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'z99g9gdg': {
      'es': 'Clase de activo (Depreciación)',
      'en': '',
    },
    '4lv7f5ql': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'kg1l2rlt': {
      'es': 'Clase de activo',
      'en': 'Post Title',
    },
    'sem9jgjk': {
      'es': 'Option 1',
      'en': '',
    },
    'q3h14k56': {
      'es': 'Clase de activo',
      'en': '',
    },
    'antgq4me': {
      'es': 'Estado del bien',
      'en': '',
    },
    'xc62izwr': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    'nwyrq63v': {
      'es': 'Search...',
      'en': '',
    },
    '61iazqm3': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'toc83wau': {
      'es': 'REGULAR',
      'en': '',
    },
    'e3wtd6qe': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    '3qxos9bd': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'vsq8202t': {
      'es': 'Estado del bien',
      'en': '',
    },
    'baem12u6': {
      'es': 'Color del bien',
      'en': '',
    },
    'adcc6qms': {
      'es': 'Color',
      'en': 'Title',
    },
    'x84kzhg8': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'ddh377ut': {
      'es': 'Option 1',
      'en': '',
    },
    'wwd5ysoc': {
      'es': 'Color',
      'en': '',
    },
    'pnoer9w1': {
      'es': 'Categoría',
      'en': '',
    },
    'uckjcm1w': {
      'es': 'Categoría',
      'en': 'Title',
    },
    'tkacrlog': {
      'es': 'Categoría',
      'en': 'Post Title',
    },
    '4slrvbm0': {
      'es': 'Option 1',
      'en': '',
    },
    '9oqn1l63': {
      'es': 'Categoría',
      'en': '',
    },
    'wp0qikp8': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'qv3rqe1m': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'fqq58wj1': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    'vdcx2ag9': {
      'es': 'Option 1',
      'en': '',
    },
    '3tv46nd8': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'wen9b1i3': {
      'es': 'Licitación',
      'en': '',
    },
    'nbi7xkl2': {
      'es': 'Licitación',
      'en': 'Title',
    },
    '8zm23ewd': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    '1bjcjls1': {
      'es': 'Option 1',
      'en': '',
    },
    'gubwytcl': {
      'es': 'Licitación',
      'en': '',
    },
    'hazj2m01': {
      'es': 'Inmueble',
      'en': '',
    },
    'uzgldwn9': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    '99wyw7i2': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    'xydjjgy9': {
      'es': 'Option 1',
      'en': '',
    },
    'yq4uve27': {
      'es': 'Inmueble',
      'en': '',
    },
    '2aexr9ez': {
      'es': 'Modelo',
      'en': '',
    },
    '0jt0sw40': {
      'es': 'Modelo',
      'en': 'Title',
    },
    'b48bf0f6': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    'pk0jer2f': {
      'es': 'Option 1',
      'en': '',
    },
    '67m9ddto': {
      'es': 'Modelo',
      'en': '',
    },
    '669rjzqo': {
      'es': 'Placa',
      'en': '',
    },
    'pwzgn2hy': {
      'es': 'Placa',
      'en': 'Title',
    },
    'hoeiexsp': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    '9u8gi8z6': {
      'es': 'Placa',
      'en': '',
    },
    'j6c5sg9d': {
      'es': 'Dsitrito',
      'en': '',
    },
    'a24xgz1m': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    '5kotwoaj': {
      'es': 'Search...',
      'en': '',
    },
    '51p95xtf': {
      'es': 'Xalapa',
      'en': '',
    },
    'lf6w5bly': {
      'es': 'Distrito',
      'en': '',
    },
    'cf2dtfj8': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'r6veq5zh': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    'yn2oh9uv': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    '2t8tz9w2': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    '45srjhtl': {
      'es': 'Ubicación específica',
      'en': '',
    },
    '5skw8vcf': {
      'es': 'Zona',
      'en': 'Title',
    },
    'shfjozyt': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    'urb14m4d': {
      'es': 'Option 1',
      'en': '',
    },
    '2pdjmubt': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    '58cmxiij': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'bi65u10z': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    'v0rqj8bo': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'eqt1b5d6': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    '61s77n84': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    '06apmuhc': {
      'es': 'No aplica',
      'en': '',
    },
    'nsn9uwqb': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '49z4r934': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'wb05f0g0': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'ptgi0tsm': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'ifvz25mn': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    '9pwltfkt': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    '3vfpwcal': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    '3aphbzzb': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    '6t8qch0s': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    'h3bntm9k': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Transferenciamasiva2
  {
    'oipsj6cu': {
      'es': 'Inicio',
      'en': '',
    },
    'fn2jnrlj': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'k02btexl': {
      'es': 'Vers. 0.8.11',
      'en': '',
    },
    'k71857f9': {
      'es': 'Activos',
      'en': '',
    },
    'azmw3412': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    'b3gmmsfq': {
      'es': 'Quitar de lista',
      'en': '',
    },
    '60wuhv9w': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Verbien2
  {
    'cqh3tnmo': {
      'es': 'Regresar',
      'en': '',
    },
    'xvrcl8k0': {
      'es': 'ESTADO DEL BIEN: ',
      'en': '',
    },
    'zo7i1ezm': {
      'es': 'ID',
      'en': '',
    },
    '7zglqvv0': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'izov9hc4': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'm3h17nj4': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    '4pe0rgaa': {
      'es': 'ID anterior',
      'en': '',
    },
    'acejfvz4': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    '0ijan4pz': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    '8vl9zy56': {
      'es': 'Número de ID anterior del bien',
      'en': '',
    },
    'n0x6wqwp': {
      'es': 'Importe',
      'en': '',
    },
    'f337azn3': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    '95c27cu8': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'aok0nz3q': {
      'es': 'Importe del bien',
      'en': '',
    },
    'er7y93ly': {
      'es': 'Avalúo',
      'en': '',
    },
    '1vw7szu9': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Title',
    },
    'vwmu5drn': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Post Title',
    },
    'n40n3efl': {
      'es': 'Importe del avalúo',
      'en': '',
    },
    'kuwvgmsj': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'mbwahehx': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'pm8grgcv': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    '2v1ulqcw': {
      'es': 'Option 1',
      'en': '',
    },
    '8dxp2p6l': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'j9eb3o8n': {
      'es': 'Depositario',
      'en': '',
    },
    '5hkg0qq2': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'ft0ox97n': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    '13kmpfkn': {
      'es': 'Option 1',
      'en': '',
    },
    'q2l9q6p3': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'q81o5so3': {
      'es': 'Usuario',
      'en': '',
    },
    'wtvi2m4z': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'tb8m8yz5': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'j32psqch': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'ds36vkix': {
      'es': 'Número de serie',
      'en': 'Title',
    },
    'av9bv9ok': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    '6mpe3q04': {
      'es': 'Verifica vs',
      'en': '',
    },
    'apy71ax0': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'cdr608fh': {
      'es': 'Search...',
      'en': '',
    },
    'x9dko3t4': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    'h98rw5al': {
      'es': 'RESGUARDO INDIVIDUAL',
      'en': '',
    },
    '2mto2zpg': {
      'es': 'OTRO',
      'en': '',
    },
    'o6lt0ptz': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    '2m0cq6j3': {
      'es': 'Documento cotejo',
      'en': '',
    },
    '72tpqmrd': {
      'es': 'FACTURA',
      'en': '',
    },
    'xs847diy': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'n8xjmrdi': {
      'es': 'Search...',
      'en': '',
    },
    '167645i3': {
      'es': 'FACTURA',
      'en': '',
    },
    'wxeqrn73': {
      'es': 'RESGUARDO',
      'en': '',
    },
    'hm991zxs': {
      'es': 'OFICIO',
      'en': '',
    },
    '8ux48cvd': {
      'es': 'LISTADO ELECTRONICO',
      'en': '',
    },
    '14sysjsm': {
      'es': 'RELACION',
      'en': '',
    },
    'jzqn9cmf': {
      'es': 'NINGUNO',
      'en': '',
    },
    'woyygsyd': {
      'es': 'OTRO',
      'en': '',
    },
    'znheqava': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    'm2pix4bx': {
      'es': 'Ejercicio',
      'en': '',
    },
    'qmdl72tj': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    'add4i66o': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    'c78arzj3': {
      'es': 'Año fiscal',
      'en': '',
    },
    'lpnrqban': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'onspoisx': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'byyvnkjx': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'rpf9uyog': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'bsf1cvxy': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    '4fiqrm0t': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    'wka3rij8': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    '9xqkb82z': {
      'es': 'Option 1',
      'en': '',
    },
    'yg2byum0': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'ybcgy1ui': {
      'es': 'Factura',
      'en': '',
    },
    '1y0jcers': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    'oeqxredg': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'vp23xeet': {
      'es': 'Option 1',
      'en': '',
    },
    'nm1hnw3v': {
      'es': 'Factura',
      'en': '',
    },
    'ikfvz0zv': {
      'es': 'Marca comercial',
      'en': '',
    },
    '94blymtf': {
      'es': 'Marca',
      'en': 'Title',
    },
    '7elw6tfd': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    'tzpdcaqc': {
      'es': 'Option 1',
      'en': '',
    },
    'g8r8md73': {
      'es': 'Marca',
      'en': '',
    },
    'nauzu7ho': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '1l745q3i': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    '4eh2rnxn': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    'up6dqxyh': {
      'es': 'Option 1',
      'en': '',
    },
    '2msqivak': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '2nxq441k': {
      'es': 'Clase de activo (Depreciación)',
      'en': '',
    },
    'rbvkq0am': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'qztiyk38': {
      'es': 'Clase de activo',
      'en': 'Post Title',
    },
    'bnoxbtpt': {
      'es': 'Option 1',
      'en': '',
    },
    'z8jzccbl': {
      'es': 'Clase de activo',
      'en': '',
    },
    'ykxxwpky': {
      'es': 'Estado del bien',
      'en': '',
    },
    'gwjv7wgi': {
      'es': 'Search...',
      'en': '',
    },
    '6z0ql2es': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    '6wogtr9t': {
      'es': 'REGULAR',
      'en': '',
    },
    'iu1fmuyi': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    'eh8oil0c': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    '18s3bexb': {
      'es': 'Estado del bien',
      'en': '',
    },
    'b8m822tg': {
      'es': 'Color del bien',
      'en': '',
    },
    'tndn1w7c': {
      'es': 'Color',
      'en': 'Title',
    },
    'aqupfgav': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'sldv8tag': {
      'es': 'Option 1',
      'en': '',
    },
    'g4u94r7n': {
      'es': 'Color',
      'en': '',
    },
    '6o3bg1kx': {
      'es': 'Categoría',
      'en': '',
    },
    'j0ofh1ez': {
      'es': 'Categoría',
      'en': 'Title',
    },
    'cdiak52v': {
      'es': 'Categoría',
      'en': 'Post Title',
    },
    'db382fd5': {
      'es': 'Option 1',
      'en': '',
    },
    '7tchi18g': {
      'es': 'Categoría',
      'en': '',
    },
    '2tnhpagq': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'vily7ynd': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'lhhvtxxq': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    'g42ft5o1': {
      'es': 'Option 1',
      'en': '',
    },
    'l7nltwkg': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'aka2v4j1': {
      'es': 'Licitación',
      'en': '',
    },
    'uej61qdg': {
      'es': 'Licitación',
      'en': 'Title',
    },
    'xy05dxg6': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    'samv7ui4': {
      'es': 'Option 1',
      'en': '',
    },
    'ko7hevxm': {
      'es': 'Licitación',
      'en': '',
    },
    'rgrrc5ge': {
      'es': 'Inmueble',
      'en': '',
    },
    'gqeo0pxo': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    'e4tp7dte': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    'xtnosgnz': {
      'es': 'Option 1',
      'en': '',
    },
    'rxok73wp': {
      'es': 'Inmueble',
      'en': '',
    },
    'ith1llia': {
      'es': 'Modelo',
      'en': '',
    },
    'b3qowj3a': {
      'es': 'Modelo',
      'en': 'Title',
    },
    '92bgsv0h': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    'bhry9dpv': {
      'es': 'Option 1',
      'en': '',
    },
    'uyvdlpbo': {
      'es': 'Modelo',
      'en': '',
    },
    'mevt2b9v': {
      'es': 'Placa',
      'en': '',
    },
    '2q0pulj4': {
      'es': 'Placa',
      'en': 'Title',
    },
    'ny0a8dam': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    'as7xb5gy': {
      'es': 'Placa',
      'en': '',
    },
    '71pgqpat': {
      'es': 'Dsitrito',
      'en': '',
    },
    'h9zkz03u': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    'czpsbmo5': {
      'es': 'Search...',
      'en': '',
    },
    '7asmn6tb': {
      'es': 'Xalapa',
      'en': '',
    },
    '3x0h4cli': {
      'es': 'Distrito',
      'en': '',
    },
    'b4q4cgjm': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'k990lwx3': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    'jwmwn6wb': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    '6hfscpzx': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'lqytejss': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'tevhzao7': {
      'es': 'Zona',
      'en': 'Title',
    },
    'd3woghpk': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    'j9s0n5wu': {
      'es': 'Option 1',
      'en': '',
    },
    'n6c761oe': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    'ekw3ie5p': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'u05wz7jj': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '3fql4l3m': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    't3qx6fn9': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    'lqn24mwq': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'hr0c3mhz': {
      'es': 'No aplica',
      'en': '',
    },
    'e0g40rbb': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'pnzhsgao': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'egaolvmh': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'erd5yqm5': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'rx5decjo': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    'kij0mvia': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    'en76qxow': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    'abbj4t4f': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    'idc8v1a2': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'fcmxhwdz': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'novppcgm': {
      'es': 'Option 1',
      'en': '',
    },
    'c8qisfup': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'h0e3zok3': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'k5bjk9gg': {
      'es': 'Option 1',
      'en': '',
    },
    'ew04yf37': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'vu87sy9x': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'k71alsl9': {
      'es': 'Option 1',
      'en': '',
    },
    'arda21eg': {
      'es': 'Regresar',
      'en': 'Save',
    },
    'pce8dsg3': {
      'es': 'ID no localizado. Regresar',
      'en': '',
    },
    'b4i4moaq': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // BajaCopy
  {
    'vvqn8laf': {
      'es': 'Regresar',
      'en': '',
    },
    'ydcgw9qz': {
      'es': 'ASIGNAR FOLIO PARA CONTROL DE VALES DE MOVIMIENTO DE BAJA',
      'en': '',
    },
    'ydb2hfws': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'veav6fem': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'ai1dqnie': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'nds4vu9j': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'pl92zgrf': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    '560xytrz': {
      'es': 'Nombre de quien solicita el movimiento',
      'en': 'Post Title',
    },
    'dljp7wr6': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    'ii25u7ck': {
      'es': 'BAJA',
      'en': '',
    },
    'ncsmibqa': {
      'es': 'BAJA',
      'en': 'Title',
    },
    'rm35xkq7': {
      'es': 'Search...',
      'en': '',
    },
    'cly0l547': {
      'es': 'BAJA',
      'en': '',
    },
    'riecrkrc': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'x0523tg7': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '3484emaa': {
      'es': 'CONSEJO DE LA JUDICATURA',
      'en': '',
    },
    '7k5mejuz': {
      'es': 'Option 1',
      'en': '',
    },
    '7m6yg88q': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'shljm7cr': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'y201i886': {
      'es': 'SUBDIRECCIÓN DE RECURSOS MATERIALES',
      'en': '',
    },
    'x1465bm9': {
      'es': 'Option 1',
      'en': '',
    },
    'etm09npc': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    's3vyk4uw': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'oihznuq9': {
      'es': 'BODEGA 4 PISO',
      'en': '',
    },
    '16jce2gy': {
      'es': 'Option 1',
      'en': '',
    },
    '2igxu6hf': {
      'es': 'ID',
      'en': '',
    },
    'xk7smujq': {
      'es': 'Inventario',
      'en': 'Title',
    },
    '4u8n8dx8': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'b6jg9chm': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'ipumd4wt': {
      'es': 'Importe',
      'en': '',
    },
    'b4u46ef6': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'jhpj831j': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    '1p05y00z': {
      'es': 'Importe del bien',
      'en': '',
    },
    't6xdh4dy': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'vmwktlxn': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'u8z3cgyh': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    '2zhilvkg': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '3qevbknd': {
      'es': 'Depositario',
      'en': '',
    },
    'visakf0e': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'unbx0sq4': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'texip4qo': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'uri66l6n': {
      'es': 'Usuario',
      'en': '',
    },
    'qc7p6y0s': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'jipe88te': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    '0savm1po': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    '861twr92': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    '71gi4zjn': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'dajexzm0': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'gpuq22dh': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'jj2sk3ex': {
      'es': 'Dar de baja',
      'en': 'Save',
    },
    'deo0xi5n': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // Iniciarvale
  {
    'q9f05wv2': {
      'es': 'Regresar',
      'en': '',
    },
    'el6lgoy5': {
      'es': 'ASIGNAR FOLIO PARA CONTROL DE VALES DE MOVIMIENTO DE BIENES',
      'en': '',
    },
    '1et65vuj': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'uijgq02p': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'od1inxuu': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'sqv2t09e': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'kv3mbj77': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    'n25d6hwo': {
      'es': 'Nombre de quien solicita',
      'en': 'Post Title',
    },
    'kaw4kgjv': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    '571al8de': {
      'es': '',
      'en': '',
    },
    'jvd389jz': {
      'es': 'TIPO DE VALE',
      'en': 'Title',
    },
    'wfvatkqh': {
      'es': 'Search...',
      'en': '',
    },
    'q8fwyl4e': {
      'es': 'REPOSICION',
      'en': '',
    },
    'oub1plsq': {
      'es': 'TRANSFERENCIA',
      'en': '',
    },
    'tx3tis52': {
      'es': 'ALTA',
      'en': '',
    },
    'blgv3nzo': {
      'es': 'BAJA',
      'en': '',
    },
    '8w4jkn4k': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    '9pazi6f6': {
      'es': 'Depositario',
      'en': '',
    },
    'k0mzjbl6': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    '5rtv7wt7': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    '4648ylxn': {
      'es': 'Sin titular inicial',
      'en': '',
    },
    'hjyqvn8i': {
      'es': 'Option 1',
      'en': '',
    },
    '5v1y2n5c': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'bj38f2z8': {
      'es': 'Usuario',
      'en': '',
    },
    'atapo106': {
      'es': 'Usuario',
      'en': 'Title',
    },
    '8ftuagam': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'mdeb13qi': {
      'es': 'Sin depositario inicial',
      'en': '',
    },
    '3zs890vb': {
      'es': 'Option 1',
      'en': '',
    },
    '2xoc665g': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'gcuz2qu2': {
      'es': 'Estado del bien',
      'en': '',
    },
    '57blea2g': {
      'es': '',
      'en': '',
    },
    'fvdysdat': {
      'es': '',
      'en': 'Title',
    },
    'vx4iuk5z': {
      'es': 'Search...',
      'en': '',
    },
    '32u2uaai': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    'bc975hvk': {
      'es': 'REGULAR',
      'en': '',
    },
    'e4l36djx': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    '89j9ewa5': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'yi8sd535': {
      'es': 'Estado del bien',
      'en': '',
    },
    'xhazarzs': {
      'es': 'Pendiente de revisión en CI',
      'en': '',
    },
    'hmzh1xxi': {
      'es': 'No',
      'en': '',
    },
    'j0aqlxhj': {
      'es': '',
      'en': 'Title',
    },
    '61jtsda5': {
      'es': 'Search...',
      'en': '',
    },
    '1yan8an8': {
      'es': 'Si',
      'en': '',
    },
    'b1w40p3v': {
      'es': 'No',
      'en': '',
    },
    'qdgh2jod': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    '7vgrd2hq': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'p14ndhqc': {
      'es': 'Option 1',
      'en': '',
    },
    '1ma2gyi4': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'e0an0apa': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'ucj8qi5j': {
      'es': 'Option 1',
      'en': '',
    },
    'snyqgfk4': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    't5bpr56k': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '9zttixvn': {
      'es': 'Option 1',
      'en': '',
    },
    '7dgvriad': {
      'es': 'Ubicación física',
      'en': '',
    },
    '66yhk4x0': {
      'es': 'Ubicación física del bien',
      'en': 'Title',
    },
    '33iv3efr': {
      'es': 'Ubicación física del bien',
      'en': 'Post Title',
    },
    'xpu3a7vt': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'ywmsndvz': {
      'es': 'Option 1',
      'en': '',
    },
    '9m0qm913': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'dqilijv9': {
      'es': 'Generar registro del vale',
      'en': '',
    },
    'ftzqvr12': {
      'es': 'Agregar bien',
      'en': '',
    },
    'e9vbgb45': {
      'es': 'Lista de bienes',
      'en': '',
    },
    'por3900u': {
      'es': 'Total de bienes: ',
      'en': '',
    },
    'wmvqtmtv': {
      'es': 'ID inventario: ',
      'en': '',
    },
    'fynxfcja': {
      'es': 'Nombre: ',
      'en': '',
    },
    '6zsoyaff': {
      'es': 'Eliminar de lista',
      'en': '',
    },
    'y2bsad25': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // almacen3
  {
    'k68hm0gp': {
      'es': 'Inicio',
      'en': '',
    },
    'ypvopjvp': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'f9cbwr2h': {
      'es': 'Vers. 0.8.11',
      'en': '',
    },
    'tvp4fc3x': {
      'es': 'Elementos disponibles:',
      'en': '',
    },
    'fgzpd7a8': {
      'es': 'Quitar de lista',
      'en': '',
    },
    'mlnhuyxa': {
      'es': 'Elemento: ',
      'en': '',
    },
    'tc58v3g1': {
      'es': 'Características: ',
      'en': '',
    },
    'bk0i0qvb': {
      'es': 'Ubicación: ',
      'en': '',
    },
    'wqpdholp': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Inicio
  {
    'a4x8l8a6': {
      'es': 'Activos',
      'en': '',
    },
    'wvydvew1': {
      'es': 'Almacen',
      'en': '',
    },
    'w4qwrqop': {
      'es': 'Reportes',
      'en': '',
    },
    'z10mow1u': {
      'es': 'Financieros',
      'en': '',
    },
    'ze6ic4d1': {
      'es': 'Libro de Invent.',
      'en': '',
    },
    '3pkjn923': {
      'es': 'Resumen',
      'en': '',
    },
    'jfqk00v9': {
      'es': 'Usuarios',
      'en': '',
    },
    '2zqk9y6b': {
      'es': 'Catálogos',
      'en': '',
    },
    '9on4gu9y': {
      'es': 'Clase de activo',
      'en': '',
    },
    'oz2iizak': {
      'es': 'Categorías',
      'en': '',
    },
    '2h2h6dhg': {
      'es': 'Proveedores',
      'en': '',
    },
    'u52qodou': {
      'es': 'Colores',
      'en': '',
    },
    'rzfd0us9': {
      'es': 'Cuentas contables',
      'en': '',
    },
    '8rg4wtfn': {
      'es': 'Depositarios',
      'en': '',
    },
    'f6oy6851': {
      'es': 'Distritos',
      'en': '',
    },
    'fulz24ql': {
      'es': 'Facturas',
      'en': '',
    },
    'nv325ie7': {
      'es': 'Niveles de Organización',
      'en': '',
    },
    '9hdxdks0': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'wk89bgz8': {
      'es': 'Vers. 1.8.5',
      'en': '',
    },
    'gt8tlgbo': {
      'es': 'Sistema de control de inventarios del PJEV',
      'en': '',
    },
    '5ukxtufo': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    '3po68sfi': {
      'es': 'Vale de BAJA',
      'en': '',
    },
    'vbkvfh2f': {
      'es': 'Vale de MANTENIMIENTO',
      'en': '',
    },
    '6dbb1w9x': {
      'es': 'Vale de Movimiento',
      'en': '',
    },
    'mw73u764': {
      'es': 'Lista de vales',
      'en': '',
    },
    'd0nkcdtk': {
      'es': 'Crear nuevo bien',
      'en': '',
    },
    'c1ivy4pp': {
      'es': 'Subir Cárdex',
      'en': '',
    },
    'ejqmd20s': {
      'es': 'Buscar por serie',
      'en': '',
    },
    '8g5mc2yx': {
      'es': 'Ir a anexos',
      'en': '',
    },
    'i10ejsk9': {
      'es': 'Buscar bien',
      'en': '',
    },
    'xd75dwdz': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Usuarios
  {
    '0drtjzzw': {
      'es': 'Inicio',
      'en': '',
    },
    'z9m2rme6': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '9ryed7i6': {
      'es': 'Total de usuarios: ',
      'en': '',
    },
    '3rvtwmii': {
      'es': 'Crear cuenta de usuario',
      'en': '',
    },
    '59kybb5k': {
      'es': 'Editar usuario',
      'en': '',
    },
    'i8wiqgnc': {
      'es': 'Nombre: ',
      'en': '',
    },
    'ij8tldyw': {
      'es': 'Eliminar usuario',
      'en': '',
    },
    'uwl04dbe': {
      'es': 'Teléfono: ',
      'en': '',
    },
    '8ka2fctp': {
      'es': 'Correo: ',
      'en': '',
    },
    '9tloj216': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Vales02
  {
    '4kd2871f': {
      'es': 'Regresar',
      'en': '',
    },
    'bbkq4zv3': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'syclw52e': {
      'es': 'Vers. 1.8.5',
      'en': '',
    },
    'vajxho0v': {
      'es': 'Archivo de vales de movimiento de bienes',
      'en': '',
    },
    'w2emdem4': {
      'es': 'Buscar por folio',
      'en': '',
    },
    'x9uu6lz3': {
      'es': 'Agregar nuevo vale',
      'en': '',
    },
    'iud1hboq': {
      'es': 'Folio del vale',
      'en': '',
    },
    'jm28954i': {
      'es': 'Fecha',
      'en': '',
    },
    't5kdad73': {
      'es': 'Tipo de vale',
      'en': '',
    },
    '69ccptle': {
      'es': 'Nombre quien realiza',
      'en': '',
    },
    'zwljmi6g': {
      'es': 'Estado',
      'en': '',
    },
    '9qphmxy0': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // HomeRespaldo
  {
    '44yn1awm': {
      'es': 'Activos',
      'en': '',
    },
    '8bb677xv': {
      'es': 'Almacen',
      'en': '',
    },
    '1v9y0wrf': {
      'es': 'Anexos',
      'en': '',
    },
    '2865b9c9': {
      'es': 'Financieros',
      'en': '',
    },
    '5n5ns3fu': {
      'es': 'Libro de Invent.',
      'en': '',
    },
    'uv8qx5kk': {
      'es': 'Depreciación',
      'en': '',
    },
    '1i85e8f0': {
      'es': 'Resumen',
      'en': '',
    },
    '5l955dz3': {
      'es': 'Usuarios',
      'en': '',
    },
    'yryumejn': {
      'es': 'Catálogos',
      'en': '',
    },
    'q48pmyxb': {
      'es': 'Clase de activo',
      'en': '',
    },
    'f2ogzfbp': {
      'es': 'Categorías',
      'en': '',
    },
    'nzuhkthc': {
      'es': 'Proveedores',
      'en': '',
    },
    'sj87gpvm': {
      'es': 'Colores',
      'en': '',
    },
    'pu3ls62s': {
      'es': 'Cuentas contables',
      'en': '',
    },
    'f265btnj': {
      'es': 'Depositarios',
      'en': '',
    },
    'y0kh6sgs': {
      'es': 'Distritos',
      'en': '',
    },
    '0u8p3tzu': {
      'es': 'Facturas',
      'en': '',
    },
    'rn6h2ndc': {
      'es': 'Niveles de Organización',
      'en': '',
    },
    'szfqf3rc': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    's3hzh6wl': {
      'es': 'Vers. 1.8.5',
      'en': '',
    },
    '9sw1kqf6': {
      'es': 'Sistema de control de inventarios del PJEV',
      'en': '',
    },
    'gn1pjcvc': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    'yfudkwqz': {
      'es': 'Vale de Movimiento',
      'en': '',
    },
    '4g0ok2ik': {
      'es': 'Lista de vales',
      'en': '',
    },
    'ed879tq8': {
      'es': 'Crear nuevo bien',
      'en': '',
    },
    'ehmbnz6g': {
      'es': 'Subir Cárdex',
      'en': '',
    },
    'tou5u11c': {
      'es': 'Buscar por serie',
      'en': '',
    },
    'q65c92l9': {
      'es': 'Ir a anexos',
      'en': '',
    },
    'r7666yhz': {
      'es': 'Buscar bien',
      'en': '',
    },
    '5j16q9nf': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // HomeDiciembre2025
  {
    'ekc0grku': {
      'es': 'Almacen',
      'en': '',
    },
    'ez0fvn4e': {
      'es': 'Activos',
      'en': '',
    },
    '1hyqjzcx': {
      'es': 'Reporte Gral',
      'en': '',
    },
    'mxfdvr4m': {
      'es': 'Libro de Invent.',
      'en': '',
    },
    'pzij6isu': {
      'es': 'Avalúos',
      'en': '',
    },
    '0pfl5m4t': {
      'es': 'Dep. Acum',
      'en': '',
    },
    'xua8wao4': {
      'es': 'Dep. A. 2024',
      'en': '',
    },
    'v1yzdtk4': {
      'es': 'Financieros',
      'en': '',
    },
    '3y2q8wqo': {
      'es': 'Dep. 2024',
      'en': '',
    },
    'jsrcf0ul': {
      'es': 'Depreciación',
      'en': '',
    },
    'g6vubj5t': {
      'es': 'Usuarios',
      'en': '',
    },
    '3fsq8qti': {
      'es': 'Anexos',
      'en': '',
    },
    '6m0gkakt': {
      'es': 'Catálogos',
      'en': '',
    },
    'or3v78pd': {
      'es': 'Clase de activo',
      'en': '',
    },
    'l2luibho': {
      'es': 'Categorías',
      'en': '',
    },
    'bbkps7ps': {
      'es': 'Proveedores',
      'en': '',
    },
    'tbbeqdeg': {
      'es': 'Colores',
      'en': '',
    },
    '0qyzo0e2': {
      'es': 'Cuentas contables',
      'en': '',
    },
    'trzeofw6': {
      'es': 'Depositarios',
      'en': '',
    },
    'gokc70y7': {
      'es': 'Distritos',
      'en': '',
    },
    'a60zis72': {
      'es': 'Facturas',
      'en': '',
    },
    '243mtdof': {
      'es': 'Niveles de Organización',
      'en': '',
    },
    'lkc1a4cp': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '0hvqxs7n': {
      'es': 'Vers. 1.9.5',
      'en': '',
    },
    'eskv8ri9': {
      'es': 'Sistema de control de inventarios del PJEV',
      'en': '',
    },
    '6an1ftlb': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    'ein9j1yi': {
      'es': 'Vale de Movimiento',
      'en': '',
    },
    '3tibe7kt': {
      'es': 'Lista de vales',
      'en': '',
    },
    'jj88ebk9': {
      'es': 'Crear nuevo bien',
      'en': '',
    },
    'ivxzv0gg': {
      'es': 'Subir Cárdex',
      'en': '',
    },
    'x24k772z': {
      'es': 'Buscar por serie',
      'en': '',
    },
    '6mq10fnx': {
      'es': 'Ir a anexos',
      'en': '',
    },
    '9k7mv84t': {
      'es': 'Buscar bien',
      'en': '',
    },
    '27iuna4j': {
      'es': 'Editar anexo',
      'en': '',
    },
    'jg7i5gf1': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // activosrespaldo
  {
    'u6uoqb62': {
      'es': 'Inicio',
      'en': '',
    },
    'mmb5bw6r': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '9vx561w9': {
      'es': 'Vers. 0.8.11',
      'en': '',
    },
    '9dpqfdra': {
      'es': 'Activos',
      'en': '',
    },
    'jzwwwksy': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    'm2ze7nju': {
      'es': 'Carga bienes',
      'en': '',
    },
    'bgktjog9': {
      'es': 'Nuevo bien',
      'en': '',
    },
    'spr7uvyn': {
      'es': 'Descripción',
      'en': '',
    },
    'bhevi1i8': {
      'es': 'Fecha de alta',
      'en': '',
    },
    'bpcnru80': {
      'es': 'Nombre depositario',
      'en': '',
    },
    'wmrhm9r5': {
      'es': 'Fecha Adquisición',
      'en': '',
    },
    'ndhf39wt': {
      'es': 'No. Inventario',
      'en': '',
    },
    'vijpmzl9': {
      'es': 'Origen recurso',
      'en': '',
    },
    'w83i3wp4': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Homeenero2026
  {
    'fpigtzsp': {
      'es': 'Almacen',
      'en': '',
    },
    'gudnilcw': {
      'es': 'Activos',
      'en': '',
    },
    'q78cfmil': {
      'es': 'Reporte Gral',
      'en': '',
    },
    'o6cwcrt4': {
      'es': 'Libro de Invent.',
      'en': '',
    },
    'w85bs3cg': {
      'es': 'Avalúos',
      'en': '',
    },
    '3e6cgpn0': {
      'es': 'Dep. Acumulada',
      'en': '',
    },
    'gditobok': {
      'es': 'Dep. A. 2025',
      'en': '',
    },
    '58xpi3m4': {
      'es': 'Dep. A. 2024',
      'en': '',
    },
    'bm8ceh4s': {
      'es': 'Valor en Libros',
      'en': '',
    },
    'f62nyftj': {
      'es': 'V. L.  2024',
      'en': '',
    },
    '4erlkjkd': {
      'es': 'Financieros',
      'en': '',
    },
    'o3qmiohx': {
      'es': 'Depreciación',
      'en': '',
    },
    'fmo982y7': {
      'es': 'Anexos',
      'en': '',
    },
    '5i1kzbcf': {
      'es': 'Trans. Masiva',
      'en': '',
    },
    'ucuqfg3n': {
      'es': 'Cambiar Clase',
      'en': '',
    },
    '8yk9wdbh': {
      'es': 'Cambiar Organización',
      'en': '',
    },
    'j766u63o': {
      'es': 'Usuarios',
      'en': '',
    },
    '7gi2hlfl': {
      'es': 'Catálogos',
      'en': '',
    },
    'h65rmunl': {
      'es': 'Clase de activo',
      'en': '',
    },
    '33xs3r7m': {
      'es': 'Categorías',
      'en': '',
    },
    '9son1kdc': {
      'es': 'Proveedores',
      'en': '',
    },
    'y56cneny': {
      'es': 'Colores',
      'en': '',
    },
    'y9w84e8m': {
      'es': 'Cuentas contables',
      'en': '',
    },
    '2fy4tpym': {
      'es': 'Depositarios',
      'en': '',
    },
    'e59uufy0': {
      'es': 'Distritos',
      'en': '',
    },
    'smolwacx': {
      'es': 'Facturas',
      'en': '',
    },
    'lz0ndr18': {
      'es': 'Niveles de Organización',
      'en': '',
    },
    'hsayk7dd': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '7d5hnzf9': {
      'es': 'Vers. 1.9.7',
      'en': '',
    },
    'hgr1nywu': {
      'es': 'Sistema de control de inventarios del PJEV',
      'en': '',
    },
    'dxb9ra7y': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    'lr6k6wgk': {
      'es': 'Vale de Movimiento',
      'en': '',
    },
    'sy4xnrs7': {
      'es': 'Lista de vales',
      'en': '',
    },
    '931y5lp5': {
      'es': 'Crear nuevo bien',
      'en': '',
    },
    'mp1v08bw': {
      'es': 'Subir Cárdex',
      'en': '',
    },
    'gs0xswmq': {
      'es': 'Buscar por serie',
      'en': '',
    },
    'b0n4vkmn': {
      'es': 'Ir a anexos',
      'en': '',
    },
    'dynyqjdt': {
      'es': 'Actualizar nivel',
      'en': '',
    },
    'dtapwkf5': {
      'es': 'Buscar bien',
      'en': '',
    },
    'rrb4egxd': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // Homefebrero
  {
    'f5ktf35f': {
      'es': 'Almacen',
      'en': '',
    },
    '2wf3t4im': {
      'es': 'Activos',
      'en': '',
    },
    '2grgy0df': {
      'es': 'Reporte Gral',
      'en': '',
    },
    'eiujgt2g': {
      'es': 'Libro de Invent.',
      'en': '',
    },
    '0rdf3xhw': {
      'es': 'Avalúos',
      'en': '',
    },
    'nazqlces': {
      'es': 'Depreciación',
      'en': '',
    },
    '6c4q6b9i': {
      'es': 'Dep. Acum.',
      'en': '',
    },
    '6vo6b9x7': {
      'es': 'Dep. A. 2024',
      'en': '',
    },
    'hutobyia': {
      'es': 'Financieros',
      'en': '',
    },
    'kzjzteg2': {
      'es': 'Depreciación',
      'en': '',
    },
    '8jugptu2': {
      'es': 'Anexos',
      'en': '',
    },
    'futc2asd': {
      'es': 'Trans. Masiva',
      'en': '',
    },
    '9ls0xyv1': {
      'es': 'Usuarios',
      'en': '',
    },
    'gf8w2k4w': {
      'es': 'Catálogos',
      'en': '',
    },
    '0ae7v72g': {
      'es': 'Clase de activo',
      'en': '',
    },
    '2axubi2o': {
      'es': 'Categorías',
      'en': '',
    },
    'r6p684bj': {
      'es': 'Proveedores',
      'en': '',
    },
    'iovvdpvy': {
      'es': 'Colores',
      'en': '',
    },
    'tst5f9nf': {
      'es': 'Cuentas contables',
      'en': '',
    },
    'cd5viaz4': {
      'es': 'Depositarios',
      'en': '',
    },
    'mpjcjbwk': {
      'es': 'Distritos',
      'en': '',
    },
    '9cd2csog': {
      'es': 'Facturas',
      'en': '',
    },
    'd6t94n6y': {
      'es': 'Niveles de Organización',
      'en': '',
    },
    'sb3qjp3u': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    'xx240n9g': {
      'es': 'Vers. 2.0.0',
      'en': '',
    },
    'z47rhm24': {
      'es': 'Sistema de control de inventarios del PJEV',
      'en': '',
    },
    '182um8ha': {
      'es': 'Total Bienes: ',
      'en': '',
    },
    '75lfesin': {
      'es': 'Vale de Movimiento',
      'en': '',
    },
    'w4lwznaw': {
      'es': 'Lista de vales',
      'en': '',
    },
    'k0x79nvf': {
      'es': 'Crear nuevo bien',
      'en': '',
    },
    'u7eok193': {
      'es': 'Subir Cárdex',
      'en': '',
    },
    'dej3vy88': {
      'es': 'Buscar por serie',
      'en': '',
    },
    'vmdijkx3': {
      'es': 'Ir a anexos',
      'en': '',
    },
    'e9o6ttx0': {
      'es': 'Buscar bien',
      'en': '',
    },
    'zxu9sb7b': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // IniciarvaleCopy
  {
    'l3w385vo': {
      'es': 'Regresar',
      'en': '',
    },
    'h5hbcl10': {
      'es': 'ASIGNAR FOLIO PARA CONTROL DE VALES DE MOVIMIENTO DE BIENES',
      'en': '',
    },
    'krp354zj': {
      'es': 'Folio correspondiente al vale de movimientos',
      'en': '',
    },
    'waz0a1jc': {
      'es': 'Folio del vale de movimientos',
      'en': 'Title',
    },
    'o1lrkc8i': {
      'es': 'Ingresar folio del vale de movimientos',
      'en': 'Post Title',
    },
    'ke4ftd25': {
      'es': 'Nombre quien solicita el movimiento',
      'en': '',
    },
    'onx1qzsn': {
      'es': 'Nombre quien solicita movimiento',
      'en': 'Title',
    },
    'u1wmlvjc': {
      'es': 'Nombre de quien solicita',
      'en': 'Post Title',
    },
    'okiox7xq': {
      'es': 'Tipo de movimiento',
      'en': '',
    },
    'gmq8rxw9': {
      'es': '',
      'en': '',
    },
    '8sbq4ifi': {
      'es': 'TIPO DE VALE',
      'en': 'Title',
    },
    'dk5wc5le': {
      'es': 'Search...',
      'en': '',
    },
    'wotb8o7x': {
      'es': 'REPOSICION',
      'en': '',
    },
    '681ppa4w': {
      'es': 'TRANSFERENCIA',
      'en': '',
    },
    'l9izr5mc': {
      'es': 'ALTA',
      'en': '',
    },
    'lggr03kb': {
      'es': 'BAJA',
      'en': '',
    },
    'xc6skxgj': {
      'es': 'MANTENIMIENTO',
      'en': '',
    },
    'dkjj49ew': {
      'es': 'Depositario',
      'en': '',
    },
    'fyb01f4p': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'bjj53c7h': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'cfg29nap': {
      'es': 'Sin titular inicial',
      'en': '',
    },
    'bkdsmxh6': {
      'es': 'Option 1',
      'en': '',
    },
    '3jiwmkoe': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'gzh0maph': {
      'es': 'Usuario',
      'en': '',
    },
    'o8lkdj9v': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'haliyxcw': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'ld2fu4l7': {
      'es': 'Sin depositario inicial',
      'en': '',
    },
    'to8fwk4m': {
      'es': 'Option 1',
      'en': '',
    },
    'vnjuyx38': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'vm5yo10k': {
      'es': 'Estado del bien',
      'en': '',
    },
    '5sj88bis': {
      'es': '',
      'en': '',
    },
    '1z0oy4db': {
      'es': '',
      'en': 'Title',
    },
    '9un2gvyf': {
      'es': 'Search...',
      'en': '',
    },
    'nrjztv8p': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    '6ovtsv6z': {
      'es': 'REGULAR',
      'en': '',
    },
    'uzlqux5m': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    'cp48s97x': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'cycug32f': {
      'es': 'Estado del bien',
      'en': '',
    },
    'f7mgb7ip': {
      'es': 'Pendiente de revisión en CI',
      'en': '',
    },
    '0781q8s6': {
      'es': 'No',
      'en': '',
    },
    'dv3bcy2s': {
      'es': '',
      'en': 'Title',
    },
    'viuui4a9': {
      'es': 'Search...',
      'en': '',
    },
    'f9aq9jky': {
      'es': 'Si',
      'en': '',
    },
    'm421a9yh': {
      'es': 'No',
      'en': '',
    },
    '2v8gql9w': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    '8v9aub4u': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'up27ejd9': {
      'es': 'Option 1',
      'en': '',
    },
    '861szyzu': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'pv6fzkr3': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '2otmioyf': {
      'es': 'Option 1',
      'en': '',
    },
    'e8nhq87f': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'i6hxnjrf': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'g4rok7t8': {
      'es': 'Option 1',
      'en': '',
    },
    'cxwdul8v': {
      'es': 'Ubicación física',
      'en': '',
    },
    'hws1w11t': {
      'es': 'Ubicación física del bien',
      'en': 'Title',
    },
    'd5dyq8pq': {
      'es': 'Ubicación física del bien',
      'en': 'Post Title',
    },
    'nhcs3ejk': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'x0ts50x7': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'gyi6l03q': {
      'es': 'Generar registro del vale',
      'en': '',
    },
    'kxs2nzx5': {
      'es': 'Agregar bien (Admin)',
      'en': '',
    },
    'qvtzr05r': {
      'es': 'Lista de bienes',
      'en': '',
    },
    'a3is74rl': {
      'es': 'Total de bienes: ',
      'en': '',
    },
    '75yh5f7l': {
      'es': 'ID inventario: ',
      'en': '',
    },
    'i2r75gym': {
      'es': 'Nombre: ',
      'en': '',
    },
    'fv103z46': {
      'es': 'Eliminar de lista',
      'en': '',
    },
    '35bffdns': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // VerbienCopy2
  {
    '3e9hpy7e': {
      'es': 'Regresar',
      'en': '',
    },
    'cncmnib9': {
      'es': 'ESTADO DEL BIEN: ',
      'en': '',
    },
    'x4dhae87': {
      'es': 'ID',
      'en': '',
    },
    'v9q0dlmt': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'nocljukd': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'xwn9qg8c': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'yg6nfdrt': {
      'es': 'ID anterior',
      'en': '',
    },
    'h7w27w5q': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    'vn34pkor': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    '1l4540xb': {
      'es': 'Número de ID anterior del bien',
      'en': '',
    },
    'dkdr4hgi': {
      'es': 'Importe',
      'en': '',
    },
    'ssiyoki8': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'lpbrblp8': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    '6ppf1ua2': {
      'es': 'Importe del bien',
      'en': '',
    },
    'bzz8m9nw': {
      'es': 'Avalúo',
      'en': '',
    },
    '5pxhqxz2': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Title',
    },
    '2925945p': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Post Title',
    },
    'p69ww5l0': {
      'es': 'Importe del avalúo',
      'en': '',
    },
    '6hmetg80': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'eqxzqnzl': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'no2j2vss': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'khyg9ldb': {
      'es': 'Option 1',
      'en': '',
    },
    '6gwgfz9l': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'k9rpujox': {
      'es': 'Depositario',
      'en': '',
    },
    '0i842pie': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'e5s1t0g9': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'e0kdpxe8': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    '2kqus1ra': {
      'es': 'Usuario',
      'en': '',
    },
    'dyrdmeuw': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'cmynhbks': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'og29x6v3': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'dgpp7mke': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'z6fh8gyg': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'kctb8poo': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    'mf2be52w': {
      'es': 'Option 1',
      'en': '',
    },
    '1o5fzqu9': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'af8n97a3': {
      'es': 'Verifica vs',
      'en': '',
    },
    'uyf21e0z': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'p1n8a3fl': {
      'es': 'Search...',
      'en': '',
    },
    'xcxa7dve': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    '6wn6etyq': {
      'es': 'Documento cotejo',
      'en': '',
    },
    'krg62mop': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'wjsr5bqx': {
      'es': 'Search...',
      'en': '',
    },
    'dpkbl76d': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    '6bmb8hbf': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'bm2scmd4': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'f5o7vox1': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'di9vxlcz': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'kuxhwzkf': {
      'es': 'Ejercicio',
      'en': '',
    },
    'oh6k1875': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    'ydvuy18k': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    '0h8jj2h6': {
      'es': 'Año fiscal',
      'en': '',
    },
    '2gasstrl': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    'c44sdxsc': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    'yv8lp033': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    '16x0ugp4': {
      'es': 'Option 1',
      'en': '',
    },
    'j0pwuiy1': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    '62nz3qns': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'rgn2tjci': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    '7trplkmf': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    'ifam02q1': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    'kbywelet': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'dfx7ozpw': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    'aw2mpujo': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    'w35r6ici': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    'iw2anggq': {
      'es': 'Option 1',
      'en': '',
    },
    '9zhpq7o9': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '4ldfm1k4': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'w8z23qcu': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'bu4ptw72': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'iepch3g7': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '3173u87h': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '5zcncrv0': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '7cldygn8': {
      'es': 'Marca comercial',
      'en': '',
    },
    'tru20og0': {
      'es': 'Marca',
      'en': 'Title',
    },
    'jj441h4i': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    '8gko23nj': {
      'es': 'Option 1',
      'en': '',
    },
    'bev3gezi': {
      'es': 'Marca',
      'en': '',
    },
    'kidgksjk': {
      'es': 'Factura',
      'en': '',
    },
    'c6kok97c': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    '7xcklree': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'jtpjrnnt': {
      'es': 'Option 1',
      'en': '',
    },
    'bywugirm': {
      'es': 'Factura',
      'en': '',
    },
    'qmc3c7f9': {
      'es': 'Clase de activo (Depreciación)',
      'en': '',
    },
    'p5pf7ts4': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'du0o1let': {
      'es': 'Clase de activo',
      'en': 'Post Title',
    },
    'twgoqlgx': {
      'es': 'Clase de activo',
      'en': '',
    },
    'hl2r3z60': {
      'es': 'Estado del bien',
      'en': '',
    },
    '1k5c57zc': {
      'es': 'Search...',
      'en': '',
    },
    'o85rsbsb': {
      'es': 'Estado del bien',
      'en': '',
    },
    '3k9fl8cd': {
      'es': 'Color del bien',
      'en': '',
    },
    '28wjxurj': {
      'es': 'Color',
      'en': 'Title',
    },
    'eagg1c0w': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'tuyqwhcx': {
      'es': 'Option 1',
      'en': '',
    },
    'jgqavn0z': {
      'es': 'Color',
      'en': '',
    },
    'hf9s4cck': {
      'es': 'Modelo',
      'en': '',
    },
    'gvto0oa8': {
      'es': 'Modelo',
      'en': 'Title',
    },
    '4pk4aekh': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    'ahdt5u7d': {
      'es': 'Option 1',
      'en': '',
    },
    'ivdxgyui': {
      'es': 'Modelo',
      'en': '',
    },
    'jk1zhjrk': {
      'es': 'Placa',
      'en': '',
    },
    'g063dj4q': {
      'es': 'Placa',
      'en': 'Title',
    },
    '379qetal': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    'l2px5qsn': {
      'es': 'Placa',
      'en': '',
    },
    'ojj4abbp': {
      'es': 'Dsitrito',
      'en': '',
    },
    '4fel9b4y': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    'nx153plt': {
      'es': 'Search...',
      'en': '',
    },
    '65ok1tm5': {
      'es': 'Distrito',
      'en': '',
    },
    'jej2h4t6': {
      'es': 'Licitación',
      'en': '',
    },
    'rf6w12lr': {
      'es': 'Licitación',
      'en': 'Title',
    },
    'r90v9b4x': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    '27n96i8l': {
      'es': 'Option 1',
      'en': '',
    },
    'waaftlhy': {
      'es': 'Licitación',
      'en': '',
    },
    'vakfmfk8': {
      'es': 'Categoría',
      'en': '',
    },
    'g3jvzf9k': {
      'es': 'Categoría',
      'en': 'Title',
    },
    's30uzm3b': {
      'es': 'Categoría',
      'en': 'Post Title',
    },
    'sa7igf0f': {
      'es': 'Option 1',
      'en': '',
    },
    'r2ylpu4k': {
      'es': 'Categoría',
      'en': '',
    },
    'h883unua': {
      'es': 'Inmueble',
      'en': '',
    },
    'v7v044fg': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    'cudruvcl': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    'st1fhh4x': {
      'es': 'Option 1',
      'en': '',
    },
    'k3kggjwo': {
      'es': 'Inmueble',
      'en': '',
    },
    'dofhbebp': {
      'es': 'Zona',
      'en': 'Title',
    },
    'fi8v8ip7': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    '2ivuskyy': {
      'es': 'Option 1',
      'en': '',
    },
    '3ud62iw4': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    'kc1bm0nf': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'y4tdhltm': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '553dgno3': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    '9nr5e1xq': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    '62wdkkcp': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    'l1c4k58p': {
      'es': 'No aplica',
      'en': '',
    },
    'lgvz0ztw': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'iaaiqse7': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    '6mxgeg60': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'ca6r02ag': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'hz0wfamy': {
      'es': 'Imagen del bien',
      'en': '',
    },
    'hm3r3pag': {
      'es': 'Imagen del bien',
      'en': '',
    },
    '2k2uu51g': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    'wxb5grut': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    'nqxfv5rw': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    '7ls38oim': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    'vaf35r16': {
      'es': 'Editar',
      'en': 'Save',
    },
    'rrlj5t5l': {
      'es': 'ID no localizado. Regresar',
      'en': '',
    },
    'e3o36ezy': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // EditarBienCopy
  {
    'w49d6lsa': {
      'es': 'Regresar',
      'en': '',
    },
    'ca57px0c': {
      'es': 'Editar Activo',
      'en': '',
    },
    'gbqp11jb': {
      'es': 'ID',
      'en': '',
    },
    'surfnht8': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'cnv3v861': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    'p1xkkup9': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'ybgvwgmg': {
      'es': 'ID anterior',
      'en': '',
    },
    'afkgm8rf': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    'mrwowjnl': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    '061phc0a': {
      'es': 'Número de ID anterior del bien',
      'en': '',
    },
    'vix335xi': {
      'es': 'Importe',
      'en': '',
    },
    '3r643qxj': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'rnlsg1ph': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'glomc6ew': {
      'es': 'Importe del bien',
      'en': '',
    },
    'pbtuibst': {
      'es': 'Avalúo',
      'en': '',
    },
    'mwf3p3oa': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Title',
    },
    'mxhv0m7b': {
      'es': 'Avalúo del bien (\$)',
      'en': 'Post Title',
    },
    'zyuehm6i': {
      'es': 'Importe del avalúo',
      'en': '',
    },
    'l3rheco9': {
      'es': 'Nombre artículo',
      'en': '',
    },
    '4sq7slbk': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    '8zkyqpr2': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'eal2z32o': {
      'es': 'Option 1',
      'en': '',
    },
    'ciysduf4': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'cntakysq': {
      'es': 'Depositario',
      'en': '',
    },
    'c7dzh4es': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    'hltrck93': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    've7mdc4g': {
      'es': 'Option 1',
      'en': '',
    },
    'xqhid6wx': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'niih23c3': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'zucci6cv': {
      'es': 'Origen del recurso',
      'en': 'Title',
    },
    'ajpug5wd': {
      'es': 'Origen del recurso',
      'en': 'Post Title',
    },
    'nhn0v739': {
      'es': 'Option 1',
      'en': '',
    },
    'nauqmu03': {
      'es': 'Origen del recurso',
      'en': '',
    },
    'nl2bbjtj': {
      'es': 'Usuario',
      'en': '',
    },
    '0src7l51': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'qfxyvof1': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'ct7xx44i': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'l4cpnm0b': {
      'es': 'Verifica vs',
      'en': '',
    },
    'i241qwee': {
      'es': 'RESGUARDO GENERAL',
      'en': 'Title',
    },
    'qskvniyc': {
      'es': 'Search...',
      'en': '',
    },
    'jrfbfy4e': {
      'es': 'RESGUARDO GENERAL',
      'en': '',
    },
    '00jmsypo': {
      'es': 'RESGUARDO INDIVIDUAL',
      'en': '',
    },
    'rt1m5ll0': {
      'es': 'OTRO',
      'en': '',
    },
    'w7y3yx71': {
      'es': 'VERIFICA VS',
      'en': '',
    },
    '422wv2uk': {
      'es': 'Factura',
      'en': '',
    },
    'n6kg5rki': {
      'es': 'Factura del bien',
      'en': 'Title',
    },
    'qm3u1l3f': {
      'es': 'Factura',
      'en': 'Post Title',
    },
    'laq2uvev': {
      'es': 'Option 1',
      'en': '',
    },
    'flimf8x2': {
      'es': 'Factura',
      'en': '',
    },
    'jaau9rq1': {
      'es': 'Fecha de adquisición',
      'en': '',
    },
    'dlkbb58a': {
      'es': 'Fecha en que se adquirió el bien',
      'en': '',
    },
    'kytsoh5f': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    '31ofz9re': {
      'es': 'Fecha de avalúo',
      'en': '',
    },
    'mc7578cu': {
      'es': 'Ejercicio',
      'en': '',
    },
    'o1pnzvuw': {
      'es': 'Ejercicio',
      'en': 'Title',
    },
    'i6fghhso': {
      'es': 'Año fiscal',
      'en': 'Post Title',
    },
    'rlvdmz0d': {
      'es': 'Año fiscal',
      'en': '',
    },
    'vqn0d8la': {
      'es': 'Edificio ubicacion',
      'en': '',
    },
    'srtegslc': {
      'es': 'Edificio de ubicación',
      'en': 'Title',
    },
    '4y7tznpj': {
      'es': 'Edificio donde se ubica el bien',
      'en': 'Post Title',
    },
    'hb7lby1j': {
      'es': 'Option 1',
      'en': '',
    },
    'vtn6ow8o': {
      'es': 'Ubicación del bien',
      'en': '',
    },
    'iiz4zfb5': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '5k2esg9s': {
      'es': 'Nombre proveedor',
      'en': 'Title',
    },
    'gumlwfx8': {
      'es': 'Nombre proveedor',
      'en': 'Post Title',
    },
    'cxo4uusp': {
      'es': 'Option 1',
      'en': '',
    },
    '04bxpybp': {
      'es': 'Nombre del proveedor',
      'en': '',
    },
    '72ag7rsw': {
      'es': 'Resguardo',
      'en': '',
    },
    'zhdjr3a0': {
      'es': 'Folio resguardo',
      'en': 'Title',
    },
    'tmi5yfam': {
      'es': 'Folio resguardo',
      'en': 'Post Title',
    },
    'rhn0prml': {
      'es': 'Número de folio de resguardo',
      'en': '',
    },
    'eb6vwazq': {
      'es': 'Marca comercial',
      'en': '',
    },
    'tringq05': {
      'es': 'Marca',
      'en': 'Title',
    },
    'tzxqt3fk': {
      'es': 'Marca',
      'en': 'Post Title',
    },
    '44jvfv03': {
      'es': 'Option 1',
      'en': '',
    },
    'dhj322f2': {
      'es': 'Marca',
      'en': '',
    },
    'le5au41r': {
      'es': 'Documento cotejo',
      'en': '',
    },
    'a97nqe5h': {
      'es': 'FACTURA',
      'en': '',
    },
    'j21lyt55': {
      'es': 'FACTURA',
      'en': 'Title',
    },
    'kn1olzug': {
      'es': 'Search...',
      'en': '',
    },
    'nh5nyinp': {
      'es': 'FACTURA',
      'en': '',
    },
    '87etzqwc': {
      'es': 'RESGUARDO',
      'en': '',
    },
    '00u1y3ml': {
      'es': 'OFICIO',
      'en': '',
    },
    'qccx4zso': {
      'es': 'LISTADO ELECTRONICO',
      'en': '',
    },
    'n5m5ge61': {
      'es': 'RELACION',
      'en': '',
    },
    'xrxjbyf5': {
      'es': 'NINGUNO',
      'en': '',
    },
    'u3kyd93l': {
      'es': 'OTRO',
      'en': '',
    },
    'djbter9t': {
      'es': 'Documento con el que se contejó',
      'en': '',
    },
    'v6sywz1e': {
      'es': 'Clase de activo',
      'en': 'Title',
    },
    'lcm2ac3l': {
      'es': 'Clase de activo',
      'en': 'Post Title',
    },
    '2mr8h75p': {
      'es': 'Option 1',
      'en': '',
    },
    'fdjjz1bm': {
      'es': 'Clase de activo',
      'en': '',
    },
    'kiruievp': {
      'es': 'Estado del bien',
      'en': '',
    },
    'ga9fm4vy': {
      'es': 'BUEN ESTADO',
      'en': 'Title',
    },
    '4li15tm5': {
      'es': 'Search...',
      'en': '',
    },
    'e7yeej19': {
      'es': 'BUEN ESTADO',
      'en': '',
    },
    '35yzf9fz': {
      'es': 'REGULAR',
      'en': '',
    },
    '3ldh1u0s': {
      'es': 'MAL ESTADO',
      'en': '',
    },
    'nvh9euhk': {
      'es': 'INSERVIBLE',
      'en': '',
    },
    'bzejm8y5': {
      'es': 'Estado del bien',
      'en': '',
    },
    'jsulvfgn': {
      'es': 'Ubicación específica',
      'en': '',
    },
    't3vqghhb': {
      'es': 'Ubicación específica',
      'en': 'Title',
    },
    '0tlprsj6': {
      'es': 'Ubicación específica',
      'en': 'Post Title',
    },
    'uyxl70vj': {
      'es': 'SIN UBICACION ESPECIFICA',
      'en': '',
    },
    '54w3j6vt': {
      'es': 'Ubicación específica',
      'en': '',
    },
    'x8hmpdnh': {
      'es': 'Color del bien',
      'en': '',
    },
    '5b3ikqmu': {
      'es': 'Color',
      'en': 'Title',
    },
    'dzcypxsn': {
      'es': 'Color',
      'en': 'Post Title',
    },
    'o65rzwsa': {
      'es': 'Option 1',
      'en': '',
    },
    'hlq2txym': {
      'es': 'Color',
      'en': '',
    },
    'dxt1elq7': {
      'es': 'Modelo',
      'en': '',
    },
    'h54d5lh3': {
      'es': 'Modelo',
      'en': 'Title',
    },
    'sf43yzh5': {
      'es': 'Modelo',
      'en': 'Post Title',
    },
    'x4px0ng2': {
      'es': 'Option 1',
      'en': '',
    },
    'vokx1vnh': {
      'es': 'Modelo',
      'en': '',
    },
    '13wlo32y': {
      'es': 'Licitación',
      'en': '',
    },
    'i57ye5ov': {
      'es': 'Licitación',
      'en': 'Title',
    },
    'zoc4i6mo': {
      'es': 'Licitación',
      'en': 'Post Title',
    },
    'ojf6akvs': {
      'es': 'Option 1',
      'en': '',
    },
    'x8gvf8h1': {
      'es': 'Licitación',
      'en': '',
    },
    'kaldwymz': {
      'es': 'Placa',
      'en': '',
    },
    'fl6r50zq': {
      'es': 'Placa',
      'en': 'Title',
    },
    '7paa5npv': {
      'es': 'Placa',
      'en': 'Post Title',
    },
    'jh0ehdhw': {
      'es': 'Placa',
      'en': '',
    },
    'd0qg05on': {
      'es': 'Dsitrito',
      'en': '',
    },
    'saf8j052': {
      'es': 'Elegir distrito',
      'en': 'Title',
    },
    'kc28t4w6': {
      'es': 'Search...',
      'en': '',
    },
    'leuzelo5': {
      'es': 'Xalapa',
      'en': '',
    },
    '96bts1bb': {
      'es': 'Distrito',
      'en': '',
    },
    'dywt60ib': {
      'es': 'Inmueble',
      'en': '',
    },
    '43f67bmq': {
      'es': 'Inmueble',
      'en': 'Title',
    },
    'vtnn52zw': {
      'es': 'Inmueble',
      'en': 'Post Title',
    },
    'qb5gwhqb': {
      'es': 'Option 1',
      'en': '',
    },
    'xm0zriys': {
      'es': 'Inmueble',
      'en': '',
    },
    '3ph5wwk6': {
      'es': 'Zona',
      'en': 'Title',
    },
    'epf5bp1u': {
      'es': 'Zona',
      'en': 'Post Title',
    },
    'mtn04exo': {
      'es': 'Option 1',
      'en': '',
    },
    'ych0ft3d': {
      'es': 'Serie del monitor',
      'en': 'Title',
    },
    '5uotmzhq': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    '2nmkgx1s': {
      'es': 'Serie del teclado',
      'en': 'Title',
    },
    '95xuzjco': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    '2s49e06x': {
      'es': 'Serie del mouse',
      'en': 'Title',
    },
    '5p81ae5h': {
      'es': 'Serie',
      'en': 'Post Title',
    },
    '82reihk4': {
      'es': 'No aplica',
      'en': '',
    },
    'knvxv1io': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'l1hhiy3g': {
      'es': 'Descripción del bien',
      'en': 'Title',
    },
    'cser5h5m': {
      'es': 'Descripción general del bien',
      'en': 'Post Title',
    },
    'l5ezz8px': {
      'es': 'Descripción general del bien',
      'en': '',
    },
    'us6u4blr': {
      'es': 'Imagen del bien',
      'en': '',
    },
    'woezcns5': {
      'es': 'Imagen del bien',
      'en': '',
    },
    'myaobdze': {
      'es': 'Comentarios adicionales',
      'en': '',
    },
    '3i1nrdqx': {
      'es': 'Comentarios adicionales',
      'en': 'Title',
    },
    'pnco9an1': {
      'es': 'Comentarios adicionales',
      'en': 'Post Title',
    },
    'g1wbc7iv': {
      'es': 'Comentarios adicionales del bien',
      'en': '',
    },
    'hdsgkolt': {
      'es': 'Search...',
      'en': '',
    },
    'xu6o96tg': {
      'es': 'ANEXO 1',
      'en': '',
    },
    'vdtx1zh5': {
      'es': 'ANEXO 2',
      'en': '',
    },
    'br40gezq': {
      'es': 'ANEXO 3',
      'en': '',
    },
    'uc4ucuar': {
      'es': 'ANEXO 4',
      'en': '',
    },
    'rwpgketd': {
      'es': '¿El bien es contable?',
      'en': '',
    },
    'hxo4n14k': {
      'es': '¿Es contable?',
      'en': '',
    },
    'b4erd34m': {
      'es': 'Search...',
      'en': '',
    },
    'f2t1c3q3': {
      'es': 'SI',
      'en': '',
    },
    '3rh1vdc2': {
      'es': 'NO',
      'en': '',
    },
    '1blwu4z4': {
      'es': 'Actualizar',
      'en': 'Save',
    },
    'f0l0pgq9': {
      'es': 'Subir noticia',
      'en': 'Upload news',
    },
  },
  // UbicacionesCopy
  {
    'r7jqnksn': {
      'es': 'Inicio',
      'en': '',
    },
    'ggq6zzc2': {
      'es': 'Salir',
      'en': '',
    },
    'jms2sw0w': {
      'es': 'Nombre de usuario:',
      'en': '',
    },
    '1whxc152': {
      'es': 'Niveles de organización PJEV',
      'en': '',
    },
    '1yej1ntp': {
      'es': 'Crear nuevo nivel',
      'en': '',
    },
    'x0clfzwd': {
      'es': 'Nombre',
      'en': '',
    },
    'dgxv0gnl': {
      'es': 'Nivel 1. Organización',
      'en': '',
    },
    'w5o4awy8': {
      'es': 'Nivel 2. Dirección',
      'en': '',
    },
    '2ctasqm1': {
      'es': 'Nivel 3. Jurisdicción',
      'en': '',
    },
    '4fy5gkcb': {
      'es': 'Inicio',
      'en': 'Home',
    },
  },
  // calendar
  {
    '1mf7cv59': {
      'es': 'Ok',
      'en': 'Ok',
    },
  },
  // califica
  {
    'muparb4t': {
      'es': 'Actualizar calif.',
      'en': 'Update qual.',
    },
    'ptnd6n56': {
      'es': 'Agregar un comentario para este lugar',
      'en': 'Add a comment for this place',
    },
    'kb54pvw6': {
      'es': 'Guardar',
      'en': 'Save',
    },
    'x31fk4mo': {
      'es': 'Calificar este lugar',
      'en': 'rate this place',
    },
    'nl1578qw': {
      'es': 'Agregar un comentario para este lugar',
      'en': 'Add a comment for this place',
    },
    'ogmw5dni': {
      'es': 'Crear',
      'en': 'To create',
    },
  },
  // CalifComponente
  {
    'rry83gnk': {
      'es': 'Calif. Promedio Lugar',
      'en': 'Average Place',
    },
  },
  // CalifComponenteCopy
  {
    '2w5972p3': {
      'es': 'Calif. Promedio Lugar',
      'en': '',
    },
  },
  // CalifComponenteCopyCopy
  {
    'ka52libp': {
      'es': 'Calif. Promedio',
      'en': '',
    },
    '9jrylh0d': {
      'es': 'Hello World',
      'en': '',
    },
  },
  // raiting
  {
    'qc8glf79': {
      'es': 'Hello World',
      'en': '',
    },
  },
  // BuscarInfraccion
  {
    'we2njv8z': {
      'es': 'Actualizar calif.',
      'en': 'Update qual.',
    },
    '99y4i41n': {
      'es': 'Guardar',
      'en': 'Save',
    },
    'rpwikl0y': {
      'es': 'Buscar Comercio\npor clave 5 díg.',
      'en': 'rate this place',
    },
    'b2hbm9hp': {
      'es': 'Escribir clave de 5 dígitos',
      'en': 'Add a comment for this place',
    },
    'tuea9oiz': {
      'es': 'Buscar',
      'en': 'To create',
    },
  },
  // DatosNegocio
  {
    '6z3s809i': {
      'es': 'Nombre Propietario',
      'en': '',
    },
    'ndxh2foa': {
      'es': 'Nombre Propietario',
      'en': 'Add a comment for this place',
    },
    'mqwc9f6b': {
      'es': 'Option 1',
      'en': '',
    },
    'uxy4jsbe': {
      'es': 'Buscar',
      'en': 'To create',
    },
  },
  // BusquedaNombre
  {
    'su75q117': {
      'es': 'Ingresar Nombre Propietario',
      'en': '',
    },
    '8qz0ouf9': {
      'es': 'Option 1',
      'en': '',
    },
    'bhdy2it5': {
      'es': 'Giro',
      'en': '',
    },
    'n5m3myhf': {
      'es': 'QR: ',
      'en': '',
    },
    'k7zgg9fc': {
      'es': 'Pago',
      'en': '',
    },
    'jinyd928': {
      'es': 'IR A FORMATO DE PAGO',
      'en': '',
    },
    's46ldm9w': {
      'es': 'Ver Información',
      'en': '',
    },
    'v097ikwi': {
      'es': 'Editar Info',
      'en': '',
    },
    'txtzb8hf': {
      'es': 'Editar Foto Principal',
      'en': '',
    },
    '57lxh6pt': {
      'es': 'Editar Posición',
      'en': '',
    },
    'ysbw94qu': {
      'es': 'Editar Fotos Complementarias',
      'en': '',
    },
    'znhx96em': {
      'es': 'Eliminar Comercio',
      'en': '',
    },
  },
  // CantidadNueva
  {
    'n4fubafe': {
      'es': 'Actualizar calif.',
      'en': 'Update qual.',
    },
    'i8aat45m': {
      'es': 'Agregar un comentario para este lugar',
      'en': 'Add a comment for this place',
    },
    '2gbjyb1d': {
      'es': 'Guardar',
      'en': 'Save',
    },
  },
  // CantidadNuevaCopy
  {
    'gfpr5yvi': {
      'es': 'Actualizar nombre',
      'en': 'Update qual.',
    },
    '0rc9ief2': {
      'es': 'Agregar un comentario para este lugar',
      'en': 'Add a comment for this place',
    },
    '27z27bb9': {
      'es': 'Guardar',
      'en': 'Save',
    },
  },
  // AgregarElementoPJEV
  {
    '7o9ldxjy': {
      'es': 'Agregar elemento',
      'en': 'rate this place',
    },
    '9hl0818w': {
      'es': 'Ingresar nombre del nuevo elemento',
      'en': '',
    },
    '1sml570w': {
      'es': 'Ingresar nombre',
      'en': 'Add a comment for this place',
    },
    't5ro279q': {
      'es': 'Agregar',
      'en': 'To create',
    },
  },
  // AgregarDepreciacion
  {
    's5qs5r7a': {
      'es': 'Agregar clase de\nactivo para depreciación',
      'en': 'rate this place',
    },
    '2v1xdk6j': {
      'es': 'Ingresar nombre del nuevo elemento',
      'en': '',
    },
    'andmft8j': {
      'es': 'Ingresar nombre',
      'en': 'Add a comment for this place',
    },
    'yefk3a00': {
      'es': '% anual depreciación',
      'en': '',
    },
    'w4fwdqi6': {
      'es': '% depreciación',
      'en': 'Add a comment for this place',
    },
    '7l88ejhd': {
      'es': 'Vida útil en años',
      'en': '',
    },
    'e3zz3ad0': {
      'es': 'Vida útil en años',
      'en': 'Add a comment for this place',
    },
    'c8840twu': {
      'es': 'Agregar',
      'en': 'To create',
    },
  },
  // AgregarOficina
  {
    '96r7skbl': {
      'es': 'Agregar nuevo nivel',
      'en': 'rate this place',
    },
    'r2z37vv1': {
      'es': 'Ingresar nombre del nuevo nivel de organización',
      'en': '',
    },
    'lxjjsdj6': {
      'es': 'Ej.: Juzgado Municipal Huatusco',
      'en': 'Add a comment for this place',
    },
    '64hcl8rm': {
      'es': 'Ingresar nombre nivel 1. Organización',
      'en': '',
    },
    'wlv5bzcd': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'wc2uuvf3': {
      'es': 'Option 1',
      'en': '',
    },
    'j9kad4dl': {
      'es': 'Ingresar nombre nivel 2. Dirección',
      'en': '',
    },
    'heo9qxxg': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'zjkjm8j3': {
      'es': 'Option 1',
      'en': '',
    },
    '09i80m1m': {
      'es': 'Ingresar nombre nivel 3. Jurisdicción',
      'en': '',
    },
    'dbiya7mg': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '8dgt4i55': {
      'es': 'Option 1',
      'en': '',
    },
    '852flcrc': {
      'es': 'Agregar nuevo',
      'en': 'To create',
    },
  },
  // Reportepordespositario
  {
    'pb158jpu': {
      'es': 'Escribir nombre de DEPOSITARIO\ny supervisor para generar PDF.',
      'en': 'rate this place',
    },
    'kl31xvig': {
      'es': 'Depositario',
      'en': '',
    },
    'kjlnfxuw': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'zorcxclj': {
      'es': 'Option 1',
      'en': '',
    },
    'lh4gvqmn': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'oyqwwg18': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    '1a5es1df': {
      'es': 'Option 1',
      'en': '',
    },
    '4xeecmsn': {
      'es': 'Ingresar nombre nivel 2. Dirección',
      'en': '',
    },
    'vx2f4vmg': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'c4wp9klg': {
      'es': 'Option 1',
      'en': '',
    },
    'ykeocqyu': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    '2n27wupp': {
      'es': 'Search...',
      'en': '',
    },
    'xylv11gi': {
      'es': 'Option 1',
      'en': '',
    },
    'xd7j36pq': {
      'es': 'Option 2',
      'en': '',
    },
    'i0h0g3dr': {
      'es': 'Option 3',
      'en': '',
    },
    'qkr39ray': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // AgregarTrabajadorPJEV
  {
    'qbbw9zdj': {
      'es': 'Agregar nuevo nombre de \npersonal',
      'en': 'rate this place',
    },
    'atgx1bcu': {
      'es': 'Ingresar nombre del nuevo elemento',
      'en': '',
    },
    'gbisz2yz': {
      'es': 'Ingresar nombre',
      'en': 'Add a comment for this place',
    },
    '4ljtltwx': {
      'es': 'Ingresar cargo',
      'en': '',
    },
    'svulpa24': {
      'es': 'Ingresar cargo',
      'en': 'Add a comment for this place',
    },
    'g8s3z7o3': {
      'es': 'Agregar',
      'en': 'To create',
    },
  },
  // Reporteporresponsable
  {
    'nsqw2oy7': {
      'es': 'Escribir nombre de RESPONSABLE\ny supervisor para generar PDF.',
      'en': 'rate this place',
    },
    '13ttj5bw': {
      'es': 'Responsable',
      'en': '',
    },
    'bkqy1a5f': {
      'es': 'Responsable',
      'en': 'Add a comment for this place',
    },
    'mts9gfw3': {
      'es': 'Option 1',
      'en': '',
    },
    'sicx1sgg': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'bdjuoycf': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'li3a3x8f': {
      'es': 'Option 1',
      'en': '',
    },
    'k1o5btvu': {
      'es': 'Ingresar nombre nivel 2. Dirección',
      'en': '',
    },
    'hxpw5sg7': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'e5u44fqo': {
      'es': 'Option 1',
      'en': '',
    },
    '33sabeff': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'mh6s0btw': {
      'es': 'Search...',
      'en': '',
    },
    '52f2coka': {
      'es': 'Option 1',
      'en': '',
    },
    'ihr9j596': {
      'es': 'Option 2',
      'en': '',
    },
    'laj42y9r': {
      'es': 'Option 3',
      'en': '',
    },
    'on2886ra': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // ReporteUbicacion2
  {
    '3okahk08': {
      'es': 'Ingresar todos los datos\npara generar PDF.',
      'en': 'rate this place',
    },
    '30ulqggz': {
      'es': 'Depositario',
      'en': '',
    },
    'nmu28tpb': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'llun3tav': {
      'es': 'Option 1',
      'en': '',
    },
    '9i8khrfd': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'ip5pepdi': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'zbr3cpkq': {
      'es': 'Option 1',
      'en': '',
    },
    'aa4yl05m': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    '60rzlbte': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'd9j8diwh': {
      'es': 'Option 1',
      'en': '',
    },
    'zybc6x1x': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    '5y4nwyyu': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'rl7anjz4': {
      'es': 'Option 1',
      'en': '',
    },
    'c88uvie5': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'mzgoq55a': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'ftqix70c': {
      'es': 'Option 1',
      'en': '',
    },
    'rldqpcrk': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'yh8xq2w9': {
      'es': 'Search...',
      'en': '',
    },
    'zqzctjhv': {
      'es': 'Option 1',
      'en': '',
    },
    'wslbudh1': {
      'es': 'Option 2',
      'en': '',
    },
    'rog21qbu': {
      'es': 'Option 3',
      'en': '',
    },
    'czym2kiy': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // ReporteporresponsableCopy
  {
    'yj9vlves': {
      'es': 'Escribir nombre de RESPONSABLE\ny supervisor para generar PDF.',
      'en': 'rate this place',
    },
    'nrlhy8rb': {
      'es': 'Responsable',
      'en': '',
    },
    'rnroh7gm': {
      'es': 'Responsable ',
      'en': 'Add a comment for this place',
    },
    'i8y7lmlj': {
      'es': 'Option 1',
      'en': '',
    },
    'b1dfe6lk': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'xv57nvl6': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'dwx4whv4': {
      'es': 'Option 1',
      'en': '',
    },
    'k1qqn5l1': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // ReporteRESGUARDO
  {
    'f9o3x0tt': {
      'es': 'Generar PDF de resguardo diario',
      'en': 'rate this place',
    },
    'yu5fhjsq': {
      'es': 'Folio de resguardo',
      'en': '',
    },
    'quao4x02': {
      'es': 'Folio',
      'en': 'Add a comment for this place',
    },
    'a6owxthp': {
      'es': 'En atención a:',
      'en': '',
    },
    '44xbwfua': {
      'es': 'Atención a:',
      'en': 'Add a comment for this place',
    },
    'm36mrvts': {
      'es': 'ID del bien:',
      'en': '',
    },
    '4scon9tw': {
      'es': 'ID del bien',
      'en': 'Add a comment for this place',
    },
    'emq84r2v': {
      'es': 'Depositario',
      'en': '',
    },
    'nbn65icb': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'jrocd8dz': {
      'es': 'Option 1',
      'en': '',
    },
    '40ube4t8': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    '4d3bwxae': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    '0fj7lav3': {
      'es': 'Option 1',
      'en': '',
    },
    '6q0qidc6': {
      'es': 'Ingresar nombre nivel 2. Dirección',
      'en': '',
    },
    '4oh1vc73': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'dpcfe8wf': {
      'es': 'Option 1',
      'en': '',
    },
    'hceqj0af': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'emy3n31l': {
      'es': 'Search...',
      'en': '',
    },
    'rc0j8g04': {
      'es': 'Option 1',
      'en': '',
    },
    'b6kend0p': {
      'es': 'Option 2',
      'en': '',
    },
    't1xaqe2g': {
      'es': 'Option 3',
      'en': '',
    },
    'mmlkb2mm': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // ReporteANEXOS
  {
    'spiqxiz2': {
      'es': 'Ingresar nombre nivel 1. ORGANIZACIÓN',
      'en': '',
    },
    'a93rdl76': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '2e9ckzvb': {
      'es': 'Option 1',
      'en': '',
    },
    '6fc45be1': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'kmsfxj8n': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    't379pwzv': {
      'es': 'Option 1',
      'en': '',
    },
    'uu5nsh6q': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '63fot9q6': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'i45l7tgy': {
      'es': 'Option 1',
      'en': '',
    },
    'x1jf3jz1': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'qur8z9ip': {
      'es': 'Search...',
      'en': '',
    },
    'g38tfel2': {
      'es': 'Option 1',
      'en': '',
    },
    '19n1gqyy': {
      'es': 'Option 2',
      'en': '',
    },
    '0tdz8hs5': {
      'es': 'Option 3',
      'en': '',
    },
    'sdo3cyds': {
      'es': 'Continuar',
      'en': 'To create',
    },
  },
  // ReporteUbicacion3
  {
    'flbc1gxx': {
      'es': '¿LOS DATOS SON \nCORRECTOS?',
      'en': 'rate this place',
    },
    '27q66cm7': {
      'es': 'Depositario',
      'en': '',
    },
    's3m57whe': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'yvullve3': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    '6x8mmecw': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'by9pewqr': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    '8qp0ey5q': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'jczvrdp0': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    '5bsmoy9s': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'zgue0qo9': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'to3k0aft': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'w7l9agkj': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'n6uut9pk': {
      'es': 'Search...',
      'en': '',
    },
    'kfs4byuw': {
      'es': 'Option 1',
      'en': '',
    },
    'aokwqrtt': {
      'es': 'Option 2',
      'en': '',
    },
    'x7oheia9': {
      'es': 'Option 3',
      'en': '',
    },
    '800a27dv': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // ReporteUbicacion2b
  {
    'qxeaimaq': {
      'es': 'ANEXO 5. RESGUARDO TOTAL DE \nBIENES MUEBLES',
      'en': 'rate this place',
    },
    'f4xaghkl': {
      'es': 'Depositario',
      'en': '',
    },
    '4yaa3u1i': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'flg60t0n': {
      'es': 'Option 1',
      'en': '',
    },
    'jh5s4tlh': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    '2355y1gt': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'rdx3kw0d': {
      'es': 'Option 1',
      'en': '',
    },
    '4abcdzu2': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    '10bof69l': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '84wytgyw': {
      'es': 'Option 1',
      'en': '',
    },
    'qiw9k8bx': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'wti8oq17': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '5x8sm56t': {
      'es': 'Option 1',
      'en': '',
    },
    'hmv9lk86': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'jv6fu4c7': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'vvtxp5h5': {
      'es': 'Option 1',
      'en': '',
    },
    's6swzjuj': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    '7zz5062q': {
      'es': 'Search...',
      'en': '',
    },
    'tsztx553': {
      'es': 'Option 1',
      'en': '',
    },
    'c78i1e91': {
      'es': 'Option 2',
      'en': '',
    },
    'oc9i7r7t': {
      'es': 'Option 3',
      'en': '',
    },
    '0cmuwnpr': {
      'es': 'Siguiente',
      'en': 'To create',
    },
  },
  // ReporteANEXOSb
  {
    '4egnvwa7': {
      'es': '¿LOS DATOS SON\nCORRECTOS?',
      'en': '',
    },
    '2q86zmh6': {
      'es': 'Ingresar nombre nivel 1. ORGANIZACIÓN',
      'en': '',
    },
    '7jzxcam5': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'j3mm8syo': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    '02tees9v': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '4cf53w6r': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'rmg1ckrx': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'attzdo3l': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'fbtadp5t': {
      'es': 'Search...',
      'en': '',
    },
    '3rbvtszr': {
      'es': 'Option 1',
      'en': '',
    },
    'nuihd3gm': {
      'es': 'Option 2',
      'en': '',
    },
    'mwr49ezu': {
      'es': 'Option 3',
      'en': '',
    },
    'hbdxn7kw': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // ReporteANEXOSCopy
  {
    's8c7lyao': {
      'es': 'Ingresar todos los datos\npara generar PDF.',
      'en': '',
    },
    'kdfwuty9': {
      'es': 'Ingresar nombre nivel 1. ORGANIZACIÓN',
      'en': '',
    },
    'sjx8uw9v': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '2hb6y736': {
      'es': 'Option 1',
      'en': '',
    },
    '0a5rr0vf': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    '1o1vklrs': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'rpj2s0pm': {
      'es': 'Option 1',
      'en': '',
    },
    'shrte3i1': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '14rje099': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'h4don4f4': {
      'es': 'Option 1',
      'en': '',
    },
    '1a4569fb': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    '6boljcfl': {
      'es': 'Search...',
      'en': '',
    },
    'rjnk0slo': {
      'es': 'Option 1',
      'en': '',
    },
    'phn16cyy': {
      'es': 'Option 2',
      'en': '',
    },
    '63pl171g': {
      'es': 'Option 3',
      'en': '',
    },
    'd4rsbf1q': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // AgregarOficina2
  {
    'vrqwjtok': {
      'es':
          'Sincronizar en caso de que\nalgún usuario haya\nagregado algún nuevo \nnivel de organización, el cual aún\nno esté reflejado en las \nlistas actualmente.\n',
      'en': 'rate this place',
    },
    'l9lnp8r1': {
      'es': 'Sincronizar',
      'en': 'To create',
    },
  },
  // BuscarID
  {
    'zy7rqep8': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    'laixyxav': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'zgz1fz37': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    'pjqu6zp2': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // Bajavale
  {
    'cux9tyoj': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    'vcqwhj8n': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'l6cd6gfd': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    'l6peathm': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // Mantenimiento
  {
    'hve9hjlq': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    'bts6z9e2': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'w9smqji9': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    'uaepnv23': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // BuscarBien
  {
    'm4adwt6n': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    'kzxf1qxh': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'k0f1p5ff': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    '6382wxvm': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // AgregarOficina2Copy
  {
    'sn14zswi': {
      'es':
          'Sincronizar en caso de que\nalgún usuario haya\nagregado algún nuevo \nnivel de organización, el cual aún\nno esté reflejado en las \nlistas actualmente.\n',
      'en': 'rate this place',
    },
    '25jjmc8o': {
      'es': 'Sincronizar',
      'en': 'To create',
    },
  },
  // BuscarIDTransferencia
  {
    'ipt8q6n4': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    '717klxot': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'dkxxztc8': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    '5otoscxo': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // ReporteVale
  {
    'tarq0xkk': {
      'es': 'REPORTE DE VALE DE MOVIMIENTO',
      'en': 'rate this place',
    },
    'pz0kjwu1': {
      'es': 'Folio del vale correspondiente',
      'en': '',
    },
    'g736xpb2': {
      'es': 'Folio del vale',
      'en': 'Add a comment for this place',
    },
    's9i1rq8r': {
      'es': 'Información adicional a incluir en el reporte',
      'en': '',
    },
    'b47xr3uq': {
      'es': 'Información adicional',
      'en': 'Add a comment for this place',
    },
    'yd03h6n8': {
      'es': 'Depositario',
      'en': '',
    },
    'eog8gvp5': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'g86c5w36': {
      'es': 'Option 1',
      'en': '',
    },
    'gwuzcb3v': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'yiamynwq': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'sey2wp8l': {
      'es': 'Option 1',
      'en': '',
    },
    'q5nvyif8': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'bbqnwh5z': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '1mlpzhjt': {
      'es': 'Option 1',
      'en': '',
    },
    'yhgvuii6': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'i2486ifq': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'dvsobo16': {
      'es': 'Option 1',
      'en': '',
    },
    'g57c3ffm': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '7mm1vnh4': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '4ztsik67': {
      'es': 'Option 1',
      'en': '',
    },
    'te4u228n': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    'jzhxtxl9': {
      'es': 'Search...',
      'en': '',
    },
    'bd42sdt8': {
      'es': 'Option 1',
      'en': '',
    },
    'mbnf4jhg': {
      'es': 'Option 2',
      'en': '',
    },
    'ikmbzojq': {
      'es': 'Option 3',
      'en': '',
    },
    'ys2gzoo2': {
      'es': 'Siguiente',
      'en': 'To create',
    },
  },
  // ReporteVale2
  {
    '4y82u41g': {
      'es': '¿LOS DATOS SON \nCORRECTOS?',
      'en': 'rate this place',
    },
    'aaboi42l': {
      'es': 'Depositario',
      'en': '',
    },
    'w8hlrhrz': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    '9vtqmzhv': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'jtvrv6oj': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'h6zg92yu': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'ifwiju3q': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '2wxf3cn1': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'tnfbiqy1': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'zrd7pfja': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '8eudm3gu': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'b8b1k948': {
      'es': 'SELECCIONAR DISTRITO',
      'en': '',
    },
    '2z1gusya': {
      'es': 'Search...',
      'en': '',
    },
    '36l4wuct': {
      'es': 'Option 1',
      'en': '',
    },
    'z41x1mz8': {
      'es': 'Option 2',
      'en': '',
    },
    '0bphay0v': {
      'es': 'Option 3',
      'en': '',
    },
    '4ely4c24': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // Excel
  {
    'pdjjb5c3': {
      'es': 'ESPERAR BOTÓN',
      'en': 'rate this place',
    },
    'gmwxpvyn': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    '5xmv9w0a': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    '958kkhk1': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // Transferenciamasiva
  {
    'r1m511yu': {
      'es': 'DEFINIR CAMPOS PARA\nTRANSFERENCIA MASIVA',
      'en': 'rate this place',
    },
    '6944x66p': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'y2w440by': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '52py63r5': {
      'es': 'Option 1',
      'en': '',
    },
    '6bxw7kz2': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'f31zjbsm': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '5zpclxjf': {
      'es': 'Option 1',
      'en': '',
    },
    '7d953rv3': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'zzhcutys': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '4lkx0y3g': {
      'es': 'Option 1',
      'en': '',
    },
    'w6832dli': {
      'es': 'Siguiente',
      'en': 'To create',
    },
  },
  // Transferenciamasiva3
  {
    'yb4gwm81': {
      'es': '¿LOS DATOS SON \nCORRECTOS?',
      'en': 'rate this place',
    },
    'md6763ul': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    '65o1ptid': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'yfl3cv0b': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'pb6ue0qi': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'uuvo07ey': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '19d8hnaf': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'q3gjbfpk': {
      'es': 'Ir a consulta',
      'en': 'To create',
    },
  },
  // BuscarBienSerie
  {
    '0sjr07up': {
      'es': 'INGRESAR LA SERIE\nDEL BIEN',
      'en': 'rate this place',
    },
    'quo4mfzb': {
      'es': 'Ingresar número de serie del bien',
      'en': '',
    },
    'ol5hipx8': {
      'es': 'Número de serie',
      'en': 'Add a comment for this place',
    },
    '3xkdqjma': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // BuscarBien2
  {
    '2i4eifo8': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    'e3av1gu6': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    '1doarjun': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    'r218bbko': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // BuscarBien2b
  {
    'akpkpisw': {
      'es': 'Regresar',
      'en': '',
    },
    'rwrimnq1': {
      'es': 'ESTADO DEL BIEN: ',
      'en': '',
    },
    '0kc9ukl8': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'w8txfvay': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    'jzi35wl2': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'od2w8mut': {
      'es': 'Option 1',
      'en': '',
    },
    '8onmeeo0': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'kuk55k7c': {
      'es': 'ID',
      'en': '',
    },
    '4okd7q54': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'bnqcxbjt': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    '0b1xiy29': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    'jiof3q9k': {
      'es': 'ID anterior',
      'en': '',
    },
    'sxf6nyyd': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    'yksob4fp': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    'qnq99nnv': {
      'es': 'ID anterior del bien',
      'en': '',
    },
    '93hb2ui9': {
      'es': 'Importe',
      'en': '',
    },
    '8ufd6el3': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'qrkmwv4u': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'asr1zfwn': {
      'es': 'Importe del bien',
      'en': '',
    },
    'wm5tnga8': {
      'es': 'Depositario',
      'en': '',
    },
    'qeq7gbc5': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    '99qmwy4d': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    '883gneec': {
      'es': 'Option 1',
      'en': '',
    },
    '2bofezzy': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'yjiujwfg': {
      'es': 'Usuario',
      'en': '',
    },
    'ezn96xoy': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'vstpcj0v': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'lywmcm1g': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'x2pnt7zk': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    'zyy9bn07': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'isb2agq3': {
      'es': 'Option 1',
      'en': '',
    },
    '3p1795sg': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    '5zhcx7ai': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '2e5928tz': {
      'es': 'Option 1',
      'en': '',
    },
    '7cvcv1o0': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    'npxdoiu7': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'prxyc8ml': {
      'es': 'Option 1',
      'en': '',
    },
    'zzals998': {
      'es': 'Agregar',
      'en': 'Save',
    },
    '77h368tn': {
      'es': '+ Agregar',
      'en': 'Save',
    },
    '8fsonnap': {
      'es': 'ID no localizado. Regresar',
      'en': '',
    },
  },
  // almacen1
  {
    'h679sdvs': {
      'es': 'BUSCAR DISPONIBILIDAD\nEN ALMACEN',
      'en': 'rate this place',
    },
    'g71pygui': {
      'es': 'CATEGORÍA DE BIEN',
      'en': '',
    },
    '6bjrs0ub': {
      'es': 'Teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '8ot4zlwo': {
      'es': 'Option 1',
      'en': '',
    },
    'oc4sl68z': {
      'es': 'Siguiente',
      'en': 'To create',
    },
  },
  // almacen2
  {
    'sveea8ri': {
      'es': '¿LOS DATOS SON \nCORRECTOS?',
      'en': 'rate this place',
    },
    'aby7sqjt': {
      'es': 'CATEGORÍA DEL BIEN',
      'en': '',
    },
    'v0gdsc6x': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'z7k2tny9': {
      'es': 'Ir a consulta',
      'en': 'To create',
    },
  },
  // almacenactualizar
  {
    'c0f4cjks': {
      'es':
          'Sincronizar en caso de que\nalgún usuario haya\nagregado algún nuevo \nbien',
      'en': 'rate this place',
    },
    '9p93azke': {
      'es': 'Sincronizar',
      'en': 'To create',
    },
  },
  // ListaBienes
  {
    'po0bce5k': {
      'es': 'Total de pendientes: ',
      'en': '',
    },
    'i1u5l9jt': {
      'es': 'Nombre: ',
      'en': '',
    },
    'ozfykg03': {
      'es': 'Id: ',
      'en': '',
    },
    '3lg2pr96': {
      'es': 'Id anterior: ',
      'en': '',
    },
    'ctwy8af2': {
      'es': 'Descripción: ',
      'en': '',
    },
    '1y80bsml': {
      'es': 'Importe:',
      'en': '',
    },
    'bg2t5lo7': {
      'es': 'Depositario: ',
      'en': '',
    },
    'lrw206f4': {
      'es': 'Organización: ',
      'en': '',
    },
    'yf2u1ey5': {
      'es': 'Dirección: ',
      'en': '',
    },
    'dibf3xb4': {
      'es': 'Jurisdicción: ',
      'en': '',
    },
  },
  // EditarUsuario
  {
    'xohgey4r': {
      'es': 'Editar información de usuario',
      'en': 'rate this place',
    },
    'f2yzb62c': {
      'es': 'Nombre',
      'en': '',
    },
    '441avp18': {
      'es': 'Teléfono',
      'en': '',
    },
    '88ndqk34': {
      'es': 'Nivel de permiso',
      'en': 'rate this place',
    },
    'k57640i6': {
      'es': '',
      'en': '',
    },
    'e33q4x6h': {
      'es': 'Search...',
      'en': '',
    },
    '50etzbbs': {
      'es': 'Administrador',
      'en': '',
    },
    'w3cc2a2e': {
      'es': 'Bodega',
      'en': '',
    },
    '3frzxqqe': {
      'es': 'Editor',
      'en': '',
    },
    'y1gguitu': {
      'es': 'Lectura',
      'en': '',
    },
    'yilr69i2': {
      'es': 'Nivel de responsable',
      'en': 'rate this place',
    },
    'qh0xkds8': {
      'es': '',
      'en': '',
    },
    '52yhcewr': {
      'es': 'Search...',
      'en': '',
    },
    'erp468tj': {
      'es': 'RESPONSABLE 1',
      'en': '',
    },
    'y4skwg1s': {
      'es': 'RESPONSABLE 2',
      'en': '',
    },
    'fbh1obwi': {
      'es': 'RESPONSABLE 3',
      'en': '',
    },
    'apdrl1at': {
      'es': 'RESPONSABLE 4',
      'en': '',
    },
    'iz3jgd97': {
      'es': 'RESPONSABLE 5',
      'en': '',
    },
    'vymok26z': {
      'es': 'RESPONSABLE 6',
      'en': '',
    },
    'f8juraq9': {
      'es': 'RESPONSABLE 7',
      'en': '',
    },
    'efsp0trb': {
      'es': 'RESPONSABLE 8',
      'en': '',
    },
    '3iq32ho6': {
      'es': 'Guardar cambios',
      'en': '',
    },
  },
  // BuscarValePorFolio
  {
    'v5kqgso3': {
      'es': 'INGRESAR EL FOLIO DEL VALE',
      'en': 'rate this place',
    },
    '13zzthno': {
      'es': 'Ingresar el folio del vale',
      'en': '',
    },
    'kl79jzsh': {
      'es': 'Número de folio del vale',
      'en': '',
    },
    '2j71attj': {
      'es': 'Buscar',
      'en': 'To create',
    },
  },
  // EditImgActivo
  {
    '62cwnx91': {
      'es': 'Editar imagen de activo',
      'en': 'rate this place',
    },
    '1cciuurv': {
      'es': 'Imagen actual',
      'en': '',
    },
    '6e83oz3u': {
      'es': 'Nueva imagen',
      'en': '',
    },
    'ndkv4mtf': {
      'es': 'Guardar cambio',
      'en': 'To create',
    },
  },
  // Reporteporusuario
  {
    'i2tamdn2': {
      'es': 'RESGUARDO POR USUARIO',
      'en': 'rate this place',
    },
    'nu0cygbk': {
      'es': 'Nombre del usuario',
      'en': '',
    },
    'rrum9qoa': {
      'es': 'Usuario',
      'en': 'Add a comment for this place',
    },
    'ia59kxmz': {
      'es': 'Option 1',
      'en': '',
    },
    'gzpnnu4r': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'ukmqqgjb': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    '27dccpb5': {
      'es': 'Option 1',
      'en': '',
    },
    'enyopnre': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    '90iye7ga': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'vxjwb86j': {
      'es': 'Option 1',
      'en': '',
    },
    '8ofr2doe': {
      'es': 'Search...',
      'en': '',
    },
    'opptl0ap': {
      'es': 'Option 1',
      'en': '',
    },
    'sn6qwb15': {
      'es': 'Option 2',
      'en': '',
    },
    'na6mw1k6': {
      'es': 'Option 3',
      'en': '',
    },
    'p6etemwd': {
      'es': 'Siguiente',
      'en': 'To create',
    },
  },
  // Reporteporusuario2
  {
    'n0o7jgg9': {
      'es': '¿LOS DATOS SON \nCORRECTOS?',
      'en': 'rate this place',
    },
    'lo0wr1vb': {
      'es': 'Depositario',
      'en': '',
    },
    'qfxya8ej': {
      'es': 'Depositario',
      'en': 'Add a comment for this place',
    },
    'zllfefho': {
      'es': 'Supervisor de Control de Inventarios',
      'en': '',
    },
    'wxgrjbt0': {
      'es': 'Supervisor del área de Control de Inventarios',
      'en': 'Add a comment for this place',
    },
    'p2rkn97g': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'jxulpxk6': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '9obvdc28': {
      'es': 'Search...',
      'en': '',
    },
    '0czyjz0p': {
      'es': 'Option 1',
      'en': '',
    },
    'r9613x9w': {
      'es': 'Option 2',
      'en': '',
    },
    'ldo2sqs8': {
      'es': 'Option 3',
      'en': '',
    },
    '6w1jbo6l': {
      'es': 'Descargar PDF',
      'en': 'To create',
    },
  },
  // Etiquetas
  {
    'joqs4hp5': {
      'es': 'ELEGIR MODO DE\nIMPRESION',
      'en': 'rate this place',
    },
    'uk0bwt4c': {
      'es': 'Generar etiqueta',
      'en': '',
    },
    'lxpktkt0': {
      'es': 'Generar por lote',
      'en': '',
    },
    '5einxxrc': {
      'es': 'Cargar archivo',
      'en': '',
    },
  },
  // BuscarBien2Copy
  {
    'ijq5gjz7': {
      'es': 'INGRESAR EL ID\nDEL BIEN',
      'en': 'rate this place',
    },
    '7vciyie3': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'nzh89sgq': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    '4bztzrnm': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // BuscarBien2bCopy
  {
    'yikbu923': {
      'es': 'Regresar',
      'en': '',
    },
    'cnv358fu': {
      'es': 'ESTADO DEL BIEN: ',
      'en': '',
    },
    'olk2du4r': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'kxi5vpvw': {
      'es': 'Nombre artículo',
      'en': 'Title',
    },
    '6qhypre6': {
      'es': 'Nombre artículo',
      'en': 'Post Title',
    },
    'v5t5qu9z': {
      'es': 'Option 1',
      'en': '',
    },
    'shld72t3': {
      'es': 'Nombre artículo',
      'en': '',
    },
    'hbocgco3': {
      'es': 'ID',
      'en': '',
    },
    'axpvqsmv': {
      'es': 'Inventario',
      'en': 'Title',
    },
    'jxyns20r': {
      'es': 'Número de ID',
      'en': 'Post Title',
    },
    '15sxlk0v': {
      'es': 'Número de ID del bien',
      'en': '',
    },
    '6u888hb2': {
      'es': 'ID anterior',
      'en': '',
    },
    'x2xqitz1': {
      'es': 'ID anterior',
      'en': 'Title',
    },
    '5w1vuwy6': {
      'es': 'Número de ID anterior',
      'en': 'Post Title',
    },
    'r5np5c0g': {
      'es': 'ID anterior del bien',
      'en': '',
    },
    'azfytkao': {
      'es': 'Importe',
      'en': '',
    },
    'q2x9yxdx': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Title',
    },
    'hozsd8hc': {
      'es': 'Costo del bien (\$) contra factura',
      'en': 'Post Title',
    },
    'rp9t8bhm': {
      'es': 'Importe del bien',
      'en': '',
    },
    '52gs74o7': {
      'es': 'Depositario',
      'en': '',
    },
    'nu2et1v4': {
      'es': 'Depositario del bien',
      'en': 'Title',
    },
    '2jnzoiif': {
      'es': 'Nombre del depositario',
      'en': 'Post Title',
    },
    'gib2dqgs': {
      'es': 'Option 1',
      'en': '',
    },
    'ypmz8uiu': {
      'es': 'Nombre del depositario, quien es el titular del bien',
      'en': '',
    },
    'mxizn3wq': {
      'es': 'Usuario',
      'en': '',
    },
    'miazcibw': {
      'es': 'Usuario',
      'en': 'Title',
    },
    'ir5vv0fu': {
      'es': 'Nombre de depositario',
      'en': 'Post Title',
    },
    'nf97t067': {
      'es': 'Nombre del usuario del Bien',
      'en': '',
    },
    'phis982q': {
      'es': 'ORGANIZACIÓN',
      'en': '',
    },
    't83g665x': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'jakl449d': {
      'es': 'Option 1',
      'en': '',
    },
    '5s1jfvo3': {
      'es': 'Ingresar nombre nivel 2. DIRECCIÓN',
      'en': '',
    },
    'gq8pilt2': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    '4o9w9zno': {
      'es': 'Option 1',
      'en': '',
    },
    'umb7r8wt': {
      'es': 'Ingresar nombre nivel 3. JURISDICCIÓN',
      'en': '',
    },
    '1ooh67kr': {
      'es': 'teclear para autocompletar',
      'en': 'Add a comment for this place',
    },
    'ytde8lgn': {
      'es': 'Option 1',
      'en': '',
    },
    'xf17mrys': {
      'es': 'Agregar',
      'en': 'Save',
    },
  },
  // BuscarBienCopy
  {
    'v8om83eu': {
      'es': 'INGRESAR EL ID-ANTERIOR\nDEL BIEN',
      'en': 'rate this place',
    },
    'vz0nfmsw': {
      'es': 'Ingresar el ID del bien',
      'en': '',
    },
    'a4sytp2x': {
      'es': 'Número de inventario del bien',
      'en': 'Add a comment for this place',
    },
    'lur6tzlc': {
      'es': 'Buscar bien',
      'en': 'To create',
    },
  },
  // Miscellaneous
  {
    'i0524boo': {
      'es': '',
      'en': '',
    },
    'jn7uaqxc': {
      'es': '',
      'en': '',
    },
    'hc09mrfx': {
      'es': '',
      'en': '',
    },
    '9gsiaf8l': {
      'es': '',
      'en': '',
    },
    '7xjhzxbi': {
      'es': '',
      'en': '',
    },
    '477g005d': {
      'es': '',
      'en': '',
    },
    'j6dful3j': {
      'es': '',
      'en': '',
    },
    'f58dscug': {
      'es': 'No coincide contraseña',
      'en': 'password does not match',
    },
    '26zhpg91': {
      'es': '',
      'en': '',
    },
    'ck6n7xo9': {
      'es': '',
      'en': '',
    },
    'lbqw8mer': {
      'es': '',
      'en': '',
    },
    't3todpld': {
      'es': '',
      'en': '',
    },
    'xhscp4bn': {
      'es': '',
      'en': '',
    },
    'p8kaumph': {
      'es': '',
      'en': '',
    },
    'p8t07m6p': {
      'es': '',
      'en': '',
    },
    '9ghr4ahp': {
      'es': 'Subiendo archivo...',
      'en': 'Uploading file...',
    },
    '53vzt4no': {
      'es': '¡Correcto!',
      'en': 'Correct!',
    },
    'hs6uf45z': {
      'es': '',
      'en': '',
    },
    'jv5vpyu8': {
      'es': '',
      'en': '',
    },
    'bi3qa3wd': {
      'es': 'Elegir fuente',
      'en': 'choose font',
    },
    'sfnky9tq': {
      'es': 'Galería',
      'en': 'Gallery',
    },
    'rw7ry0dn': {
      'es': 'Galería (Foto)',
      'en': 'Gallery (Photo)',
    },
    'd53jtcci': {
      'es': 'Galería (Video)',
      'en': 'Gallery (Video)',
    },
    '0iivppaf': {
      'es': 'Cámara',
      'en': 'Camera',
    },
    '7gnhn019': {
      'es': '',
      'en': '',
    },
    'djlq8v52': {
      'es': '',
      'en': '',
    },
    '9hworupl': {
      'es': '',
      'en': '',
    },
    'at1nhc62': {
      'es': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
