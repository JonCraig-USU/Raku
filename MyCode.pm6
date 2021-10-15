use v6;
unit module MyCode;

# =======================================================================
# ***********************************************************************
# WHY IS ELSEIF NOT WORKING??
# REPL told me to change everything from ELSE IF to ELSEIF but won't compile
# Turning in what I have and checking if rakudo will download
# ***********************************************************************
# =======================================================================

sub getTokens ($program) is export {
    # split on new line and remove everything that is to the right of a ;
    my @splitNL = split(/\n/, $program);
    my $prepP = ();
    for @splitNL -> $elem {
        if $elem ~~ /\;/ {
            $prepP ~= $/.prematch;
        }
        else {
            $prepP ~= $elem;
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
        elseif $elem ~~ / \) / {
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
        elseif $elem ~~ / \) / {
            @final.append("RPAREN:" ~ $elem);
        }
        elseif $elem ~~ / \+ / {
            @final.append("ADDITION:" ~ $elem);
        }
        elseif $elem ~~ / \* / {
            @final.append("MULTIPLICATION:" ~ $elem);
        }
        elseif $elem ~~ /<alpha>/ {
            @final.append("IDENTIFIER:" ~ $elem);
        }
        # ** HOW DO YOU REGEX FOR \"\" ?? **
        # else if $elem ~~ / [] / {
        #     @final.append("IDENTIFIER:" ~ $elem);
        # }
        elseif $elem ~~ /^\d+$/ {
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
# Look through all the elements and count the number of left and right parenthesis then compare
sub balance (@tokens) is export {
    my $leftCount = 0;
    my $rightCount = 0;

    for @tokens -> $elem {
        if $elem ~~ / LPAREN / {
            $leftCount += 1;
        }
        elseif $elem ~~ / RPAREN / {
            $rightCount += 1; 
        }
    }
    return $leftCount = $rightCount;
}

# track the indentation of of the blocks with a counter and create a string with the 
# proper amount of indents to be grafted onto the final
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
        elseif $elem ~~ /RPAREN/ {
            $tabCount -= 1;
        }
    }
    return $final;
}

