package InterMine::Constraint;

use Moose;
use warnings FATAL => 'misc'; # We want bad hash assignment to die

extends 'InterMine::PathFeature';

# Returns true if the arg list passed to it would meet the requirements of the class
# Note: this DOES NOT GUARANTEE that the arg list is valid, as INVALID args may be present
# as well - but is used for constraint class selection in the query classes
sub requirements_are_met_by {
    my $class = shift;
    my %args  = @_;
    my @required_attributes = grep {$_->is_required} $class->meta->get_all_attributes;
    my $matches = 0;
    for my $name (keys %args) {
        if (my ($attr) = grep {$name eq $_->name} @required_attributes) {
            $matches++ # don't die, because that kind of defeats the point
		if eval{$attr->verify_against_type_constraint($args{$name})};
        }
    }
    return ($matches == @required_attributes);
}

sub _build_element_name {
    return 'constraint';
}
__PACKAGE__->meta->make_immutable;
no Moose;
1;
