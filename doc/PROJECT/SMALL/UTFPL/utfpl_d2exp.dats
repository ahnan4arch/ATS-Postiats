(*
** Implementing Untyped Functional PL
*)

(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

staload "./utfpl.sats"

(* ****** ****** *)

implement
fprint_d2exp
  (out, d2e0) = let
in
//
case+ d2e0.d2exp_node of
//
| D2Ecst (d2c) =>
    fprint! (out, "D2Ecst(", d2c, ")")
| D2Evar (d2v) =>
    fprint! (out, "D2Evar(", d2v, ")")
| D2Esym (d2s) =>
    fprint! (out, "D2Esym(", d2s, ")")
//
| D2Ei0nt (rep) =>
    fprint! (out, "D2Ei0nt(", rep, ")")
| D2Ef0loat (rep) =>
    fprint! (out, "D2Ef0loat(", rep, ")")
| D2Es0tring (rep) =>
    fprint! (out, "D2Es0tring(", rep, ")")
//
| D2Eexp (d2e) =>
    fprint! (out, "D2Eexp(", d2e, ")")
//
| D2Eapplst (d2e, d2as) =>
    fprint! (out, "D2Eapplst(", d2e, "; ", d2as, ")")
//
| D2Eifopt
    (d2e1, d2e2, d2eopt3) =>
    fprint! (out, "D2Eifopt(", d2e1, "; ", d2e2, "; ", d2eopt3, ")")
//
| D2Elam (p2ts, d2e_body) =>
    fprint! (out, "D2Elam(", p2ts, "; ", d2e_body)
//
| D2Eerr ((*void*)) => fprint! (out, "D2Eerr(", ")")
//
| _ (*temporary*) => fprint! (out, "D2E...(", "...", ")")
//
end // end of [fprint_d2exp]

(* ****** ****** *)

implement
fprint_d2explst
  (out, d2es) = let
//
implement
fprint_val<d2exp> = fprint_d2exp
implement
fprint_list$sep<> (out) = fprint_string (out, ", ")
//
in
  fprint_list<d2exp> (out, d2es)
end // end of [fprint_d2explst]

(* ****** ****** *)

implement
fprint_d2expopt
  (out, d2es) = let
//
implement
fprint_val<d2exp> = fprint_d2exp
//
in
  fprint_option<d2exp> (out, d2es)
end // end of [fprint_d2expopt]

(* ****** ****** *)

implement
fprint_d2exparg
  (out, d2a) = let
in
//
case+ d2a of
| D2EXPARGsta () =>
    fprint! (out, "D2EXPARGsta(", ")")
| D2EXPARGdyn (npf, loc, d2es) =>
    fprint! (out, "D2EXPARGdyn(", npf, "; ", d2es, ")")
//
end // end of [fprint_d2exparg]

(* ****** ****** *)

implement
fprint_d2exparglst
  (out, d2as) = let
//
implement
fprint_val<d2exparg> = fprint_d2exparg
implement
fprint_list$sep<> (out) = fprint_string (out, ", ")
//
in
  fprint_list<d2exparg> (out, d2as)
end // end of [fprint_d2exparglst]

(* ****** ****** *)

implement
d2exp_make_node
  (loc, node) = '{
  d2exp_loc= loc, d2exp_node= node
} (* end of [d2exp_make_node] *)

(* ****** ****** *)
//
implement
d2exp_cst
  (loc, d2c) =
  d2exp_make_node (loc, D2Ecst (d2c))
//
implement
d2exp_var
  (loc, d2v) =
  d2exp_make_node (loc, D2Evar (d2v))
//
implement
d2exp_sym
  (loc, d2s) =
  d2exp_make_node (loc, D2Esym (d2s))
//
(* ****** ****** *)

implement
d2exp_i0nt
  (loc, rep) =
  d2exp_make_node (loc, D2Ei0nt (rep))
// end of [d2exp_i0nt]

implement
d2exp_f0loat
  (loc, rep) =
  d2exp_make_node (loc, D2Ef0loat (rep))
// end of [d2exp_f0loat]

implement
d2exp_s0tring
  (loc, rep) =
  d2exp_make_node (loc, D2Es0tring (rep))
// end of [d2exp_s0tring]

(* ****** ****** *)
//
implement
d2exp_exp
  (loc, d2e) =
  d2exp_make_node (loc, D2Eexp (d2e))
//
(* ****** ****** *)
//
implement
d2exp_applst
  (loc, d2e, d2as) =
  d2exp_make_node (loc, D2Eapplst (d2e, d2as))
//
(* ****** ****** *)
//
implement
d2exp_ifopt
  (loc, _test, _then, _else) =
  d2exp_make_node (loc, D2Eifopt (_test, _then, _else))
//
(* ****** ****** *)
//
implement
d2exp_lam
  (loc, p2ts_arg, d2e_body) =
  d2exp_make_node (loc, D2Elam (p2ts_arg, d2e_body))
//
implement
d2exp_fix
  (loc, d2v, p2ts_arg, d2e_body) =
  d2exp_make_node (loc, D2Efix (d2v, p2ts_arg, d2e_body))
//
(* ****** ****** *)

implement
d2exp_err (loc) = d2exp_make_node (loc, D2Eerr())

(* ****** ****** *)

(* end of [utfpl_d2exp.dats] *)
