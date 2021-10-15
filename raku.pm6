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

my @a = ('a', 'ab+834gt', 1, 'b', 2, 'c', '_', 'd', 'e', 'f', 'g');
my $b = "(+ \n(* \n3) :; Help me! \ny)";
my @c = ();
for @a -> $elem {
  if $elem ~~ / gt / {
    say "SUCCESS"
  }
  @c.append("Success:" ~ $elem);
}

say ("\t" ~ @c);

my $tab = "";
$tab ~= "\t";
say ($tab ~ 'a');
my $counter = 3;
for 1..$counter {
  $tab ~= "\t";
}
if $b ~~ / \: / {
  say ($tab ~ $/.prematch)
}
say ($tab ~ 'b');

