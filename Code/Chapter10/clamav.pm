package ClamAV;
use strict;

our $CLAMD_SOCK = "/var/run/clamav/clamd.ctl";   # change me
#our $CLAMD_SOCK = "/tmp/clamd.sock";   # change me
#our $CLAMD_SOCK = 3310;               # for TCP-based usage


use Mail::SpamAssassin;
use Mail::SpamAssassin::Plugin;
use File::Scan::ClamAV;
our @ISA = qw(Mail::SpamAssassin::Plugin);

sub new {
  my ($class, $mailsa) = @_;
  $class = ref($class) || $class;
  my $self = $class->SUPER::new($mailsa);
  bless ($self, $class);
  $self->register_eval_rule ("check_clamav");
  return $self;
}

sub check_clamav {
  my ($self, $permsgstatus, $fulltext) = @_;
  my $clamav = new File::Scan::ClamAV(port => $CLAMD_SOCK);
  my ($code, $virus) = $clamav->streamscan(${$fulltext});
  my $isspam = 0;
  my $header = "";
  if(!$code) {
    my $errstr = $clamav->errstr();
    Mail::SpamAssassin::Plugin::dbg("ClamAV: Error scanning: $errstr");
    $header = "Error ($errstr)";
  } elsif($code eq 'OK') {
    Mail::SpamAssassin::Plugin::dbg("ClamAV: No virus detected");
    $header = "No";
  } elsif($code eq 'FOUND') {
    Mail::SpamAssassin::Plugin::dbg("ClamAV: Detected virus: $virus");
    $header = "Yes ($virus)";
    $isspam = 1;
  } else {
    Mail::SpamAssassin::Plugin::dbg("ClamAV: Error, unknown return code: $code");
    $header = "Error (Unknown return code from ClamAV: $code)";
  }
  $permsgstatus->{main}->{conf}->{headers_spam}->{"Virus"} = $header;
  $permsgstatus->{main}->{conf}->{headers_ham}->{"Virus"} = $header;
  # add a metadatum so that rules can match against the result too
  $permsgstatus->{msg}->put_metadata('X-Spam-Virus',$header);
  return $isspam;
}

1;