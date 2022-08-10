package MyFood;
use Dancer2;

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::CryptPassphrase;

our $VERSION = '0.1';

get '/' => sub {
  template 'index' => { 'title' => 'MyFood' };
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
    session user => $user;

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

true;

# TODO: Move to utilities library
sub login {
  my ($email, $pass) = @_;
  my $user;

  warn "Looking for $email\n";

  return unless $user = schema('default')->resultset('User')->find({ email => $email });

  warn "Found user. Checking password\n";
  warn "$pass / ", $user->password, "\n";
  return unless verify_password($pass, $user->password);

  warn "Password matches\n";

  return $user;
}