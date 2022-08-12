use utf8;
package MyFood::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyFood::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 200

=head2 password

  data_type: 'char'
  is_nullable: 0
  size: 150

=head2 pw_reset_code

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 pw_changed

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 200 },
  "password",
  { data_type => "char", is_nullable => 0, size => 150 },
  "pw_reset_code",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "pw_changed",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<email_unique>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("email_unique", ["email"]);

=head1 RELATIONS

=head2 foods

Type: has_many

Related object: L<MyFood::Schema::Result::Food>

=cut

__PACKAGE__->has_many(
  "foods",
  "MyFood::Schema::Result::Food",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-08-12 16:38:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ym7df6uw5LcDrKHDgjvlww

sub get_foods_by_type {
  my $self = shift;
  my ($type) = @_;

  return $self->foods->search({
    food_type => $type,
  });
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
