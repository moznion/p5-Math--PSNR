package Math::PSNR;

use warnings;
use strict;
use Carp;
use Exporter;
use Mouse;

our $VERSION = '0.01';

has bpp => (
    is      => 'rw',
    isa     => 'Int',
    default => '8',
    trigger => sub {
        my ($self) = @_;
        $self->_set_max_power( $self->_calc_max_power );
    },
);

has x => (
    is       => 'rw',
    isa      => 'ArrayRef|HashRef',
    required => '1',
);

has y => (
    is       => 'rw',
    isa      => 'ArrayRef|HashRef',
    required => '1',
);

has max_power => (
    is       => 'ro',
    isa      => 'Int',
    writer   => '_set_max_power',
    init_arg => undef,
    lazy     => '1',
    default  => sub {
        my ($self) = @_;
        return $self->_calc_max_power;
    },
);

sub _sqr {
    my $var = shift;
    return $var * $var;
}

sub _log10 {
    my $var = shift;
    return log($var) / log(10);
}

sub _calc_max_power {
    my $self = shift;
    return 2**$self->bpp - 1;
}

sub _limit {
    my ($self, $var) = @_;

    if ($var < 0) {
        return 0;
    } elsif ($var > $self->max_power) {
        return $self->max_power;
    }
    return $var;
}

sub _square_remainder {
    my ( $self, $x, $y ) = @_;

    $x = $self->_limit($x);
    $y = $self->_limit($y);

    return _sqr( $x - $y );
}

sub _calc_psnr {
    my ( $self, $mse ) = @_;
    return 20 * _log10( $self->max_power / sqrt($mse) );
}

sub _check_exist_key {
    my ($self, $key) = @_;

    unless ( exists $self->x->{$key} && exists $self->y->{$key} ) {
        croak "Signal hash must have key of '$key'.";
    }

    unless ( ref $self->x->{$key} eq 'ARRAY'
        && ref $self->y->{$key} eq 'ARRAY' )
    {
        croak "Value of '$key' must be array reference. ";
    }
}

sub _check_exist_rgb_keys {
    my ($self) = @_;

    $self->_check_exist_key('r');
    $self->_check_exist_key('g');
    $self->_check_exist_key('b');
}

sub _check_signal_length_each {
    my ($self) = @_;

    my $signal_length_x = $#{ $self->x->{'r'} };
    unless ( $signal_length_x == $#{ $self->x->{'g'} } && $signal_length_x == $#{ $self->x->{'b'} } ) {
        croak "Each elements of signal must be the same length. Please check out the length of 'r', 'g', and 'b' of signal x.";
    }

    my $signal_length_y = $#{ $self->y->{'r'} };
    unless ( $signal_length_y == $#{ $self->y->{'g'} } && $signal_length_y == $#{ $self->y->{'b'} } ) {
        croak "Each elements of signal must be the same length. Please check out the length of 'r', 'g', and 'b' of signal y.";
    }

    unless ( $signal_length_x == $signal_length_y ) {
        croak "Signal length are different between 'Signal x' and 'Signal y'.";
    }
}

sub mse {
    my ($self) = @_;

    unless ( ref $self->x eq 'ARRAY' && ref $self->y eq 'ARRAY') {
        croak 'Signals must be array reference.';
    }

    my $signal_length = scalar @{ $self->x };
    unless ( $signal_length == scalar @{ $self->y } ) {
        croak 'Signals must be the same length.';
    }

    my ( $x, $y ) = ( $self->x, $self->y );
    my $sum = 0;
    for ( 0 .. $signal_length - 1 ) {
        $sum += $self->_square_remainder( $x->[$_], $y->[$_] );
    }

    return $sum / $signal_length;
}

sub psnr {
    my ($self) = @_;

    my $mse = $self->mse;
    if ( $mse == 0 ) {
        carp 'Given signals are the same.';
        return 'same';
    }

    return $self->_calc_psnr($mse);
}

sub mse_rgb {
    my ($self) = @_;

    unless ( ref $self->x eq 'HASH' && ref $self->y eq 'HASH' ) {
        croak 'Signals must be hash refference.';
    }

    $self->_check_exist_rgb_keys;
    $self->_check_signal_length_each;

    my $signal_length = scalar @{ $self->x->{'r'} };

    my ( $x, $y ) = ( $self->x, $self->y );
    my $sum = 0;
    for ( 0 .. $signal_length - 1 ) {
        $sum +=
          $self->_square_remainder( $x->{'r'}->[$_], $y->{'r'}->[$_] ) +
          $self->_square_remainder( $x->{'g'}->[$_], $y->{'g'}->[$_] ) +
          $self->_square_remainder( $x->{'b'}->[$_], $y->{'b'}->[$_] );
    }
    return $sum / (3 * $signal_length);
}

sub psnr_rgb {
    my ($self) = @_;

    my $mse = $self->mse_rgb;

    if ( $mse == 0 ) {
        carp 'Given signals are the same.';
        return 'same';
    }

    return $self->_calc_psnr($mse);
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
