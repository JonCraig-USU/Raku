use v6;
unit module PrettyPrint;

# Function:     prettyPrint
# Description:  Given a list of Raku tokens, pretty print that code.
# Input:        A @data list containing strings (representing tokens)
# Output:       A $returnValue string containing the pretty-printed program
sub prettyPrint (@data) is export {
    # tokens to look out for
    # # -> comment (ends in a \n)
    # " -> start / end a string
    # $ -> Scalar variable (any alphanum chars following make up var name)
    # + -> Addition
    # - -> Subtraction
    # if, else, elsif -> self explanatory
    # = -> assignment
    # := -> binding
    # < -> less than
    # <= -> less than / equal to
    # my -> the keyword my
    # ( -> open parenthesis
    # ) -> close parenthesis
    # { -> open brace
    # } -> close brace
    # ; -> semicolon
    # any other integer / string constants

    # stores indent level (i.e., how many spaces at beginning of indent level)
    my $indentLevel = 0;

    # stores whether this is first token on line
    my $firstTokenOnLine = True;
    
    # stores whether last character was open parentheses 
    # (whether to add a space at beginning of this char or not)
    my $wasLastOpenParen = False;

    # return value at end of pretty print
    my $returnValue = "";

    # loop through every element in data and pretty-print
    for @data -> $element {
        # get just the token of the data
        my $elementToken = getTokenCharacter($element);
        my $firstChar = substr($elementToken, 0, 1);
        
        # variables that we'll flag in order to control indent levels and
        # new lines
        my $decrementThisLine = False;
        my $indentNextLine = False;
        my $addNewLine = False;

        # this will hold what text needs to be added
        my $whatToAdd = "";
        
        # switch-case based on first character of token
        given $firstChar {
            # most cases will be the same: add a space
            # before the token and just print the token
            # special cases:
            # ) -> don't add space before
            # # -> start on new line, end line after comment
            # { -> new line after, increase indent by 4
            # ; -> don't add space before, new line after
            # } -> decrease indent by 4 (before the character), new line after
            when ")" {
                $whatToAdd = ")";
            }
            when "#" {
                # strip the "\n" chars from the token (we need to print
                # an actual new line, not the \n escape sequence)
                $whatToAdd = substr($elementToken, 0, *-2);
                $addNewLine = True;
            }
            when "\{" {
                $whatToAdd = " \{";
                $indentNextLine = True;
                $addNewLine = True;
            }
            when ";" {
                $whatToAdd = ";";
                $addNewLine = True;
            }
            when "\}" {
                $decrementThisLine = True;
                $whatToAdd = "\}";
                $addNewLine = True;
            }
            # default is just add a space and the element token
            default {
                if !$firstTokenOnLine and !$wasLastOpenParen {
                    $whatToAdd = " ";
                }
                $whatToAdd = $whatToAdd ~ $elementToken;
            }
        }
        
        # if removing indent, then decrease indent level
        if $decrementThisLine {
            $indentLevel = $indentLevel - 4;
            if $indentLevel < 0 {
                $indentLevel = 0;
            }
        }

        # indent if this is first token on line
        if $firstTokenOnLine {
            # create the indent
            my $indent = "";
            for 1..$indentLevel {
                $indent = $indent ~ " ";
            }
            $returnValue = $returnValue ~ $indent;
        }
        
        # if we are addding a new line, next thing has to be first token
        # otherwise, it will NOT be first token
        $firstTokenOnLine = $addNewLine;

        # if adding a new line
        if $addNewLine {
            $whatToAdd = $whatToAdd ~ "\n";
        }

        # if increasing indent, then increase indent level
        if $indentNextLine {
            $indentLevel = $indentLevel + 4;
        }

        # check whether this character is an open parentheses
        # this is for next time, whether to add a space or not
        $wasLastOpenParen = $firstChar eq "(";

        # add our construction to return value
        $returnValue = $returnValue ~ $whatToAdd;
    }

    # return the big concatenated string
    return $returnValue;
}

# Function:     getTokenCharacter
# Description:  Given a token description, return the actual token.
# Input:        A $data string containing the token description
# Output:       A $returnValue string containing the token itself
sub getTokenCharacter($data) is export {
    # split the data based on colon
    # colon is used in the Tokenize output
    my @dataSplit = split(/\:/, $data, :skip-empty, :v);

    my $returnValue = "";

    # use this to track once we've found the colon
    my $foundColon = False;

    for @dataSplit -> $element {
        if $foundColon == True {
            # after finding first colon, append all data to return value
            $returnValue = $returnValue ~ $element;
        }
        elsif $element eq ":" {
            # once we find first colon, mark everything after that as relevant
            $foundColon = True;
        }
        else {
            # do nothing before finding first colon
        }
    }
    return $returnValue;
}
