#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use MyFood;

MyFood->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use MyFood;
use Plack::Builder;

builder {
    enable 'Deflater';
    MyFood->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use MyFood;
use MyFood_admin;

use Plack::Builder;

builder {
    mount '/'      => MyFood->to_app;
    mount '/admin'      => MyFood_admin->to_app;
}

=end comment

=cut

