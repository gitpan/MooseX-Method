use MooseX::Meta::Method::Signature;
use MooseX::Meta::Signature::Named;
use Test::More;
use Test::Exception;

use strict;
use warnings;

plan tests => 7;

throws_ok { MooseX::Meta::Method::Signature->wrap_with_signature (0,sub {}) } qr/Signature is not a/;

throws_ok { MooseX::Meta::Method::Signature->wrap_with_signature (bless ({},'Foo'),sub {}) } qr/Signature is not a/;

{
  my $signature = MooseX::Meta::Signature::Named->new;

  my $method = MooseX::Meta::Method::Signature->wrap_with_signature ($signature,sub {});

  isa_ok ($method,'MooseX::Meta::Method::Signature');

  isa_ok ($method,'Moose::Meta::Method');

  ok ($method->has_signature);

  isa_ok ($method->signature,'MooseX::Meta::Signature::Named');
}

{
  my $method = MooseX::Meta::Method::Signature->wrap (sub {});

  ok (! $method->has_signature);
}

