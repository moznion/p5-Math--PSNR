#!perl

use strict;
use warnings;
use utf8;
use Math::PSNR qw/mse/;

BEGIN {
    use Test::Exception;
    use Test::More tests => 3;
}

my ( $expect, $got, $list1, $list2 );

subtest 'Calc MSE about the same array' => sub {
    $list1 = [ 1, 2, 3, 4, 5 ];
    $list2 = [ 1, 2, 3, 4, 5 ];
    $expect = 0;
    $got = mse( $list1, $list2 );
    is( $got, $expect );
};

subtest 'Calc MSE about the different array' => sub {
    $list1 = [ 1.1, 2.2, 3.3, 4.4, 5.5 ];
    $list2 = [ 9.9, 8.8, 7.7, 6.6, 5.5 ];
    $expect = 5.808;
    $got = mse( $list1, $list2 );
    is( sprintf( "%.3f", $got ), sprintf( "%.3f", $expect ) );
};

subtest 'Calc MSE between defferent length arrays' => sub {
    $list1 = [ 1, 2, 3, 4, 5 ];
    $list2 = [ 1, 2, 3 ];
    dies_ok { mse( $list1, $list2 ) };
};

done_testing();
