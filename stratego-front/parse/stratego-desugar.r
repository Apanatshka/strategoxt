module stratego-desugar
imports lib Stratego
strategies
 
  stratego-desugar = 
    iowrap(try(\ _#([x]) -> x \ ) ; topdown(repeat(Desugar); try(DesugarOnce)))

rules

  Desugar :
    Module(x, decls) -> Specification(decls)

  Desugar :
    RDefNoArgs(f, r) -> RDef(f, [], r)

  Desugar :
    SRDefNoArgs(f, r) -> RDef(f, [], r)

  Desugar :
    SRDef(f, xs, r) -> RDef(f, xs, r)
 
  Desugar :
    SDefNoArgs(f, s) -> SDef(f, [], s)

  Desugar :
    CallNoArgs(f) -> Call(f, [])

  Desugar :
    PrimNoArgs(f) -> Prim(<un-double-quote>f, [])

  Desugar :
    Prim(f,xs) -> Prim(<un-double-quote>f, xs)

  Desugar :
    OverlayNoArgs(f, t) -> Overlay(f, [], t)

  Desugar :
    RuleNoCond(l, r) -> Rule(l, r, Id)

  Desugar :
    StratRuleNoCond(l, r) -> StratRule(l, r, Id)

//  Desugar :
//    StratRule(l, r, s) -> Rule(l, r, s)

//  Desugar :
//    Inj(x) -> x

  //Desugar :
  //  InjStrat(x) -> x
 
  Desugar :
    ParenStrat(x) -> x

//  Desugar :
//    AngleStrat(x) -> x

  // Congruences

//  Desugar :
//    TupleCong([x]) -> x

//  Desugar :
//    TupleCong(ts) -> Call(SVar(""), ts)
//    where <not([id])> ts

  Desugar :
    ListCongNoTail(ts) -> <foldr(!Call(SVar("Nil"),[]),\ (t1, t2) -> Call(SVar("Cons"),[t1,t2]) \ )> ts

  Desugar :
    ListCong(ts,t) -> <foldr(!t,\ (t1, t2) -> Call(SVar("Cons"),[t1,t2]) \ )> ts

  Desugar :
    ModCong(m, xs) -> Call(SVar(m), xs)

  Desugar :
    ModCongNoArgs(m) -> Call(SVar(m), [])

  Desugar :
    StrCong(x) -> Match(Str(x))

  Desugar :
    IntCong(x) -> Match(Int(x))

  Desugar :
    RealCong(x) -> Match(Real(x))

  // Term sugar

  Desugar :
    Tuple([t]) -> t

  Desugar :
    Tuple(ts) -> Op("", ts)
    where <not([id])> ts

  Desugar :
    List(ts) -> <foldr(!Op("Nil",[]),\ (t1, t2) -> Op("Cons",[t1,t2]) \ )> ts

  Desugar :
    ListTail(ts,t) -> <foldr(!t,\ (t1, t2) -> Op("Cons",[t1,t2]) \ )> ts

//  Desugar :
//    Con(t1, Con1(t2)) -> Con(t1, t2, Call(SVar("oncetd"),[]))

//  Desugar :
//    Con(t1, Con2(t2, f)) -> Con(t1, t2, Call(SVar(f),[]))

  // Signatures

  Desugar : 
    SortNoArgs(x) -> Sort(x, [])

  // Constants

  DesugarOnce : 
    Int(x) -> Int(y)
    where <string-to-int> x => y

  DesugarOnce : 
    Real(x) -> Real(y)
    where <string-to-real> x => y

  DesugarOnce : 
    Str(x) -> Str(y)
    where <un-double-quote; unescape> x => y

  Desugar : 
    SortNoArgs(x) -> Sort(x, [])

strategies

  DesugarOnce =
    DefaultVarDec(RemoveLeadingPrime)
    + RDef(RemoveLeadingPrime,id,id)
    + SDef(RemoveLeadingPrime,id,id)
    + VarDec(RemoveLeadingPrime,id)
    + Var(RemoveLeadingPrime)
    + SVar(RemoveLeadingPrime)
    + OpDecl(RemoveLeadingPrime,id)
    + Op(RemoveLeadingPrime,id)

  RemoveLeadingPrime :
    x -> x'
    where <explode-string> x => [39 | cs]
        ; <implode-string> cs => x'
