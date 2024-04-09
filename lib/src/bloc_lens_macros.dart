// ignore_for_file: deprecated_member_use

import 'package:collection/collection.dart';
import 'package:macros/macros.dart';
import 'package:meta/meta_meta.dart';

// FIXME: doesn't carry over to metadata
@Target({TargetKind.field})
class NumberOptions<T extends num> {
  const NumberOptions({
    this.min,
    this.max,
    this.step,
  });

  final T? min;
  final T? max;
  final T? step;
}

macro class MakeLenses implements ClassDeclarationsMacro {
  const MakeLenses();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    var superclass = await clazz.superclass?.dereferenceTypedef(builder);
    var isBlocBase = false;
    while (superclass is NamedTypeAnnotation) {
      final identifier = superclass.identifier;
      if (identifier.name == 'BlocBase') {
        isBlocBase = true;
        break;
      }
      final superDeclaration = await builder.typeDeclarationOf(identifier);
      superclass = switch (superDeclaration) {
        ClassDeclaration(:final superclass) =>
          await superclass?.dereferenceTypedef(builder),
        _ => null,
      };
    }

    if (!isBlocBase) {
      builder.error(
        'The class ${clazz.identifier.name} is not a subclass of BlocBase',
        target: clazz.asDiagnosticTarget,
      );
      return;
    }

    final stateType =
        await clazz.superclass!.typeArguments.first.dereferenceTypedef(builder);

    switch (stateType) {
      case NamedTypeAnnotation():
        await buildLensesForNamedType(clazz, builder, stateType);
      case RecordTypeAnnotation():
        await buildLensesForRecord(clazz, builder, stateType);
      default:
        builder.error(
          'The class ${clazz.identifier.name} has an invalid state type',
          target: clazz.asDiagnosticTarget,
        );
    }
  }

  Future<void> buildLensesForNamedType(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
    NamedTypeAnnotation stateType,
  ) async {
    final declaration = await builder.typeDeclarationOf(stateType.identifier);
    final constructors = await builder.constructorsOf(declaration);
    final constructor = constructors.firstWhereOrNull(
      (e) => e.identifier.name == '',
    );
    if (constructor == null) {
      builder.error(
        'The state class ${stateType.identifier.name} has no unnamed constructor',
        target: clazz.asDiagnosticTarget,
      );
      return;
    }
    if (constructor.positionalParameters.isNotEmpty) {
      builder.error(
        'The state class ${stateType.identifier.name} has positional parameters',
        target: clazz.asDiagnosticTarget,
      );
      return;
    }

    final fields = await builder.fieldsOf(declaration);
    for (final field in fields) {
      builder.error(
        '${field.identifier.name}: ${field.metadata}',
        target: field.asDiagnosticTarget,
        enabled: false,
      );
    }

    for (final FieldDeclaration(identifier: Identifier(:name)) in fields) {
      if (constructor.namedParameters.none((p) => name == p.identifier.name)) {
        builder.error(
          "The state's constructor has no parameter for $name",
          target: clazz.asDiagnosticTarget,
        );
        return;
      }
    }

    await buildLensFields(
      builder,
      fields: fields.map(
        (f) => (
          name: f.identifier.name,
          type: f.type,
          metadata: f.metadata,
        ),
      ),
      stateTypeCode: stateType.code,
      stateTypeName: stateType.identifier.name,
    );
  }

  Future<void> buildLensesForRecord(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
    RecordTypeAnnotation stateType,
  ) async {
    if (stateType.positionalFields.isNotEmpty) {
      builder.error(
        'Record has positional fields',
        target: clazz.asDiagnosticTarget,
      );
      return;
    }

    await buildLensFields(
      builder,
      fields: stateType.namedFields.map(
        (f) => (
          name: f.name!,
          type: f.type,
          metadata: [],
        ),
      ),
      stateTypeCode: stateType.code,
    );
  }

  Future<void> buildLensFields(
    MemberDeclarationBuilder builder, {
    required Iterable<
            ({
              String name,
              TypeAnnotation type,
              Iterable<MetadataAnnotation> metadata,
            })>
        fields,
    required TypeAnnotationCode stateTypeCode,
    String stateTypeName = '',
  }) async {
    final lib = Uri.parse('package:bloc_lens/src/bloc_lens.dart');
    final blocLens = await builder.resolveIdentifier(lib, 'BlocLens');
    final blocEnumLens = await builder.resolveIdentifier(lib, 'BlocEnumLens');
    final blocBooleanLens =
        await builder.resolveIdentifier(lib, 'BlocBooleanLens');
    final blocNumberLens =
        await builder.resolveIdentifier(lib, 'BlocNumberLens');
    final blocListLens = await builder.resolveIdentifier(lib, 'BlocListLens');
    final blocMapLens = await builder.resolveIdentifier(lib, 'BlocMapLens');

    for (final field in fields) {
      final type = await field.type.dereferenceTypedef(builder);
      final isEnum = await type.isEnum(builder);
      final lensType = switch (type) {
        NamedTypeAnnotation(
          :final identifier,
          :final typeArguments,
          :final code,
        ) =>
          switch (identifier.name) {
            'bool' => blocBooleanLens.generic([
                stateTypeCode,
              ]),
            'int' || 'double' || 'num' => blocNumberLens.generic([
                stateTypeCode,
                code,
              ]),
            'List' => blocListLens.generic([
                stateTypeCode,
                typeArguments.first.code,
              ]),
            'Map' => blocMapLens.generic([
                stateTypeCode,
                typeArguments.first.code,
                typeArguments.last.code,
              ]),
            _ when isEnum => blocEnumLens.generic([
                stateTypeCode,
                code,
              ]),
            _ => blocLens.generic([
                stateTypeCode,
                code,
              ]),
          },
        _ => blocLens.generic([
            stateTypeCode,
            type.code,
          ]),
      };
      final additionalParameters = switch (type) {
        NamedTypeAnnotation(:final identifier) when isEnum => [
            '${identifier.name}.values,',
          ],
        NamedTypeAnnotation(
          identifier: Identifier(name: 'int' || 'double' || 'num'),
        ) =>
          switch (field.metadata
              .whereType<ConstructorMetadataAnnotation>()
              .firstWhereOrNull(
                (m) => m.constructor.name == 'NumberOptions',
              )) {
            ConstructorMetadataAnnotation(:final namedArguments) => [
                if (namedArguments['min'] case final min?) ...[
                  'min:',
                  ...min.parts,
                ],
                if (namedArguments['max'] case final max?) ...[
                  'max:',
                  ...max.parts,
                ],
                if (namedArguments['step'] case final step?) ...[
                  'step:',
                  ...step.parts,
                ],
              ],
            _ => null,
          },
        _ => null,
      };
      builder.declareInType(
        DeclarationCode.fromParts([
          'late final ${field.name} = ',
          ...lensType,
          '(this,',
          '(state) => state.${field.name},',
          '(state, value) => $stateTypeName(',
          for (final name in fields.map((f) => f.name))
            '$name: ${name == field.name ? 'value' : 'state.$name'}, ',
          '),',
          ...?additionalParameters,
          ');',
        ]),
      );
    }
  }
}

