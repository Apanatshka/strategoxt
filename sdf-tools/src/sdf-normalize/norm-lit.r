// SDF Tools
// Copyright (C) 2001 Merijn de Jonge <mdejonge@cwi.nl>
//                    Eelco Visser <visser@acm.org>
//                    Joost Visser <jvisser@cwi.nl>
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
// 02111-1307, USA.           


module norm-lit
(*
	Author: Joost Visser (Joost.Visser@cwi.nl)

	Usage:
	  normlit -i <Imploded-AsFix> -o <Imploded-AsFix>

	  Replaces all occurences of "uqlit" and "qlit" nodes
	  in an Imploded-AsFix tree by "lit" nodes. Enclosing
	  double quotes of quoted literals ("qlit") are stripped
	  away.

	  Input trees can be parsed and imploded Sdf2 grammars, or
          AsFix trees (which contain parsed and imploded Sdf2
	  productions).

	  See also: de-norm-lit.
*)

imports
  Literal-lib Literals-Sdf-Syntax asfix

strategies

  norm-lit
    = iowrap(alltd(Normalize))

rules

  Normalize:
    uqlit(str)	-> lit(str)
  Normalize:
    qlit(str)	-> lit(<de-quote>str)

