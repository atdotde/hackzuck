#!/usr/bin/env perl

use Curses;
use Time::HiRes;
use strict;

curs_set(0); # hide cursor
my $win = Curses->new;

noecho();
#halfdelay(1);
cbreak();
keypad(stdscr, 1);

my $timer = newwin(3,10,1,1);

my $teamA = newwin(3,15,20,20);
my $punkteA = 0;
&updateA;


my$teamB = newwin(3, 15, 20, COLS() - 20);
my $punkteB = 0;
&updateB;

my $center = newwin(3, 30, LINES() / 2, COLS() / 2 - 15);


sub DESTROY { curs_set(1); endwin; }
my $t = 15;
$timer->addstring(0,0,"Time: $t\n");
$timer->refresh;
  
$SIG{ALRM} = sub {--$t; $timer->addstring(0,0,"Time: $t\n"); $timer->refresh; Time::HiRes::alarm(1);};

Time::HiRes::alarm(1);

while (1) {
  my $c = getch();
  if ($c eq 'a') {
    ++$punkteA;
    &updateA;
  } elsif ($c eq 'b') {
    ++$punkteB;
    &updateB;
  }
  if ($t <= 0) {
    Time::HiRes::alarm(0);
    $center->addstring(1,1, "STOP");
    $center->refresh;
  }
}



sub updateA {
  $teamA->addstring(1,1,"Team A: $punkteA  ");
  $teamA->refresh;
}

sub updateB {
  $teamB->addstring(1,1,"Team B: $punkteB  ");
  $teamB->refresh;
}
