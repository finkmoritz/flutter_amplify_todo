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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the TodoLabel type in your schema. */
@immutable
class TodoLabel extends Model {
  static const classType = const _TodoLabelModelType();
  final String id;
  final Todo? _todo;
  final Label? _label;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  Todo get todo {
    try {
      return _todo!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Label get label {
    try {
      return _label!;
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
  
  const TodoLabel._internal({required this.id, required todo, required label, createdAt, updatedAt}): _todo = todo, _label = label, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory TodoLabel({String? id, required Todo todo, required Label label}) {
    return TodoLabel._internal(
      id: id == null ? UUID.getUUID() : id,
      todo: todo,
      label: label);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TodoLabel &&
      id == other.id &&
      _todo == other._todo &&
      _label == other._label;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TodoLabel {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("todo=" + (_todo != null ? _todo!.toString() : "null") + ", ");
    buffer.write("label=" + (_label != null ? _label!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TodoLabel copyWith({String? id, Todo? todo, Label? label}) {
    return TodoLabel._internal(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      label: label ?? this.label);
  }
  
  TodoLabel.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _todo = json['todo']?['serializedData'] != null
        ? Todo.fromJson(new Map<String, dynamic>.from(json['todo']['serializedData']))
        : null,
      _label = json['label']?['serializedData'] != null
        ? Label.fromJson(new Map<String, dynamic>.from(json['label']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'todo': _todo?.toJson(), 'label': _label?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField TODO = QueryField(
    fieldName: "todo",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Todo).toString()));
  static final QueryField LABEL = QueryField(
    fieldName: "label",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Label).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TodoLabel";
    modelSchemaDefinition.pluralName = "TodoLabels";
    
    modelSchemaDefinition.indexes = [
      ModelIndex(fields: const ["todoID"], name: "byTodo"),
      ModelIndex(fields: const ["labelID"], name: "byLabel")
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
      key: TodoLabel.TODO,
      isRequired: true,
      targetName: "todoID",
      ofModelName: (Todo).toString()
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
      key: TodoLabel.LABEL,
      isRequired: true,
      targetName: "labelID",
      ofModelName: (Label).toString()
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

class _TodoLabelModelType extends ModelType<TodoLabel> {
  const _TodoLabelModelType();
  
  @override
  TodoLabel fromJson(Map<String, dynamic> jsonData) {
    return TodoLabel.fromJson(jsonData);
  }
}