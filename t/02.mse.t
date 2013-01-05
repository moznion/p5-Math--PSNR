#!perl

use strict;
use warnings;
use utf8;
use Math::PSNR;

BEGIN {
    use Test::Exception;
    use Test::More tests => 3;
}

my ( $expect, $got, $list1, $list2 );
my $psnr = new Math::PSNR(
    {
        bpp => 8,
        x   => [ 1, 2, 3, 4, 5 ],
        y   => [ 1, 2, 3, 4, 5 ],
    }
);

subtest 'Calc MSE about the same array' => sub {
    $expect = 0;
    $got = $psnr->mse;
    is( $got, $expect );
};

subtest 'Calc MSE about the different array' => sub {
    $psnr->x( [ 1.1, 2.2, 3.3, 4.4, 5.5 ] );
    $psnr->y( [ 9.9, 8.8, 7.7, 6.6, 5.5 ] );
    $expect = 29.04;
    $got = $psnr->mse;
    is( sprintf( "%.2f", $got ), sprintf( "%.2f", $expect ) );
};

subtest 'Calc MSE between defferent length arrays' => sub {
    $psnr->x( [ 1, 2, 3, 4, 5 ] );
    $psnr->y( [ 1, 2, 3 ] );
    dies_ok { $psnr->mse };
};

done_testing;
