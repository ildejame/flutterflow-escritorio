// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EmpleadosStruct extends FFFirebaseStruct {
  EmpleadosStruct({
    String? id,
    String? nombre,
    String? iDempleado,
    DateTime? fechamodificacio,
    String? estatus,
    String? ubicacion,
    DateTime? created,
    DateTime? updated,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _nombre = nombre,
        _iDempleado = iDempleado,
        _fechamodificacio = fechamodificacio,
        _estatus = estatus,
        _ubicacion = ubicacion,
        _created = created,
        _updated = updated,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "Nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  // "IDempleado" field.
  String? _iDempleado;
  String get iDempleado => _iDempleado ?? '';
  set iDempleado(String? val) => _iDempleado = val;

  bool hasIDempleado() => _iDempleado != null;

  // "fechamodificacio" field.
  DateTime? _fechamodificacio;
  DateTime? get fechamodificacio => _fechamodificacio;
  set fechamodificacio(DateTime? val) => _fechamodificacio = val;

  bool hasFechamodificacio() => _fechamodificacio != null;

  // "estatus" field.
  String? _estatus;
  String get estatus => _estatus ?? '';
  set estatus(String? val) => _estatus = val;

  bool hasEstatus() => _estatus != null;

  // "ubicacion" field.
  String? _ubicacion;
  String get ubicacion => _ubicacion ?? '';
  set ubicacion(String? val) => _ubicacion = val;

  bool hasUbicacion() => _ubicacion != null;

  // "created" field.
  DateTime? _created;
  DateTime? get created => _created;
  set created(DateTime? val) => _created = val;

  bool hasCreated() => _created != null;

  // "updated" field.
  DateTime? _updated;
  DateTime? get updated => _updated;
  set updated(DateTime? val) => _updated = val;

  bool hasUpdated() => _updated != null;

  static EmpleadosStruct fromMap(Map<String, dynamic> data) => EmpleadosStruct(
        id: data['id'] as String?,
        nombre: data['Nombre'] as String?,
        iDempleado: data['IDempleado'] as String?,
        fechamodificacio: data['fechamodificacio'] as DateTime?,
        estatus: data['estatus'] as String?,
        ubicacion: data['ubicacion'] as String?,
        created: data['created'] as DateTime?,
        updated: data['updated'] as DateTime?,
      );

  static EmpleadosStruct? maybeFromMap(dynamic data) => data is Map
      ? EmpleadosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'Nombre': _nombre,
        'IDempleado': _iDempleado,
        'fechamodificacio': _fechamodificacio,
        'estatus': _estatus,
        'ubicacion': _ubicacion,
        'created': _created,
        'updated': _updated,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'Nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
        'IDempleado': serializeParam(
          _iDempleado,
          ParamType.String,
        ),
        'fechamodificacio': serializeParam(
          _fechamodificacio,
          ParamType.DateTime,
        ),
        'estatus': serializeParam(
          _estatus,
          ParamType.String,
        ),
        'ubicacion': serializeParam(
          _ubicacion,
          ParamType.String,
        ),
        'created': serializeParam(
          _created,
          ParamType.DateTime,
        ),
        'updated': serializeParam(
          _updated,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static EmpleadosStruct fromSerializableMap(Map<String, dynamic> data) =>
      EmpleadosStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nombre: deserializeParam(
          data['Nombre'],
          ParamType.String,
          false,
        ),
        iDempleado: deserializeParam(
          data['IDempleado'],
          ParamType.String,
          false,
        ),
        fechamodificacio: deserializeParam(
          data['fechamodificacio'],
          ParamType.DateTime,
          false,
        ),
        estatus: deserializeParam(
          data['estatus'],
          ParamType.String,
          false,
        ),
        ubicacion: deserializeParam(
          data['ubicacion'],
          ParamType.String,
          false,
        ),
        created: deserializeParam(
          data['created'],
          ParamType.DateTime,
          false,
        ),
        updated: deserializeParam(
          data['updated'],
          ParamType.DateTime,
          false,
        ),
      );

  static EmpleadosStruct fromAlgoliaData(Map<String, dynamic> data) =>
      EmpleadosStruct(
        id: convertAlgoliaParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nombre: convertAlgoliaParam(
          data['Nombre'],
          ParamType.String,
          false,
        ),
        iDempleado: convertAlgoliaParam(
          data['IDempleado'],
          ParamType.String,
          false,
        ),
        fechamodificacio: convertAlgoliaParam(
          data['fechamodificacio'],
          ParamType.DateTime,
          false,
        ),
        estatus: convertAlgoliaParam(
          data['estatus'],
          ParamType.String,
          false,
        ),
        ubicacion: convertAlgoliaParam(
          data['ubicacion'],
          ParamType.String,
          false,
        ),
        created: convertAlgoliaParam(
          data['created'],
          ParamType.DateTime,
          false,
        ),
        updated: convertAlgoliaParam(
          data['updated'],
          ParamType.DateTime,
          false,
        ),
        firestoreUtilData: FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'EmpleadosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EmpleadosStruct &&
        id == other.id &&
        nombre == other.nombre &&
        iDempleado == other.iDempleado &&
        fechamodificacio == other.fechamodificacio &&
        estatus == other.estatus &&
        ubicacion == other.ubicacion &&
        created == other.created &&
        updated == other.updated;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        nombre,
        iDempleado,
        fechamodificacio,
        estatus,
        ubicacion,
        created,
        updated
      ]);
}

EmpleadosStruct createEmpleadosStruct({
  String? id,
  String? nombre,
  String? iDempleado,
  DateTime? fechamodificacio,
  String? estatus,
  String? ubicacion,
  DateTime? created,
  DateTime? updated,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EmpleadosStruct(
      id: id,
      nombre: nombre,
      iDempleado: iDempleado,
      fechamodificacio: fechamodificacio,
      estatus: estatus,
      ubicacion: ubicacion,
      created: created,
      updated: updated,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EmpleadosStruct? updateEmpleadosStruct(
  EmpleadosStruct? empleados, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    empleados
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEmpleadosStructData(
  Map<String, dynamic> firestoreData,
  EmpleadosStruct? empleados,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (empleados == null) {
    return;
  }
  if (empleados.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && empleados.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final empleadosData = getEmpleadosFirestoreData(empleados, forFieldValue);
  final nestedData = empleadosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = empleados.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEmpleadosFirestoreData(
  EmpleadosStruct? empleados, [
  bool forFieldValue = false,
]) {
  if (empleados == null) {
    return {};
  }
  final firestoreData = mapToFirestore(empleados.toMap());

  // Add any Firestore field values
  mapToFirestore(empleados.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEmpleadosListFirestoreData(
  List<EmpleadosStruct>? empleadoss,
) =>
    empleadoss?.map((e) => getEmpleadosFirestoreData(e, true)).toList() ?? [];
