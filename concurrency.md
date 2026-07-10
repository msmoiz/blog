# Async, threads, and concurrency

I'm going to explain the difference between the various high level concurrency
models through the lens of a job application process. The basic lifecycle looks
like this:

- Submit an application (1 minute)
- Wait for feedback (8 minutes)
- Process the feedback (1 minute)

The goal is to submit 10 applications in total to increase our chances (in
practice, that number is probably in the hundreds, right? but this makes the
math easier).

The basic approach is a single person submitting one application at a time and
waiting for each one to return before moving on to the next. This process takes
100 minutes (10 x 10 min). The main issue with this approach is that only one
application is pending at a time, and the others are sitting idle in the
meantime. This is a _single-threaded_ approach. One task is executed from start
to finish before the next begins.

One way to solve this is to throw more bodies at the problem. Instead of one
person sending applications, you hire 10. Each one sends one application at the
same time, and the whole affair is done in 10 minutes (10 x 10min / 10 workers).
That's a 90% speed up! The tradeoff is cost: you now have to pay 10 people
instead of one. This is a _multi-threaded_ approach. Threads allow you to
execute concurrently but they consume resources in the process. What makes it
worse is that most of the time, your workers are just sitting around twiddling
their thumbs. During the waiting period, which dwarfs the time it takes to
complete the other two steps, the worker is doing nothing (the ball is in the
reviewer's court). This insight is at the heart of the next approach.

Instead of hiring 10 workers, what if you have just one worker jump between 10
different tasks? Once the worker submits an application, they can move on to the
next one while the first is being reviewed. In fact, the worker can submit all
10 applications at once and then wait for them together. The total time to
execute this approach is 20 minutes: 10 minutes for initial submission, 10
minutes for post-processing, and no idle time waiting for applications to be
reviewed. That is a bit slower than hiring 10 people, but it achieves much
better performacne than the baseline and is much more resource-efficient than
the hiring approach. This is the _async_ approach. It is characterized by a
single thread bouncing around between tasks and yielding to the next one at a
wait point.

You can also pair these approaches by having multiple threads switch between
tasks to increase throughput at the cost of more resources, while ensuring that
each thread is being fully utilized.

Note that the performance benefits of an async approach directly correlate to
the amount of time spent waiting (aka: I/O) relative to the amount of time spent
processing (aka: CPU). The heavier you lean toward the latter, the less
impactful this approach will be because there is less idle time to recoup. For
this reason, it is usually a good idea to spin heavy computations out into their
own thread to avoid blocking the async runtime threads, which should remain
nimble. As with most things in this vein, the right approach will depend on the
specific workload.
