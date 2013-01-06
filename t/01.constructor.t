#!perl

use strict;
use warnings;
use utf8;
use Math::PSNR;

BEGIN {
    use Test::Exception;
    use Test::More tests => 5;
}

my $psnr;

subtest 'Set bpp by constructor' => sub {
    $psnr = Math::PSNR->new(
        {
            bpp => 2,
            x   => [ 1, 2, 3, 4, 5 ],
            y   => [ 1, 2, 3, 4, 5 ],
        }
    );
    is( $psnr->bpp,       2, 'Is bpp set value' );
    is( $psnr->max_power, 3, 'Is max power right' );
};

subtest 'Set default bpp value' => sub {
    $psnr = Math::PSNR->new(
        {
            x => [ 1, 2, 3, 4, 5 ],
            y => [ 1, 2, 3, 4, 5 ],
        }
    );
    is( $psnr->bpp,       8, 'Is bpp default value' );
    is( $psnr->max_power, 255, 'Is max power default value' );
};

subtest 'Set bpp manually' => sub {
    $psnr->bpp(4);
    is( $psnr->max_power, 15, 'Is max power changed and right' );
};

subtest 'Not set x' => sub {
    dies_ok {
        Math::PSNR->new( { y => [ 1, 2, 3, 4, 5 ], } );
    } 'Die cause of x was not set.'
};

subtest 'Not set y' => sub {
    dies_ok {
        Math::PSNR->new( { x => [ 1, 2, 3, 4, 5 ], } );
    } 'Die cause of y was not set'
};

done_testing;
