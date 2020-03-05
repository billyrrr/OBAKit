// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/protobuf/unittest_preserve_unknown_enum2.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.  All rights reserved.
// https://developers.google.com/protocol-buffers/
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

enum Proto2PreserveUnknownEnumUnittest_MyEnum: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case foo // = 0
  case bar // = 1
  case baz // = 2

  init() {
    self = .foo
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .foo
    case 1: self = .bar
    case 2: self = .baz
    default: return nil
    }
  }

  var rawValue: Int {
    switch self {
    case .foo: return 0
    case .bar: return 1
    case .baz: return 2
    }
  }

}

#if swift(>=4.2)

extension Proto2PreserveUnknownEnumUnittest_MyEnum: CaseIterable {
  // Support synthesized by the compiler.
}

#endif  // swift(>=4.2)

struct Proto2PreserveUnknownEnumUnittest_MyMessage {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var e: Proto2PreserveUnknownEnumUnittest_MyEnum {
    get {return _e ?? .foo}
    set {_e = newValue}
  }
  /// Returns true if `e` has been explicitly set.
  var hasE: Bool {return self._e != nil}
  /// Clears the value of `e`. Subsequent reads from it will return its default value.
  mutating func clearE() {self._e = nil}

  var repeatedE: [Proto2PreserveUnknownEnumUnittest_MyEnum] = []

  var repeatedPackedE: [Proto2PreserveUnknownEnumUnittest_MyEnum] = []

  /// not packed
  var repeatedPackedUnexpectedE: [Proto2PreserveUnknownEnumUnittest_MyEnum] = []

  var o: Proto2PreserveUnknownEnumUnittest_MyMessage.OneOf_O? = nil

  var oneofE1: Proto2PreserveUnknownEnumUnittest_MyEnum {
    get {
      if case .oneofE1(let v)? = o {return v}
      return .foo
    }
    set {o = .oneofE1(newValue)}
  }

  var oneofE2: Proto2PreserveUnknownEnumUnittest_MyEnum {
    get {
      if case .oneofE2(let v)? = o {return v}
      return .foo
    }
    set {o = .oneofE2(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_O: Equatable {
    case oneofE1(Proto2PreserveUnknownEnumUnittest_MyEnum)
    case oneofE2(Proto2PreserveUnknownEnumUnittest_MyEnum)

  #if !swift(>=4.1)
    static func ==(lhs: Proto2PreserveUnknownEnumUnittest_MyMessage.OneOf_O, rhs: Proto2PreserveUnknownEnumUnittest_MyMessage.OneOf_O) -> Bool {
      switch (lhs, rhs) {
      case (.oneofE1(let l), .oneofE1(let r)): return l == r
      case (.oneofE2(let l), .oneofE2(let r)): return l == r
      default: return false
      }
    }
  #endif
  }

  init() {}

  fileprivate var _e: Proto2PreserveUnknownEnumUnittest_MyEnum? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "proto2_preserve_unknown_enum_unittest"

extension Proto2PreserveUnknownEnumUnittest_MyEnum: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "FOO"),
    1: .same(proto: "BAR"),
    2: .same(proto: "BAZ"),
  ]
}

extension Proto2PreserveUnknownEnumUnittest_MyMessage: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MyMessage"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "e"),
    2: .standard(proto: "repeated_e"),
    3: .standard(proto: "repeated_packed_e"),
    4: .standard(proto: "repeated_packed_unexpected_e"),
    5: .standard(proto: "oneof_e_1"),
    6: .standard(proto: "oneof_e_2"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularEnumField(value: &self._e)
      case 2: try decoder.decodeRepeatedEnumField(value: &self.repeatedE)
      case 3: try decoder.decodeRepeatedEnumField(value: &self.repeatedPackedE)
      case 4: try decoder.decodeRepeatedEnumField(value: &self.repeatedPackedUnexpectedE)
      case 5:
        if self.o != nil {try decoder.handleConflictingOneOf()}
        var v: Proto2PreserveUnknownEnumUnittest_MyEnum?
        try decoder.decodeSingularEnumField(value: &v)
        if let v = v {self.o = .oneofE1(v)}
      case 6:
        if self.o != nil {try decoder.handleConflictingOneOf()}
        var v: Proto2PreserveUnknownEnumUnittest_MyEnum?
        try decoder.decodeSingularEnumField(value: &v)
        if let v = v {self.o = .oneofE2(v)}
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._e {
      try visitor.visitSingularEnumField(value: v, fieldNumber: 1)
    }
    if !self.repeatedE.isEmpty {
      try visitor.visitRepeatedEnumField(value: self.repeatedE, fieldNumber: 2)
    }
    if !self.repeatedPackedE.isEmpty {
      try visitor.visitPackedEnumField(value: self.repeatedPackedE, fieldNumber: 3)
    }
    if !self.repeatedPackedUnexpectedE.isEmpty {
      try visitor.visitRepeatedEnumField(value: self.repeatedPackedUnexpectedE, fieldNumber: 4)
    }
    switch self.o {
    case .oneofE1(let v)?:
      try visitor.visitSingularEnumField(value: v, fieldNumber: 5)
    case .oneofE2(let v)?:
      try visitor.visitSingularEnumField(value: v, fieldNumber: 6)
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Proto2PreserveUnknownEnumUnittest_MyMessage, rhs: Proto2PreserveUnknownEnumUnittest_MyMessage) -> Bool {
    if lhs._e != rhs._e {return false}
    if lhs.repeatedE != rhs.repeatedE {return false}
    if lhs.repeatedPackedE != rhs.repeatedPackedE {return false}
    if lhs.repeatedPackedUnexpectedE != rhs.repeatedPackedUnexpectedE {return false}
    if lhs.o != rhs.o {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
