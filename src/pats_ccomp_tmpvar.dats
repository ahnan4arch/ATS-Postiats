(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (gmhwxi AT gmail DOT com)
// Start Time: October, 2012
//
(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload
STMP = "pats_stamp.sats"
typedef stamp = $STMP.stamp

staload
LOC = "pats_location.sats"
typedef location = $LOC.location

(* ****** ****** *)

staload "pats_histaexp.sats"

(* ****** ****** *)

staload "pats_ccomp.sats"

(* ****** ****** *)

local

typedef tmpvar = '{
  tmpvar_loc= location
, tmpvar_type= hisexp
, tmpvar_ret= int (* return status *)
, tmpvar_top= int (* 0/1 : local/top(static) *)
(*
, tmpvar_root= tmpvaropt
*)
, tmpvar_stamp= stamp (* unicity *)
} // end of [tmpvar]

assume tmpvar_type = tmpvar

in // in of [local]

implement
tmpvar_make
  (loc, hse) = let
  val stamp = $STMP.tmpvar_stamp_make () in '{
  tmpvar_loc= loc
, tmpvar_type= hse
, tmpvar_ret= 0
, tmpvar_top= 0 (*local*)
(*
, tmpvar_root= None () // HX: tmpvar is not an alias
*)
, tmpvar_stamp= stamp
} end // end of [tmpvar_make]

(* ****** ****** *)

implement
fprint_tmpvar
  (out, tmp) = () where {
  val () = fprint_string (out, "tmp(")
  val () = $STMP.fprint_stamp (out, tmp.tmpvar_stamp)
  val () = fprint_string (out, ")")
} // end of [fprint_tmpvar]

(* ****** ****** *)

implement
eq_tmpvar_tmpvar (tmp1, tmp2) =
  $STMP.eq_stamp_stamp (tmp1.tmpvar_stamp, tmp2.tmpvar_stamp)
// end of [eq_tmpvar_tmpvar]

implement
compare_tmpvar_tmpvar (tmp1, tmp2) =
  $STMP.compare_stamp_stamp (tmp1.tmpvar_stamp, tmp2.tmpvar_stamp)
// end of [compare_tmpvar_tmpvar]

(* ****** ****** *)

end // end of [local]

(* ****** ****** *)

(* end of [pats_ccomp_tmpvar.dats] *)
