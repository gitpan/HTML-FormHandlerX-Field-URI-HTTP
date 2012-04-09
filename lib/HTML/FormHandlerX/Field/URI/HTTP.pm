package HTML::FormHandlerX::Field::URI::HTTP;

use Moose;
use Moose::Util::TypeConstraints;

extends 'HTML::FormHandler::Field::Text';

use version; our $VERSION = version->declare("v0.1");

use URI;
use Regexp::Common qw(URI);

has 'scheme' => (
    is         => 'rw',
    isa        => 'RegexpRef',
    required   => 1,
    default    => sub { qr/https?/i },
);

our $class_messages = {
    'uri_http_invalid' => 'HTTP URI is invalid.',
};

sub get_class_messages {
    my $self = shift;
    return {
        %{$self->next::method},
        %{$class_messages},
    };
}

sub validate {
    my $self = shift;
    my $uri = $self->value;

    my $is_valid = 0;
    my $regex = $RE{URI}{HTTP}{-scheme => $self->scheme};
    if ($uri =~ m{^$regex$}) {
        $is_valid = 1;
        $self->_set_value(URI->new($uri));
    } else {
        $self->add_error($self->get_message('uri_http_invalid'));
    }

    return $is_valid;
}

__PACKAGE__->meta->make_immutable;
use namespace::autoclean;
1;

__END__
=pod

=head1 NAME

HTML::FormHandlerX::Field::URI::HTTP - an HTTP URI field

=head1 VERSION

0.1

=head1 SYNOPSIS

This field inherits from a Text field and is used to validate HTTP(S) URIs.
Validate values are inflated into an L<URI> object.

=head1 METHODS

Only one extra method is supported:

=head2 scheme

This method is used to set the type of regex used for validating the URI. By
default both HTTP and HTTPS URIs are marked as valid. You can set this to only
validate HTTP or HTTPS if you wish:

  scheme => qr/http/i,   # only validate HTTP URIs
  scheme => qr/https/i,  # only validate HTTPS URIs
  scheme => qr/https?/i, # validate both HTTP and HTTPS (default behaviour)

=head1 SEE ALSO

=over 4

=item L<HTML::FormHandler>

=item L<HTML::FormHandler::Field::Text>

=item L<Regexp::Common::URI::http>

=item L<URI>

=back

=head1 AUTHOR

 Roman F.
 romanf@cpan.org

=head1 COPYRIGHT

Copyright (c) 2011 Roman F.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


