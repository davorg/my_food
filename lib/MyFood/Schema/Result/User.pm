use utf8;
package MyFood::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyFood::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

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
  "email",
  { data_type => "varchar", is_nullable => 0, size => 200 },
  "password",
  { data_type => "char", is_nullable => 0, size => 150 },
  "pw_reset_code",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "pw_changed",
  { data_type => "integer", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<email_unique>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("email_unique", ["email"]);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-08-07 18:58:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qoGGWYrl6RHfZbuA0ybiMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
