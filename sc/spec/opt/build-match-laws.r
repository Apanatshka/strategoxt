module build-match-laws
imports strategy sugar
strategies

  BMF = MisMatch + BuildMatchFusion + BuildBuild + BuildPrim

rules

  BuildMatch :
    Seq(s1, s2) -> s3
    where <BMF> (s1, s2) => s3

  BuildMatch :
    Seq(s1, Seq(s2, s3)) -> Seq(s4,s3)
    where <BMF> (s1, s2) => s4

  MisMatch :
    (Build(Op(f, ts1)), Match(Op(g, ts2))) -> Fail
    where <not(eq)> (f, g)

  BuildMatchFusion :
    (Build(Op(f, ts1)), Match(Op(f, ts2))) ->
    Seq(Seqs(<zip(\ (t1,t2) -> Seq(Build(t1),Match(t2)) \ )> (ts1, ts2)), 
        Build(Op(f, ts1)))

  NoEffect :
    Seq(Build(t1), Seq(Build(t2), s)) -> 
    Seq(Build(t2), s)

  BuildBuild :
    (Build(t1), Build(t2)) -> Build(t2)

  BuildBuild :
    (Build(t1), Where(Build(t2))) -> Build(t2)

  BuildPrim :
    (Build(t1), Prim(p,ts)) -> Prim(p,ts)

  BuildPrim :
    (Build(t1), Where(Prim(p,ts))) -> Prim(p,ts)

  // where(s; !t) == where(s)
