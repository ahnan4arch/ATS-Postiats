(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
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
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: April, 2011
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload "pats_symbol.sats"
staload "pats_lexing.sats"
staload "pats_tokbuf.sats"
staload "pats_syntax.sats"

(* ****** ****** *)

staload "pats_parsing.sats"

(* ****** ****** *)

#define l2l list_of_list_vt
#define t2t option_of_option_vt

(* ****** ****** *)

viewtypedef p0atlst12 = list12 (p0at)
viewtypedef labp0atlst12 = list12 (labp0at)

(* ****** ****** *)

fun p0at_list12 (
  t_beg: token
, ent2: p0atlst12
, t_end: token
) : p0at =
  case+ ent2 of
  | ~LIST12one (xs) =>
      p0at_list (t_beg, ~1, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      p0at_list (t_beg, npf, (l2l)xs12, t_end)
    end (* end of [LIST12two] *)
// end of [p0at_list12]

(* ****** ****** *)

fun p0at_tup12 (
  knd: int
, t_beg: token
, ent2: p0atlst12
, t_end: token
) : p0at =
  case+ ent2 of
  | ~LIST12one (xs) =>
      p0at_tup (knd, t_beg, ~1, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      p0at_tup (knd, t_beg, npf, (l2l)xs12, t_end)
    end (* end of [LIST12two] *)
// end of [p0at_tup12]

(* ****** ****** *)

fun p0at_rec12 (
  knd: int
, t_beg: token, ent2: labp0atlst12, t_end: token
) : p0at =
  case+ ent2 of
  | ~LIST12one (xs) =>
      p0at_rec (knd, t_beg, ~1, (l2l)xs, t_end)
  | ~LIST12two (xs1, xs2) => let
      val npf = list_vt_length (xs1)
      val xs12 = list_vt_append (xs1, xs2)
    in
      p0at_rec (knd, t_beg, npf, (l2l)xs12, t_end)
    end
// end of [p0at_rec12]

(* ****** ****** *)

fun
p_p0atseq_BAR_p0atseq (
  buf: &tokbuf
, bt: int
, err: &int
) : p0atlst12 =
  plist12_fun (buf, bt, p_p0at)
// end of [p_p0atseq_BAR_p0atseq]

fun
p_labp0atseq_BAR_labp0atseq (
  buf: &tokbuf, bt: int, err: &int
) : labp0atlst12 = let
  val _ = p_COMMA_test (buf) in
  plist12_fun (buf, bt, p_labp0at)
end // end of [p_labp0atseq_BAR_labp0atseq]

(* ****** ****** *)

implement
p_pi0de
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_IDENT_alp (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
| T_IDENT_sym (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_pi0de)
  in
    synent_null ()
  end // end of [_]
end // end of [p_pi0de]

(* ****** ****** *)

(*
labp0at ::= l0ab EQ p0at | DOTDOTDOT
*)
implement
p_labp0at (
  buf, bt, err
) = let
  val err0 = err
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_DOTDOTDOT () => let
    val () = incby1 () in labp0at_omit (tok)
  end
| _ => let
    val+ ~SYNENT3 (ent1, ent2, ent3) =
      pseq3_fun {l0ab,token,p0at} (buf, bt, err, p_l0ab, p_EQ, p_p0at)
    // end of [val]
  in
    if (err = err0) then
      labp0at_norm (ent1, ent3) else let
      val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_labp0at)
    in
      synent_null ()
    end (* end of [if] *)
  end // end of [_]
//
end // end of [p_labp0at]

(* ****** ****** *)

(*
atmp0at ::=
  | LITERAL_char
  | LITERAL_int
  | LITERAL_float
  | LITERAL_string
  | pi0de
  | BANG pi0de
  | OP pi0de
  | d0ynq pi0de
//
  | LPAREN p0atseq {BAR p0atseq} RPAREN
  | ATLPAREN p0atseq {BAR p0atseq} RPAREN
  | QUOTELPAREN p0atseq {BAR p0atseq} RPAREN
//
  | QUOTELBRACKET p0atseq RBRACKET // lists
//
  | ATLBRACE labp0atseq {BAR labp0atseq} RBRACE
  | QUOTELBRACE labp0atseq {BAR labp0atseq} RBRACE
//
  | LBRACKET s0argseq RBRACKET
*)
fun
p_atmp0at_tok (
  buf: &tokbuf, bt: int, err: &int, tok: token
) : p0at = let
  val err0 = err
  val loc = tok.token_loc
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
    buf, p_pi0de, ent
  ) => p0at_i0de (synent_decode (ent))
| T_BANG () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_pi0de (buf, bt, err)
  in
    if err = err0 then
      p0at_ref (tok, ent2) else synent_null ()
    // end of [if]
  end
| T_OP _ => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_pi0de (buf, bt, err)
  in
    if err = err0 then
      p0at_opid (tok, ent2) else synent_null ()
    // end of [if]
  end
| T_CHAR _ => let
    val () = incby1 () in p0at_c0har (tok)
  end
| T_INTEGER _ => let
    val () = incby1 () in p0at_i0nt (tok)
  end
| T_FLOAT _ => let
    val () = incby1 () in p0at_f0loat (tok)
  end
| T_STRING _ => let
    val () = incby1 () in p0at_s0tring (tok)
  end
| _ when
    ptest_fun (
    buf, p_d0ynq, ent
  ) => let
    val bt = 0
    val ent1 = synent_decode {d0ynq} (ent)
    val ent2 = p_pi0de (buf, bt, err) // err = err0
  in
    if err = err0 then
      p0at_dqid (ent1, ent2) else synent_null ()
    // end of [if]
  end
//
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_p0atseq_BAR_p0atseq (buf, bt, err)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0 then
      p0at_list12 (tok, ent2, ent3)
    else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
//
| tnd when
    is_LPAREN_deco (tnd) => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_p0atseq_BAR_p0atseq (buf, bt, err)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0 then let
      val knd = if is_ATLPAREN (tnd) then 0 else 1
    in
      p0at_tup12 (knd, tok, ent2, ent3)
    end else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
| tnd when
    is_LBRACE_deco (tnd) => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_labp0atseq_BAR_labp0atseq (buf, bt, err)
    val ent3 = p_RBRACE (buf, bt, err) // err = err0
  in
    if err = err0 then let
      val knd = if is_ATLBRACE (tnd) then 0 else 1
    in
      p0at_rec12 (knd, tok, ent2, ent3)
    end else let
      val () = list12_free (ent2) in synent_null ()
    end // end of [if]
  end
//
| T_LBRACKET () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {s0arg} (buf, bt, p_s0arg)
    val ent3 = p_RBRACKET (buf, bt, err) // err = err0
  in
    if err = err0 then
      p0at_exist (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in synent_null ()
    end (* end of [if] *)
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_atmp0at_tok]

fun
p_atmp0at (
  buf: &tokbuf, bt: int, err: &int
) : p0at =
  ptokwrap_fun (buf, bt, err, p_atmp0at_tok, PE_atmp0at)
// end of [p_atmp0at]

(* ****** ****** *)

(*
argp0at ::= atmp0at | LBRACE s0vararg RBRACE
*)
fun
p_argp0at (
  buf: &tokbuf, bt: int, err: &int
) : p0at = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
    buf, p_atmp0at, ent
  ) => synent_decode {p0at} (ent)
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0vararg (buf, bt, err)
    val ent3 = pif_fun (buf, bt, err, p_RBRACE, err0)
  in
    if err = err0 then
      p0at_svararg (tok, ent2, ent3) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_a0rgpat]

