module C-simplify-test
imports C-simplify sunit
strategies

  C-simplify-test = 
    test-suite(!"C-simplify-test",
	test1;
	test2
    )

  test1 = 
    apply-test(!"test1"
	, Csimplify
	, !
Compound([],[Compound([FunDef(TypeSpec([],TypeId("ATerm"),[]),IdDecl([],Id("c_0"),Some(ParamList([ParamDecl(TypeSpec([],TypeId("ATerm"),[]),IdDecl([],Id("t"),None))]))),Compound([],[IfElse(Equal(FunCall(Id("PushChoice"),[]),IntConst("0")),Compound([],[Stat(Assign(Id("t"),AssignEq,FunCall(Id("A_0"),[Id("t")]))),Stat(FunCall(Id("PopChoice"),[]))]),Stat(Assign(Id("t"),AssignEq,FunCall(Id("B_0"),[Id("t")])))),Return(Id("t"))]))],[Stat(Assign(Id("t"),AssignEq,FunCall(Id("innermost_1"),[Id("t"),Id("c_0")])))]),[Return(Id("t"))]])
	, !Compound([FunDef(TypeSpec([],TypeId("ATerm"),[]),IdDecl([],Id("c_0"),Some(ParamList([ParamDecl(TypeSpec([],TypeId("ATerm"),[]),IdDecl([],Id("t"),None))]))),Compound([],[IfElse(Equal(FunCall(Id("PushChoice"),[]),IntConst("0")),Compound([],[Stat(Assign(Id("t"),AssignEq,FunCall(Id("A_0"),[Id("t")]))),Stat(FunCall(Id("PopChoice"),[]))]),Stat(Assign(Id("t"),AssignEq,FunCall(Id("B_0"),[Id("t")])))),Return(Id("t"))]))],[Stat(Assign(Id("t"),AssignEq,FunCall(Id("innermost_1"),[Id("t"),Id("c_0")]))),[Return(Id("t"))]])    
	)

  test2 = 
    apply-test(!"test2"
	, Csimplify
	, !Compound([],[Compound([],[Stat(Assign(Id("t"),AssignEq,Id("t")))]),[Return(Id("t"))]])
	, !Compound([],[Stat(Assign(Id("t"),AssignEq,Id("t"))),[Return(Id("t"))]])
	)
