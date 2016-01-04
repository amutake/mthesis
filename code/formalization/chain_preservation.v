Lemma new_trans_chain :
  forall msgs msgs' actors actors' child,
    chain actors ->
    (msgs >< actors) ~(New child)~> (msgs' >< actors') ->
    chain actors'.
Proof.
  move=> msgs msgs' actors actors' child ch tr.
  inversion tr; subst.
  move/new_trans_parent_exists': tr.
  rewrite/chain/=.
  have ggpeq : generated gen parent = generated gen parent by reflexivity.
  move/(_ ggpeq)=> pin_p.
  apply/andP; split; first done.
  move: ch.
  rewrite/chain/=; repeat (rewrite map_cat /=).
  rewrite 2!all_cat /=.
  move/and3P.
  case=> ch_l ch_p ch_r.
  apply/and3P.
  split.
  - apply/allP=> x xin.
    move/allP/(_ x xin): ch_l.
    move: xin; case: x; first done.
    move=> g n xin H.
    by rewrite in_cons; apply/orP; right.
  - destruct parent; first done.
    by rewrite in_cons; apply/orP; right.
  - apply/allP=> x xin.
    move/allP/(_ x xin): ch_r.
    move: xin; case: x; first done.
    move=> g n xin H.
    by rewrite in_cons; apply/orP; right.
Qed.
