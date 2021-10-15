# this does not appear to  work
my @a = ();
my $b = "(+ \n(* \n3) ; Help me! \ny)";
say $b;
say "-------------";

@a = split(/\n/, $b);
say @a;
say "-------------";
my @c = ();
for @a -> $elem {
  if $elem ~~ / \; / {
    say "hi";
    @c.append($/);
    @c.push: $/.postmatch;
  }
  else {
    @c.push: $elem;
  }
}
for @c -> $c {
  say $c;
}
