module build-match-laws-test
imports build-match-laws sunit
strategies

  build-match-laws-test =
    test-suite(!"build-match-laws-test",
	test1
    )

  test1 = 
    apply-test(!"test1"
	, BuildMatch
	, !Seq(Build(Op("TCons",[Var("b_0"),Op("TCons",[Var("c_0"),Op("TNil",[])])])),
           Seq(Match(Op("TCons",[Var("f_0"),Op("TCons",[Var("g_0"),Op("TNil",[])])])),
               Where(Prim("SSL_printnl",[Var("f_0"),Var("g_0")]))))
	, !Seq(Seq(Seqs([Seq(Build(Var("b_0")),Match(Var("f_0"))),
		         Seq(Build(Op("TCons",[Var("c_0"),Op("TNil",[])])),
                             Match(Op("TCons",[Var("g_0"),Op("TNil",[])])))]),
                   Build(Op("TCons",[Var("b_0"),Op("TCons",[Var("c_0"),Op("TNil",[])])]))),
               Where(Prim("SSL_printnl",[Var("f_0"),Var("g_0")]))) 
	)

