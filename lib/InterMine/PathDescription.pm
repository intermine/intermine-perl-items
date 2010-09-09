package InterMine::PathDescription;

use Moose;
extends 'InterMine::PathFeature';
with 'InterMine::Roles::CommonAttributes' => {
    -excludes => [qw/name model/],
};

has '+description' => (required => 1);

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    if (@args != 2) {
	return $class->$orig(@args);
    }
    else {
	my %args;
	@args{qw/path description/} = @args;
	return $class->$orig(%args);
    }
};

before description => sub {
    my $self = shift;
    confess "Cannot change description - it is read-only" if @_;
};

override to_hash => sub {
    my $self = shift;
    return (pathString => $self->path, description => $self->description);
};

override to_string => sub {
    my $self = shift;
    return super . q{: "} . $self->description . q{"};
};
