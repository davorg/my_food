use utf8;
package MyFood::Schema::Result::Food;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyFood::Schema::Result::Food

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<food>

=cut

__PACKAGE__->table("food");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 food_type

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "food_type",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_user_id_unique>

=over 4

=item * L</name>

=item * L</user_id>

=back

=cut

__PACKAGE__->add_unique_constraint("name_user_id_unique", ["name", "user_id"]);

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<MyFood::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "MyFood::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-08-12 16:38:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ApEus99Kd3+dbelbQQY/IA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
