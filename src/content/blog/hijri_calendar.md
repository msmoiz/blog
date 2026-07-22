---
title: Creating a Hijri calendar
description: Using Claude to create a hundred-year calendar for Muslim holidays.
pubDate: 2026-07-21
---

I was a holdout for a long time in adopting AI into my coding practice, and I'm
still pretty skeptical of it in critical settings. But sometimes it does exactly
what I need it to do, and it's only fair to give credit where credit is due when
that happens.

The motivating problem is that I live on two distinct timelines. I generally
think and structure my affairs in terms of the Gregorian calendar, like the rest
of the Western world, but I am also Muslim, which means I need to keep track of
Muslim holidays. The trouble is that the Hijri calendar, which is based on the
movements of the moon, has 11 days less than the Gregorian calendar. This means
that if a given holiday lands on `x`, it will land on `x - 11` in the following
year. Over the course of years, this drift makes it impossible to look at a
solar date and intuit which Muslim holidays land on that date. As a result, I
forget about important dates easily, and I find myself flipping back and forth
between applications when I go to plan trips and other matters.

And so today I set about trying to create a Hijri calendar that I can embed into
a standard calendaring app, so that I can see holidays alongside the other
events in my life. There are two billion Muslims in the world, and you would
think that one of them must have already created such a calendar that I could
pick up off the shelf. Unfortunately, I am part of a very specific sect that has
its own very specific rules about how the calendar is organized and how dates
are calculated. Most Muslims use a flexible lunar calendar in which the length
of individual months depends on moon sightings (which is why sometimes they fast
for 29 days in Ramadaan and sometimes for 30). In contrast, our calendar months
have fixed lengths every year. We also have a bunch of holidays (called
_miqaats_) that are specific to our sect, and a general-purpose Muslim calendar
is not likely to cover those events.

There is an [app][app] that serves our community specifically, and it includes
an official calendar. However, you can only access that calendar in the app,
which is not ideal (see the note on jumping between applications above). I did
use this app as the starting point of the exercise though. My approach was
fairly simple: try to exfiltrate the calendar information from the app and add
the events to a Google calendar that I could then embed in other applications.

In the past I would have done a lot of the investigative work that goes into
this kind of endeavor myself. This time I just installed the app on my Macbook
and then tossed the problem at Claude Code. In short order, it sniffed out a
sqlite database baked into the app package that enumerated the 233 unique events
in the calendar for a given year. It then cobbled together a Rust script to
build out an _ics_ file with all of the events, mapped to the Gregorian calendar
and extrapolated for the next hundred years.

Along the way, it taught me a few things as well. For instance, it turns out
there are leap years in the lunar calendar! In fact, there are 11 leap years in
a 30-year cycle, and those years are allocated in different ways across that
cycle depending on the scheme ([wiki][wiki]). Claude figured out the right
scheme (unsurprisingly, our sect has its own) based on the dates in the database
as well as a handful of events that I could provide both lunar and solar dates
for (a sort of temporal Rosetta stone, if you will). I ran the script to
generate a calendar file, uploaded it as a Google calendar, and made it public
to share with friends. You can check it out here: [calendar][calendar].

Did I review the code? Only in the most cursory way. Did I build a deep
understanding of the domain? Not really. But sometimes, that's okay. I spend all
day long going deep on problems, and this is one that I could have gone deep on
as well, but the truth is that I will probably never need to use this knowledge
again. No one is going to ask me to calculate the Hijri date for a professional
project, and I doubt that even personal projects I pick up in this space will
tread the same ground. Leaning on an agent for this exercise let me tackle a
problem that has been bugging me for years, and that would have taken me a day
or two to address by hand, in an hour, without derailing my other tasks.

I am not super proud of the outcome, the way I might be with something I did by
hand, but I am pleased with it, and it provides real value in my life. Sometimes
you just need to get a thing done, and this was one of those things.

[app]: https://apps.apple.com/us/app/its-app/id720041429
[wiki]: https://en.wikipedia.org/wiki/Islamic_calendar
[calendar]: https://calendar.google.com/calendar/u/0?cid=ZWM0ZDA3Zjc1ZmQ4ZmM1MGU4MWMwMWJiM2ViNTFlYzQ0NjFiNmU3YTk0YmRmMzNlYmQ0NTVlYzcwY2I0YmQ5MkBncm91cC5jYWxlbmRhci5nb29nbGUuY29t