(* ****** ****** *)

fun
p_p0at0 (
  buf: &tokbuf, bt: int, err: &int
) : p0at = let
  val tok = tokbuf_get_token (buf)
  var ent: synent?
in
//
case+ 0 of
| _ when
    ptest_fun (
    buf, p_atmp0at, ent
  ) => let
    val bt = 0
    val x0 = synent_decode {p0at} (ent)
    val xs = pstar_fun (buf, bt, p_argp0at)
    fun loop (
      x0: p0at, xs: List_vt (p0at)
    ) : p0at =
      case+ xs of
      | ~list_vt_cons (x, xs) => let
          val x0 = p0at_app (x0, x) in loop (x0, xs)
        end
      | ~list_vt_nil () => x0
    // end of [loop]
  in
    loop (x0, xs)
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
end // end of [p_p0at0]

(* ****** ****** *)

(*
p0at
  | p0at0
  | p0at0 AS p0at
  | p0at0 COLON s0exp
  | TILDE p0at
*)
implement
p_p0at (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
    buf, p_p0at0, ent
  ) => let
    val bt = 0
    val p0t = synent_decode {p0at} (ent)
    val tok2 = tokbuf_get_token (buf)
  in
    case+ tok2.token_node of
    | T_AS () => let
        val () = incby1 ()
        val ent3 = p_p0at (buf, bt, err)
      in
        if err = err0 then
          p0at_as_refas (p0t, ent3) else tokbuf_set_ntok_null (buf, n0)
        // end of [if]        
      end
    | T_COLON () => let
        val () = incby1 ()
        val ent3 = p_s0exp (buf, bt, err)
      in
        if err = err0 then
          p0at_ann (p0t, ent3) else tokbuf_set_ntok_null (buf, n0)
        // end of [if]        
      end
    | _ => p0t
  end
