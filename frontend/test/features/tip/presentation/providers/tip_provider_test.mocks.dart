// Mocks generated by Mockito 5.4.6 from annotations
// in neihborhoodwatch/test/features/tip/presentation/providers/tip_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:neihborhoodwatch/data/models/incident.dart' as _i5;
import 'package:neihborhoodwatch/features/tip/data/services/api_service.dart'
    as _i2;
import 'package:neihborhoodwatch/features/tip/domain/entities/tip.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiService extends _i1.Mock implements _i2.ApiService {
  MockApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Tip>> fetchTips() =>
      (super.noSuchMethod(
            Invocation.method(#fetchTips, []),
            returnValue: _i3.Future<List<_i4.Tip>>.value(<_i4.Tip>[]),
          )
          as _i3.Future<List<_i4.Tip>>);

  @override
  _i3.Future<void> addTip(_i4.Tip? tip) =>
      (super.noSuchMethod(
            Invocation.method(#addTip, [tip]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> updateTip(int? id, String? description) =>
      (super.noSuchMethod(
            Invocation.method(#updateTip, [id, description]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> deleteTip(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#deleteTip, [id]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<List<_i5.Incident>> fetchIncidents() =>
      (super.noSuchMethod(
            Invocation.method(#fetchIncidents, []),
            returnValue: _i3.Future<List<_i5.Incident>>.value(<_i5.Incident>[]),
          )
          as _i3.Future<List<_i5.Incident>>);
}
