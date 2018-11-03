package ColorBoard::App;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Digest::SHA qw(sha512_hex);
use POSIX qw(floor);

use ColorBoard::Root;
use ColorBoard::API;

our $VERSION = '0.1';

prefix undef;

get '/' => sub {
    my @boards = rset('Board')->all();
    template 'index' => { 'title' => 'главная', boards => \@boards, pageclass => 'index' };
};


get qr{^(.*[^/])$} => sub {
    my ($url) = splat;
    return pass if $url =~ /\.json$/;
    redirect($url . '/');
};

get '/markup/' => sub {
    template 'markup' => {
        title => 'разметка',
        samples => [
            "http://ya.ru\nhttps://ya.ru",
            "__italic__",
            "**bold**",
            "%\%spoiler%%"
        ]
    };
};

get '/register/' => sub {
    if (session 'user') {
        return redirect '/';
    }
    my $nonUnique = query_parameters->get('error');

    sub randPart() {
        my $part = floor(rand() * 182) + 40;
        $part -= ($part % 10);
        $part;
    }
    my ($red, $green, $blue) = (randPart, randPart, randPart);

    template 'register' => {
        title => 'register',
        error => ($nonUnique && "this $nonUnique is already registered"),
        initialColor => sprintf('#%x%x%x', $red, $green, $blue)
    } => { layout => 'tech' };
};

post '/register/' => sub {
    my $username = body_parameters->get('username');
    my $password = body_parameters->get('password');
    my $passwordHash = sha512_hex($password);

    my $color = (body_parameters->get('color') =~ s/^#//r);
    $color =~ /(..)(..)(..)/;
    my ($red, $green, $blue) = (hex $1, hex $2, hex $3);
    if ($red + $green + $blue > 666 || $red + $green + $blue < 120) {
        return redirect '/register/?error=color';
    }
    $red -= ($red % 10);
    $green -= ($green % 10);
    $blue -= ($blue % 10);
    $color = sprintf('%x%x%x', $red, $green, $blue);

    my $sameUsername = rset('User')->search_rs({login => $username})->first();
    if (defined $sameUsername) {
        return redirect '/register/?error=username';
    }
    my $sameColor = rset('User')->search_rs({color => $color})->first();
    if (defined $sameColor) {
        return redirect '/register/?error=color';
    }
    my $user = rset('User')->new_result({login => $username, color => $color, passhash => $passwordHash});
    $user->insert;
    session user => $user;
    redirect (query_parameters->get('return') || '/');
};

get '/login/' => sub {
    if (session 'user') {
        return redirect '/';
    }

    template 'login' => {
        title => 'log in',
        error => (query_parameters->get('failed') && 'failed to log in')
    } => { layout => 'tech' };
};

post '/login/' => sub {
    my $username = body_parameters->get('username');
    my $password = body_parameters->get('password');
    my $passwordHash = sha512_hex($password);
    my $user = rset('User')->search_rs({login => $username, passhash => $passwordHash})->first();
    if (defined $user) {
        session user => $user;
        redirect (query_parameters->get('return') || '/');
    } else {
        redirect '/login/?failed=1';
    }
};

any '/logout/' => sub {
    app->destroy_session;
    redirect '/';
};

get '/:board/' => sub {
    my $board = rset('Board')->find({shortcut => param 'board'});
    return send_error('Not found', 404) unless defined $board;
    my @posts = reverse rset('Post')->search(
        {
            board_id => $board->id
        },
        {
            order_by => { '-desc' => 'timestamp' },
            rows => 20
        }
    );
    template 'board' => {
        title => $board->name,
        description => $board->description,
        board => $board,
        posts => \@posts
    }
};

post '/:board/' => sub {
    my $user = session 'user'
        or return redirect '/login/';

    my $board = rset('Board')->find({shortcut => param 'board'});

    my $message = body_parameters->get('message');
    rset('Post')->new_result({board => $board, author => $user, text => $message, timestamp => time})->insert;
    redirect('/' . (param 'board') . '/#new-post');
};

true;