| T_TILDE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_p0at (buf, bt, err)
  in
    if err = err0 then
      p0at_free (tok, ent2) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_p0at)
  in
    synent_null ()
  end
//
end // end of [p_p0at]

(* ****** ****** *)

(*
f0arg1 ::=
  | atmp0at | LBRACE s0quaseq RBRACE
  | DOTLT s0expseq GTDOT | DOTLTGTDOT
*)
implement
p_f0arg1
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
    buf, p_atmp0at, ent
  ) => f0arg_dyn (synent_decode {p0at} (ent))
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0quaseq (buf, bt, err)
    val ent3 = p_RBRACE (buf, bt, err) // err = 0
  in
    if err = 0 then
      f0arg_sta1 (tok, ent2, ent3) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| T_DOTLT () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {s0exp} (buf, bt, p_s0exp)
    val ent3 = p_GTDOT (buf, bt, err) // err = 0
  in
    if err = err0 then
      f0arg_met (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| T_DOTLTGTDOT () => f0arg_met_nil (tok)
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_f0arg1]

(*
f0arg2 ::= atmp0at | LBRACE s0argseq RBRACE
*)
implement
p_f0arg2
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
    buf, p_atmp0at, ent
  ) => f0arg_dyn (synent_decode {p0at} (ent))
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {s0arg} (buf, bt, p_s0arg)
    val ent3 = p_RBRACE (buf, bt, err) // err = 0
  in
    if err = 0 then
      f0arg_sta2 (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_f0arg2]

(* ****** ****** *)

(*
m0atch
  : d0exp  { $$ = m0atch_make_none ($1) ; }
  | d0exp AS p0at  { $$ = m0atch_make_some ($1, $3) ; }
; /* m0atch */
*)

fun p_m0atch (
  buf: &tokbuf, bt: int, err: &int
) : m0atch = let
  val err0 = err
  val ent1 = p_d0exp (buf, bt, err)
in
//
if err = err0 then let
  val ent2 = ptokentopt_fun {p0at} (buf, is_AS, p_p0at)
in
  m0atch_make (ent1, (t2t)ent2)
end else let
  val tok = tokbuf_get_token (buf)
  val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_m0atch)
in
  synent_null ((*okay*)) // HX: [err] is already set
end // end of [if]
end // end of [p_m0atch]

