// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_reader_helper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FileReader {
  String get name => throw _privateConstructorUsedError;
  int get length => throw _privateConstructorUsedError;
  List<int> get bytes => throw _privateConstructorUsedError;
  String get hash => throw _privateConstructorUsedError;

  /// Create a copy of FileReader
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileReaderCopyWith<FileReader> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileReaderCopyWith<$Res> {
  factory $FileReaderCopyWith(
          FileReader value, $Res Function(FileReader) then) =
      _$FileReaderCopyWithImpl<$Res, FileReader>;
  @useResult
  $Res call({String name, int length, List<int> bytes, String hash});
}

/// @nodoc
class _$FileReaderCopyWithImpl<$Res, $Val extends FileReader>
    implements $FileReaderCopyWith<$Res> {
  _$FileReaderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileReader
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? length = null,
    Object? bytes = null,
    Object? hash = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      length: null == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as List<int>,
      hash: null == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileReaderImplCopyWith<$Res>
    implements $FileReaderCopyWith<$Res> {
  factory _$$FileReaderImplCopyWith(
          _$FileReaderImpl value, $Res Function(_$FileReaderImpl) then) =
      __$$FileReaderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int length, List<int> bytes, String hash});
}

/// @nodoc
class __$$FileReaderImplCopyWithImpl<$Res>
    extends _$FileReaderCopyWithImpl<$Res, _$FileReaderImpl>
    implements _$$FileReaderImplCopyWith<$Res> {
  __$$FileReaderImplCopyWithImpl(
      _$FileReaderImpl _value, $Res Function(_$FileReaderImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileReader
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? length = null,
    Object? bytes = null,
    Object? hash = null,
  }) {
    return _then(_$FileReaderImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      length: null == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      bytes: null == bytes
          ? _value._bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as List<int>,
      hash: null == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FileReaderImpl implements _FileReader {
  const _$FileReaderImpl(
      {required this.name,
      required this.length,
      required final List<int> bytes,
      required this.hash})
      : _bytes = bytes;

  @override
  final String name;
  @override
  final int length;
  final List<int> _bytes;
  @override
  List<int> get bytes {
    if (_bytes is EqualUnmodifiableListView) return _bytes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bytes);
  }

  @override
  final String hash;

  @override
  String toString() {
    return 'FileReader(name: $name, length: $length, bytes: $bytes, hash: $hash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileReaderImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.length, length) || other.length == length) &&
            const DeepCollectionEquality().equals(other._bytes, _bytes) &&
            (identical(other.hash, hash) || other.hash == hash));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, length,
      const DeepCollectionEquality().hash(_bytes), hash);

  /// Create a copy of FileReader
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileReaderImplCopyWith<_$FileReaderImpl> get copyWith =>
      __$$FileReaderImplCopyWithImpl<_$FileReaderImpl>(this, _$identity);
}

abstract class _FileReader implements FileReader {
  const factory _FileReader(
      {required final String name,
      required final int length,
      required final List<int> bytes,
      required final String hash}) = _$FileReaderImpl;

  @override
  String get name;
  @override
  int get length;
  @override
  List<int> get bytes;
  @override
  String get hash;

  /// Create a copy of FileReader
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileReaderImplCopyWith<_$FileReaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
