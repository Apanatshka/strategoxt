\literate
% GT -- Grammar Tools
% Copyright (C) 2000 Merijn de Jonge <mdejonge@cwi.nl>
%                    Eelco Visser <visser@acm.org>
%                    Joost Visser <jvisser@cwi.nl>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
% 02111-1307, USA.

% $Id: io-idwrap.r,v 1.1 2001/10/01 13:51:20 mdejonge Exp $

The strategy io-idwrap applies a strategy to the outermost function symbol
of an input term. The outermost function symbol then type-checking of input
terms. For AST's the symbol servers grammar identification to verify
that the input term is an AST generated from a partivular grammar.


If the strategy fails and the --strict option was not specified, a warning
is displayed. In case the --strict option was specified, the program
terminates with exit code 1.

examples:
 io-id-wrap( ?"sdf-2.2")

 Verify that the input term was produced from version 2.2 of the grammar SDF.


 op-id-wrap( ?sdf-2.1 + ?sdf-2.2 )
 
 Version 2.1 and 2.2 of SDF are accepted.


\begin{code}

module io-idwrap
imports options

signature
constructors
   Strict: Option

strategies
io-idwrap(id-check, strat) =
   io-idwrap(id-check, strat, fail, default-usage)

io-idwrap(id-check, strat, extra-options) =
   io-idwrap(id-check, strat, extra, default-usage)

io-idwrap(id-check, strat, extra-options, usage) =
   iowrap( 
      idwrap(id-check); strat, 
      extra-options + Option("--strict", !Strict()),
      usage
   )



idwrap(id-check) =
   ?(options, i#([trm]) );
   try(
      not(<id-check>i);
      (
        has-option(!Strict);
        <fatal-error>["fatal: input term has incorrect grammar identifier."]
      <+
        <error>["Warning: input term has incorrect grammar identifier." ]
      )
   );
   !(options, trm)
     
\end{code}
