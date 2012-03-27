package Subs;

## Subroutines common to all programs. Although this is a package, we
## simply 'requier' it for ease of installation. CPAN you say?

sub verbose {
  if ($VERBOSE) {
    print STDERR @_, "\n";
  }
  return;
}



## Doesn't DBI provide a helper for this?
sub _open_dbh {
    my $type = shift || 'source';
    
    ## If type is 'target', we use an alternative set of options,
    ## simply distinguished by a consistent prefix
    my $option_prefix = $type eq 'target' ? 'target' : '';
    
    ## Read the options
    my $host = $OPTIONS->{"$option_prefix\host"} || '';
    my $port = $OPTIONS->{"$option_prefix\port"} || '';
    my $user = $OPTIONS->{"$option_prefix\user"} || undef;
    my $password = $OPTIONS->{"$option_prefix\password"} || undef;
    my $database = $OPTIONS->{"$option_prefix\database"} || 'information_schema';
    
    ## We 'DNS-ify' some of the options:
    $host = ";host=$host" if $host;
    $port = ";port=$port" if $port;
    
    ## And handle a couple of others...
    my $block = $OPTIONS->{blocking_select} ? ";mysql_use_result=1" : '';
    my $extra = ";mysql_local_infile=1";
    
    ## I don't know why I don't like looking at this:
    my $dsn = "DBI:mysql:database=$database$host$port$block$extra";
    
    return
      DBI->connect( $dsn, $user, $password, { RaiseError => 1 } );
}