fun p_m0atchseq (
  buf: &tokbuf, bt: int, err: &int
) : m0atchlst =
  l2l (pstar_fun1_AND (buf, bt, err, p_m0atch))
// end of [p_m0atchseq]

fun p_guap0at (
  buf: &tokbuf, bt: int, err: &int
) : guap0at = let
  val err0 = err
  val ent1 = p_p0at (buf, bt, err)
in
//
if err = err0 then let
  val ent2 = ptokentopt_fun {m0atchlst} (buf, is_WHEN, p_m0atchseq)
in
  guap0at_make (ent1, (t2t)ent2)
end else let
  val tok = tokbuf_get_token (buf)
  val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_guap0at)
in
  synent_null ((*okay*)) // HX: [err] is already set
end // end of [if]
end // end of [p_guap0at]

(*
c0lau
  | guap0at EQGT d0exp
  | guap0at EQGTGT d0exp
  | guap0at EQSLASHEQGT d0exp
  | guap0at EQSLASHEQGTGT d0exp
*)
fun p_c0lau (
  buf: &tokbuf, bt: int, err: &int
) : c0lau = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = p_guap0at (buf, bt, err)
  val bt = 0
  var seq: int = 0 and neg: int = 0
  val () = if
    err = err0 then let
    val tok2 = tokbuf_get_token (buf)
    val () = (
      case+ tok2.token_node of
      | T_EQGT () => ()
      | T_EQGTGT () => seq := 1
      | T_EQSLASHEQGT () => neg := 1
      | T_EQSLASHEQGTGT () => (seq := 1; neg := 1)
      | _ => (err := err + 1)
    ) : void // end of [val]
  in
    if err = err0 then tokbuf_incby1 (buf)
  end // end of [val]
  val ent3 = pif_fun (buf, bt, err, p_d0exp, err0)
in
//
if err = err0 then
  c0lau_make (ent1, seq, neg, ent3)
else let
  val tok = tokbuf_get_token (buf)
  val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_c0lau)  
in
  tokbuf_set_ntok_null (buf, n0)
end // end of [if]
end // end of [p_c0lau]

(* ****** ****** *)

(*
sp0at ::= sqi0de LPAREN s0argseq RPAREN
*)

fun
p_sp0at (
  buf: &tokbuf, bt: int, err: &int
) : sp0at = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = p_sqi0de (buf, bt, err)
  val ent2 = pif_fun (buf, bt, err, p_LPAREN, err0)
  val ent3 = (
    if err = err0 then
      pstar_fun0_COMMA {s0arg} (buf, bt, p_s0arg)
    else list_vt_nil ()
  ) : List_vt (s0arg)
  val ent4 = pif_fun (buf, bt, err, p_RPAREN, err0)
in
  if err = err0 then
    sp0at_cstr (ent1, (l2l)ent3, ent4)
  else let
    val () = list_vt_free (ent3) in tokbuf_set_ntok_null (buf, n0)
  end (* end of [if] *)
end // end of [p_sp0at]

fun p_sc0lau (
  buf: &tokbuf, bt: int, err: &int
) : sc0lau = let
  val err0 = err
  val ~SYNENT3 (ent1, ent2, ent3) =
    pseq3_fun (buf, bt, err, p_sp0at, p_EQGT, p_d0exp)
  // end of [val]
in
  if err = err0 then
    sc0lau_make (ent1, ent3) else synent_null ((*okay*))
  // end of [if]
end // end of [p_sc0lau]

(* ****** ****** *)

implement
p_c0lauseq
  (buf, bt, err) = let
  val _ = p_BAR_test (buf) in l2l(pstar_fun0_BAR (buf, bt, p_c0lau))
end // end of [p_c0lauseq]

implement
p_sc0lauseq
  (buf, bt, err) = let
  val _ = p_BAR_test (buf) in l2l(pstar_fun0_BAR (buf, bt, p_sc0lau))
end // end of [p_sc0lauseq]

(* ****** ****** *)

(* end of [pats_parsing_p0at.dats] *)
