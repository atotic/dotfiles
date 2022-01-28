# PERFORMACE
NG:
http://pprof.corp.google.com/user-profile?id=7de759cb80771a34acbdd28dd32a17cb&tab=flame
Legacy:
http://pprof.corp.google.com/user-profile?id=40eea2be78bdd7a8c96371948236875a&tab=flame

file:///usr/local/google/home/atotic/chromium/layoutng/tables/50000-random.html
2x50,000  table
May 25, fully optimized
2744296   20.4g 546.0m   0.0   0.3   0:19.01 content_shell
2744583   20.4g 492.6m   0.0   0.3   0:17.76 content_shell

Apr 28
489166   21.8g   1.8g 109.5   1.0   2:19.44 content_shell NG
489503   21.7g   1.2g   0.0   0.7   2:19.24 content_shell

Feb 12
42022   36.7g 955.1m   0.0   0.5   1:02.48 content_shell NG
42318   36.7g 848.8m   0.0   0.4   0:55.47 content_shell

Firefox: 3 seconds

Jan 7
950.1m   0.3   0.5   1:07.70 content_shell  NG
845.5m   0.0   0.4   0:54.74 content_shell

Dec 23 after the fix
3853570 950.9m   0.0   0.5   1:03.50 content_shell  NG
3853829 847.0m   2.6   0.4   0:57.33 content_shell Legacy

Dec 15 could cache miss happen because we were doing memcmp?
Not memcmp. Got to profile instead.
3576733   36.7g 950.3m   0.0   0.5   1:37.01 content_shell
3577099   36.6g 847.5m   0.0   0.4   0:57.16 content_shell

Nov 30 without numbered cells, still 50% slower
797390   36.6g 711.7m   0.0   0.4   1:07.63 content_shell
797675   36.6g 651.2m   0.0   0.3   0:42.91 content_shell

Nov 30 dcheck_always_on = false. Difference still holds, 50% slower
677031   36.5g 613.5m   0.0   0.3   0:22.26 content_shell
677224   36.5g 568.4m   0.0   0.3   0:14.44 content_shell

Nov 30
522478   36.6g 948.3m   0.0   0.5   1:33.01 content_shell
522929   36.6g 843.9m   0.0   0.4   0:54.68 content_shell

Oct 30 -- ian cacheing, simple layout. Still a lot slower.
1312260 5477.0m 928.9m   0.0   0.5   1:23.00 content_shell
1312595 5314.8m 819.1m   0.0   0.4   0:56.64 content_shell`

Sep 26 -- with NGConstraintSpaceTableData replacement
- not any faster, but 200m less memory.
2590278 5531.1m 997.2m   0.0   0.5   1:45.83 content_shell
2591171 5307.7m 828.1m   0.0   0.4   1:19.92 content_shell

Sep 25 -- after ComputeInitialFragmentSize
25s, 380m worse than Legacy
2319920 5718.7m   1.2g   0.0   0.6   1:44.38 content_shell
2320863 5306.6m 824.8m   0.0   0.4   1:19.31 content_shell

Aug2 -- before cacheing of table borders.
322523 5789.8m   1.2g   0.0   0.7   1:26.58 content_shell

Jul14 - after RareData, no difference
193386 5793.8m   1.2g   0.0   0.7   1:27.25 content_shell
193101 5409.2m 932.5m   0.0   0.5   0:56.15 content_shell

Jul1 - NG/Legacy both grew by 10s
3365715 5768.7m   1.2g   0.0   0.7   1:27.37 content_shell
3366018 5407.7m 933.8m   0.0   0.5   1:01.09 content_shell

Loading 5MB table:
136339 5700.6m   1.2g   0.0   0.6   1:16.12 content_shell
36732 5372.8m  908.7m   0.0   0.5   0:51.99 content_shell
