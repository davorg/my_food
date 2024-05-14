package MyFood;
use Dancer2;

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::CryptPassphrase;

use Sys::Hostname;

our $VERSION = '0.1';

get '/' => sub {
  my $args = {
    host => hostname,
  };

  if (my $email = session('user')) {
    warn "Logged in user is: $email\n";
    $args->{user} = get_user($email);
  } else {
    warn "Logged in user is: no-one\n";
  }

  template 'index' => $args;
};

get '/signup' => sub {
  template 'signup';
};

post '/signup' => sub {
  if (body_parameters->get('password') ne body_parameters->get('password2')) {
    return template 'signup', {
      error => 'Your passwords do not match',
      email => body_parameters->get('email')};
  }

  schema->resultset('User')->create({
    email => body_parameters->get('email'),
    password => hash_password(body_parameters->get('password')),
  });

  redirect '/signin';
};

get '/signin' => sub {
  template 'login';
};

post '/signin' => sub {
  if (my $user = login(body_parameters->get('email'),
                       body_parameters->get('password'))) {
    warn "Login succeeded\n";
    warn "Setting session user to: ", $user->email, "\n";
    session user => $user->email;
    warn "Session user is ", session('user'), "\n";

    if (my $path = session('goto')) {
      session goto => undef;
      warn "Redirecting to $path";
      redirect $path;
    } else {
      warn "Redirecting to /";
      redirect '/';
    }
  } else {
    warn "Login failed\n";
    template 'login', { error => 'Invalid login details.'}
  }
};

get '/signout' => sub {
  session user => undef;

  redirect '/';
};

post '/person/:person/food' => sub {
  my $sess_email  = session('user');
  warn "Sess: $sess_email\n";
  my $route_email = route_parameters->get('person');
  warn "Route: $route_email\n";

  if ($sess_email ne $route_email) {
    die "Wrong user: $route_email / $sess_email\n";
  }

  my $user = get_user($sess_email);

  for (qw[likes dislikes allergies]) {
    my $string = body_parameters->get($_);
    my @list = split /\n\r?/, $string;

    for my $food (@list) {
      $food =~ s/^\s+//;
      $food =~ s/\s+$//;
      next unless length $food;
      $user->foods->find_or_create({
        name => $food,
        food_type => uc substr $_, 0, 1,
      });
    }
  }

  redirect '/';
};

get '/food/:email' => sub {
  my $route_email = route_parameters->get('email');

  my $user = get_user($route_email);

  return 404 unless $user;

  template 'user', {
    user => $user,
  };
};

true;

# TODO: Move to utilities library
sub login {
  my ($email, $pass) = @_;
  my $user;

  warn "Looking for $email\n";

  return unless $user = get_user($email);

  warn "Found user. Checking password\n";
  warn "$pass / ", $user->password, "\n";
  return unless verify_password($pass, $user->password);

  warn "Password matches\n";

  return $user;
}

sub get_user {
  return unless @_;
  my ($email) = @_;

  return schema('default')->resultset('User')->find({ email => $email });
}
