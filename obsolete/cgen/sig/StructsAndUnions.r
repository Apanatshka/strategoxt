module StructsAndUnions
signature
signature
  constructors
    Struct : Option(IdentifierOrTypedefName) * List(MemberDeclaration) -> StructSpecifier
    StructId : IdentifierOrTypedefName -> StructSpecifier
signature
  constructors
    Union : Option(IdentifierOrTypedefName) * List(MemberDeclaration) -> UnionSpecifier
    UnionId : IdentifierOrTypedefName -> UnionSpecifier
signature
  constructors
    MemDecl : TypeSpecifier * List(MemberDeclarator) -> MemberDeclaration
    MemDecl1 : List(TypeQualifier) * List(MemberIdentifierDeclarator) -> MemberDeclaration
signature
  constructors
    BitFieldSize : Option(Declarator) * ConstantExpression -> MemberDeclarator
