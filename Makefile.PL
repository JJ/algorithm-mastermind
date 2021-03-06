use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Algorithm::MasterMind',
    AUTHOR              => 'JJ Merelo <jj@merelo.net>',
    VERSION_FROM        => 'lib/Algorithm/MasterMind.pm',
    ABSTRACT_FROM       => 'lib/Algorithm/MasterMind.pm',
	      LICENSE   => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
		  'Test::More' => 0,
		  'version'    => 0.77,
		  'Algorithm::Evolutionary' => 0.78, # for Evo.pm
		  'Algorithm::Combinatorics' => 0,
		  'String::MMM' => 0, # fast comparison
		  'BSD::Resource'=> 0 # for measuring time
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Algorithm-MasterMind-*' },
);
