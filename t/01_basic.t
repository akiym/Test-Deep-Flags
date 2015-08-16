use strict;
use warnings;
use utf8;
use Test::Tester;
use Test::More;
use Test::Deep;
use Test::Deep::Flags;

cmp_deeply(
    {
        foo => 1,
        bar => '1',
        baz => 'one',
    },
    {
        foo => number(1),
        bar => string('1'),
        baz => string('one'),
    }
);

check_test(sub {
    cmp_deeply(
        {
            foo => 1,
            bar => '2',
            baz => 'three',
        },
        {
            foo => number(1),
            bar => number(2),
            baz => string('three'),
        }
    );
}, {
    ok   => 0,
    diag => trim(<<'...'),
Mismatching flags in $data->{"bar"}
   got : '2' as a string
expect : 2
...
});

check_test(sub {
    cmp_deeply(
        {
            foo => 1,
        },
        {
            foo => string(1),
        }
    );
}, {
    ok   => 0,
    diag => trim(<<'...'),
Mismatching flags in $data->{"foo"}
   got : 1 as a number
expect : string(1) as a number
...
});

check_test(sub {
    cmp_deeply(
        {
            foo => 1,
        },
        {
            foo => number('1'),
        }
    );
}, {
    ok => 0,
    diag => trim(<<'...'),
Mismatching flags in $data->{"foo"}
   got : 1
expect : number('1') as a string
...
});

sub trim {
    my $s = shift;
    chomp($s);
    return $s;
}

done_testing;
