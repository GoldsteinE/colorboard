package ColorBoard::Root;

use Dancer2 appname => 'ColorBoard::App';
use Dancer2::Plugin::DBIC;

prefix '/root';

hook before => sub {
    if (request->path =~ /^\/root\//) {
        session('user') && session('user')->login eq 'admin' or
            redirect '/';
    }
};

get '/' => sub {
    template 'root' => {
        title => 'root'
    };
};

get '/users/' => sub {
    my @users = rset('User')->all();
    template 'users' => {
        title => 'all users',
        users => \@users
    };
};

get '/boards/' => sub {
    my @boards = rset('Board')->all();
    print $boards[0]->description;
    template 'boards' => {
        title => 'all boards',
        boards => \@boards
    };
};

post '/boards/' => sub {
    my $shortcut = body_parameters->get('shortcut');
    $shortcut =~ s/(?:^\/|\/$)//g;
    my $name = body_parameters->get('name');
    my $description = body_parameters->get('description');
    rset('Board')->new_result({shortcut => $shortcut, name => $name, description => $description})->insert;
    redirect '/root/boards';
};

any '/boards/:shortcut/delete/' => sub {
    rset('Board')->search({shortcut => param 'shortcut'})->delete;
    redirect '/root/boards';
};

1;
