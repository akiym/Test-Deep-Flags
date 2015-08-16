package Test::Deep::Flags;
use strict;
use warnings;
use parent qw/Exporter/;
use Test::Deep::Cmp;
use B ();

use constant NUMBER => B::SVp_IOK | B::SVp_NOK;
use constant STRING => B::SVp_POK;

our @EXPORT = qw/number string/;

our $VERSION = "0.01";

sub number ($) { __PACKAGE__->new(@_, type => 'number') }
sub string ($) { __PACKAGE__->new(@_, type => 'string') }

sub init {
    my ($self, $scalar, %args) = @_;
    $self->{$_} = $args{$_} for keys %args;

    my $sv_obj = B::svref_2object(\$scalar);
    $self->{sv_obj} = $sv_obj;
    $self->{flags} = $sv_obj->FLAGS;
    $self->{exp} = $scalar;
}

sub descend {
    my ($self, $got) = @_;
    if (Test::Deep::Cmp::cmp($got, $self->{exp}) != 0) {
        $self->{compare} = 1;
        return;
    }

    my $f1 = B::svref_2object(\$got)->FLAGS;
    my $f2 = $self->{flags};
    my $err = 0;
    if ($self->{type} eq 'number') {
        unless ($f1 & NUMBER and !($f1 & STRING)) {
            $self->{got_message} = "'$got' as a string";
            $err = 1;
        }
        unless ($f2 & NUMBER and !($f2 & STRING)) {
            $self->{exp_message} = $self->{type} . "('" . $self->{exp} . "') as a string";
            $err = 1;
        }
    } elsif ($self->{type} eq 'string') {
        unless (!($f1 & NUMBER) and $f1 & STRING) {
            $self->{got_message} = "$got as a number";
            $err = 1;
        }
        unless (!($f2 & NUMBER) and $f2 & STRING) {
            $self->{exp_message} = $self->{type} . '(' . $self->{exp} . ') as a number';
            $err = 1;
        }
    }

    return !$err;
}

sub diag_message {
    my ($self, $where) = @_;
    if ($self->{compare}) {
        return "Compared $where";
    }
    return "Mismatching flags in $where";
}

sub renderExp {
    my $self = shift;
    return defined $self->{exp_message} ? $self->{exp_message} : $self->{exp};
}

sub renderGot {
    my ($self, $got) = @_;
    return defined $self->{got_message} ? $self->{got_message} : $got;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Deep::Flags - Strictly checking string or number for Test::Deep

=head1 SYNOPSIS

    use Test::Deep;
    use Test::Deep::Flags;

    cmp_deeply(
        {
            foo => 'two',
        },
        {
            foo => number(1),
        }
    );

=head1 DESCRIPTION

Test::Deep::Flags is ...

=head1 LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym@gmail.comE<gt>

=cut
