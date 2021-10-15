use v6;
unit module MyCode;

sub getTokens ($program) is export {
    # split on new line and remove everything that is to the right of a ;
    my @splitNL = split(/\n/, $program);
    my $prepS = ();
    for @splitNL -> $elem {
        if $elem ~~ /\;/ {
            $prepS ~= $/.prematch;
        }
        else {
            $prepS ~= $elem;
        }
    }
    # split on spaces
    # only need to seperate parenthesis from other pieces
    my @paren = split(/\s+/, $prepP);
    my @prepName = ();
    for @paren -> $elem {
        if $elem ~~ / \( / {
            @prepName.append($/);
            @prepName.append($/.postmatch);
        }
        else if $elem ~~ / \) / {
            @prepName.append($/.prematch);
            # check that there are no trailing right parenthesis
            # with the limited operators there should never be duplicate left parenthesis
            @prepName.append(stillRP($/));
        }
        else {
            @prepName.append($elem);
        }
    }
    # construct the final list to be returned
    my @final = ();
    for @prepName -> $elem {
        if $elem ~~ / \( / {
            @final.append("LPAREN:" ~ $elem);
        }
        else if $elem ~~ / \) / {
            @final.append("RPAREN:" ~ $elem);
        }
        else if $elem ~~ / \+ / {
            @final.append("ADDITION:" ~ $elem);
        }
        else if $elem ~~ / \* / {
            @final.append("MULTIPLICATION:" ~ $elem);
        }
        else if $elem ~~ /<alpha>/ {
            @final.append("IDENTIFIER:" ~ $elem);
        }
        # ** HOW DO YOU REGEX FOR \"\" ?? **
        # else if $elem ~~ / [] / {
        #     @final.append("IDENTIFIER:" ~ $elem);
        # }
        else if $elem ~~ /^\d+$/ {
            @final.append("INTEGER:" ~ $elem);
        }
        # catch for any unknown/illegal pieces
        else {
            @final.append("UNKNOWN-VIOLATOR:" ~ $elem);
        }
    }
    return @final;
}

# sub process for handling trailing parenthesis
# could be modified easily to handle left side problem children
sub stillRP ($rParens) {
    my @breakParen = split("", $rParens);
    my @temp = ();
    for @breakParen -> $elem {
        @temp.append($elem);
    }
    return @temp;
}

sub balance (@tokens) is export {
    my $leftCount = 0;
    my $rightCount = 0;

    for @tokens -> $elem {
        if $elem ~~ / LPAREN / {
            $leftCount += 1;
        }
        else if $elem ~~ / RPAREN / {
            $rightCount += 1; 
        }
    }
    return $leftCount = $rightCount;
}

sub format (@tokens) is export {
    my $tabCount = 0;
    my $final = "";
    for @tokens -> $elem {

        my $indent = "";
        for 0..$tabCount {
            $indent ~= "\t"
        }
        if $elem ~~ / \: / {
             $final ~= $indent;
             $final ~= $/.postmatch;
             $final ~= "\n";
        }
        if $elem ~~ /LPAREN/ {
            $tabCount += 1;
        }
        else if $elem ~~ /RPAREN/ {
            $tabCount -= 1;
        }
    }
    return $final;
}
