package Math::PSNR;

use warnings;
use strict;
use Carp;
use Exporter;
use Mouse;

our $VERSION = '0.01';

has bpp => (
    is       => 'rw',
    isa      => 'Int',
    default  => '8',
);

has x => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => '1',
);

has y => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => '1',
);

sub _sqr {
    my $var = shift;

    return $var * $var;
}

sub _common_log {
    my $var = shift;

    return log($var) / log(10);
}

sub _get_max_power {
    my $self = shift;

    return 2**$self->bpp - 1;
}

sub mse {
    my ($self) = @_;

    unless ( $#{ $self->x } == $#{ $self->y } ) {
        croak "$!";    # TODO fill an error message.
    }

    my $sum = 0;
    $sum += _sqr( $self->x->[$_] - $self->y->[$_] ) for ( 0 .. $#{ $self->x } );

    return $sum / scalar @{ $self->x } * scalar @{ $self->y };
}

sub psnr {
    my ( $self ) = @_;

    my $mse = $self->mse;
    if ($mse == 0) {
        carp 'Given signals are the same.';
        return 'same';
    }

    my $max_power = $self->_get_max_power;

    return 20 * _common_log( $max_power / sqrt($mse) );
}

1;
__END__

=encoding utf8

=head1 NAME

Math::PSNR - [One line description of module's purpose here]


=head1 VERSION

This document describes Math::PSNR version 0.0.1


=head1 SYNOPSIS

    use Math::PSNR;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.


=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 CONFIGURATION AND ENVIRONMENT

Math::PSNR requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-math-psnr@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

moznion  C<< <moznion@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, moznion C<< <moznion@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
