=begin

IO Methods and Functions

=end

=begin item open
Open file.
=end item

sub open($filename, :$r, :$w, :$a, :$bin) {
    my $mode := $w ?? 'w' !! ($a ?? 'wa' !! 'r');
    my $handle := nqp::open($filename, $mode);
    nqp::setencoding($handle, $bin ?? 'binary' !! 'utf8');
    $handle;
}

=begin item close
Close handle
=end item

sub close($handle) {
    nqp::closefh($handle);
}

=begin item slurp
Returns the contents of C<$filename> as a single string.
=end item

sub slurp ($filename) {
    my $handle := open($filename, :r);
    my $contents := nqp::readallfh($handle);
    nqp::closefh($handle);
    $contents;
}


=begin item spew
Write the string value of C<$contents> to C<$filename>.
=end item

sub spew($filename, $contents) {
    my $handle := open($filename, :w);
    nqp::printfh($handle, $contents);
    nqp::closefh($handle);
}

sub print(*@args) {
    for @args {
        nqp::print($_);
    }
    1;
}

sub say(*@args) {
    print(|@args, "\n");
}

sub join($delim, @things) {
    my @strs;
    for @things { nqp::push(@strs, ~$_) }
    nqp::join($delim, @strs)
}

# vim: ft=perl6
