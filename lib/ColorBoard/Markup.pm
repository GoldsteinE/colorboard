package ColorBoard::Markup;

use Template::Plugin::Filter;
use base qw ( Template::Plugin::Filter );

use Regexp::Common qw ( URI );

sub filter {
    my ($self, $text) = @_;

    print "$RE{URI}{HTTP}";

    $text =~ s/\*\*(.*?)\*\*/<b>$1<\/b>/g;
    $text =~ s/__(.*?)__/<i>$1<\/i>/g;
    $text =~ s/%%(.*?)%%/<span class="spoiler">$1<\/span>/g;
    $text =~ s/($RE{URI})/<a href="$1" target="_blank">$1<\/a>/g;

    return $text;
}

1;
