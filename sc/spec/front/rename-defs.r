\begin{code}
module rename-defs
imports strategy stratlib lib dynamic-rules
strategies

  rename-defs =
    iowrap(Specification([id,Strategies(rename-sdefs)]))

  // Rename the names of all top-level strategy definitions; 
  // The Stratego syntax cannot be used for names of C functions.

  rename-sdefs =
    map(RenameSDef);
    map(topdown(try(RenameCall)))

rules

  RenameSDef : 
    SDef(x, args, s) -> SDef(y, args, s)
    where <length> args => n
        ; <concat-strings>[<try(NameMod); cify> x, "_", <int-to-string> n] => y
        ; rules(RenameVar : (x, n) -> y)
        ; (<HoArg> x; rules(HoArg : x -> Undefined)
                   <+ rules(HoArg : x -> y))

  RenameCall : 
    Call(SVar(x), ss) -> Call(SVar(y), ss)
    where <length> ss => n
        ; ( <RenameVar> (x,n) => y <+ <HoArg> x => y )

  NameMod :
    Mod(x, y) -> <concat-strings>[x,"-",y]
\end{code}