extension on DeclarationBuilder {
  void error(
    String message, {
    DiagnosticTarget? target,
    bool enabled = true,
  }) {
    if (enabled) {
      report(
        Diagnostic(
          DiagnosticMessage(message, target: target),
          Severity.error,
        ),
      );
    }
  }
}

extension on TypeAnnotation {
  Future<TypeAnnotation> dereferenceTypedef(DeclarationBuilder builder) async {
    if (this case NamedTypeAnnotation(:final identifier)) {
      final declaration = await builder.typeDeclarationOf(identifier);
      if (declaration case TypeAliasDeclaration(:final aliasedType)) {
        return aliasedType.dereferenceTypedef(builder);
      }
    }

    return this;
  }

  Future<bool> isEnum(DeclarationBuilder builder) async {
    final type = await dereferenceTypedef(builder);
    if (type case NamedTypeAnnotation(:final identifier)) {
      final declaration = await builder.typeDeclarationOf(identifier);
      // return declaration is EnumDeclaration;
      return declaration is ClassDeclaration &&
          declaration.superclass?.identifier.name == '_Enum';
    }

    return false;
  }
}

extension on Identifier {
  List<Object> generic(List<Code> typeParameters) {
    return [
      this,
      if (typeParameters.isNotEmpty) '<',
      ...typeParameters.expandIndexed((i, code) {
        return [if (i > 0) ',', ...code.parts];
      }),
      if (typeParameters.isNotEmpty) '>',
    ];
  }
}
