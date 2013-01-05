#!perl

use strict;
use warnings;
use utf8;
use Math::PSNR;

BEGIN {
    use Test::Exception;
    use Test::More tests => 4;
}

my $psnr;

subtest 'Set bpp by constructor' => sub {
    $psnr = new Math::PSNR(
        {
            bpp => 2,
            x   => [ 1, 2, 3, 4, 5 ],
            y   => [ 1, 2, 3, 4, 5 ],
        }
    );
    is( $psnr->bpp, 2 );
};

subtest 'Set default bpp value' => sub {
    $psnr = new Math::PSNR(
        {
            x => [ 1, 2, 3, 4, 5 ],
            y => [ 1, 2, 3, 4, 5 ],
        }
    );
    is( $psnr->bpp, 8 );
};

subtest 'Not set x' => sub {
    dies_ok {
        new Math::PSNR( { y => [ 1, 2, 3, 4, 5 ], } );
    }
};

subtest 'Not set y' => sub {
    dies_ok {
        new Math::PSNR( { x => [ 1, 2, 3, 4, 5 ], } );
    }
};

done_testing;
