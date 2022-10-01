/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Label type in your schema. */
@immutable
class Label extends Model {
  static const classType = const _LabelModelType();
  final String id;
  final List<TodoLabel>? _todos;
  final String? _name;
  final LabelColor? _color;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  List<TodoLabel>? get todos {
    return _todos;
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  LabelColor get color {
    try {
      return _color!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Label._internal({required this.id, todos, required name, required color, createdAt, updatedAt}): _todos = todos, _name = name, _color = color, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Label({String? id, List<TodoLabel>? todos, required String name, required LabelColor color}) {
    return Label._internal(
      id: id == null ? UUID.getUUID() : id,
      todos: todos != null ? List<TodoLabel>.unmodifiable(todos) : todos,
      name: name,
      color: color);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Label &&
      id == other.id &&
      DeepCollectionEquality().equals(_todos, other._todos) &&
      _name == other._name &&
      _color == other._color;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Label {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("color=" + (_color != null ? enumToString(_color)! : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Label copyWith({String? id, List<TodoLabel>? todos, String? name, LabelColor? color}) {
    return Label._internal(
      id: id ?? this.id,
      todos: todos ?? this.todos,
      name: name ?? this.name,
      color: color ?? this.color);
  }
  
  Label.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _todos = json['todos'] is List
        ? (json['todos'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => TodoLabel.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _name = json['name'],
      _color = enumFromString<LabelColor>(json['color'], LabelColor.values),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'todos': _todos?.map((TodoLabel? e) => e?.toJson()).toList(), 'name': _name, 'color': enumToString(_color), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField TODOS = QueryField(
    fieldName: "todos",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (TodoLabel).toString()));
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField COLOR = QueryField(fieldName: "color");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Label";
    modelSchemaDefinition.pluralName = "Labels";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Label.TODOS,
      isRequired: false,
      ofModelName: (TodoLabel).toString(),
      associatedKey: TodoLabel.LABEL
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Label.NAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Label.COLOR,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _LabelModelType extends ModelType<Label> {
  const _LabelModelType();
  
  @override
  Label fromJson(Map<String, dynamic> jsonData) {
    return Label.fromJson(jsonData);
  }
}