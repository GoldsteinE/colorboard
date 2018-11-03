package ColorBoard::API;

use Dancer2 appname => 'ColorBoard::App';
use Dancer2::Plugin::DBIC;


prefix undef;

sub boardInfo {
    my $board = shift;
    my $postCount = rset('Post')->search_rs({board_id => $board->id})->count;
    return {
            shortcut => $board->shortcut,
            name => $board->name,
            description => $board->description,
            count => $postCount
    };
}

get '/_boards.json' => sub {
    my @boards = rset('Board')->all();
    my @result;
    foreach my $board (@boards) {
        my $lastPostTime = rset('Post')->search_rs({board_id => $board->id}, {order_by => 'timestamp'})->first()->timestamp;
        my $boardData = boardInfo $board;
        $boardData->{lastPostAt} = $lastPostTime;
        push @result, $boardData;
    }

    response_headers 'Content-Encoding' => 'utf-8', 'Content-Type' => 'application/json';
    encode_json \@result;
};

get '/:board.json' => sub {
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

    my @result;
    foreach my $post (@posts) {
        push @result, {
            text => $post->text,
            color => $post->author->color,
            timestamp => $post->timestamp
        };
    }
    response_headers 'Content-Encoding' => 'utf-8', 'Content-Type' => 'application/json';
    encode_json {
        posts => \@result,
        info => boardInfo $board
    };
}
