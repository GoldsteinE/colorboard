#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use ColorBoard::App;

ColorBoard::App->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use ColorBoard::App;
use Plack::Builder;

builder {
    enable 'Deflater';
    ColorBoard::App->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use ColorBoard::App;
use ColorBoard::App_admin;

use Plack::Builder;

builder {
    mount '/'      => ColorBoard::App->to_app;
    mount '/admin'      => ColorBoard::App_admin->to_app;
}

=end comment

=cut

