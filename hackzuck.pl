#!/usr/bin/env perl

use Curses;
use Time::HiRes;
use strict;

initscr;
curs_set(0); # hide cursor
my $win = Curses->new;

noecho();
halfdelay(1);
#cbreak();
keypad(stdscr, 1);


sub DESTROY { echo(); curs_set(1); endwin; }

my $timer = newwin(3,10,1,1);

my $teamA = newwin(3,15,20,20);
$teamA->border('|', '|', '−', '−', '+', '+', '+', '+');
my $punkteA = 0;
&updateA;

my$teamB = newwin(3, 15, 20, COLS() - 20);
my $punkteB = 0;
&updateB;

my $center = newwin(5, 40, LINES() / 2, COLS() / 2 - 20);
#$center->attron(A_REVERSE);

my $begriff = "JEOPARDY";

my $t = 15;
$timer->addstring(0,0,"Time: $t    ");
$timer->refresh;

refresh;

$SIG{ALRM} = sub {--$t; $timer->addstring(0,0,"Time: $t  "); $timer->refresh; Time::HiRes::alarm(1);};

Time::HiRes::alarm(1);

$center->border('|', '|', '-', '-', '+', '+', '+', '+');
&alert($begriff);

while (1) {
  my $c = getch();
  if ($c eq 'a') {
    ++$punkteA;
    &updateA;
  } elsif ($c eq 'b') {
    ++$punkteB;
    &updateB;
  } elsif ($c eq ' ') {
    Time::HiRes::alarm(0);
    alert("HORN");
  } elsif ($c eq 'q') {
    exit;
  } elsif ($c eq 'r') {
    $center->clear;
    $center->border('|', '|', '-', '-', '+', '+', '+', '+');
    &alert($begriff);
    $center->refresh;
    $t = 15;
    $timer->addstring(0,0,"Time: $t    ");
    Time::HiRes::alarm(1);

    $punkteA = 0;
    $punkteB = 0;
    &updateA;
    &updateB;
    $timer->refresh;
  }
  if ($t <= 0) {
    Time::HiRes::alarm(0);
    &alert("STOP");
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

sub alert {
  my $msg = shift;
  my $pad = ' ' x ((37 - length($msg))/2);
  $center->addstring(2,2, $pad . $msg . $pad);
  $center->refresh;
}
