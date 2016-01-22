function y = m3u3(x)

pcoefs(1,:,1) = [10.6918  -16.5987   6.1673    0.0000         0];
pcoefs(1,:,2) = [-37.7832  75.3105 -53.4253   16.2734   -1.6087];
pcoefs(1,:,3) = [4.1357   -5.6343   -3.3195    7.7104   -2.4659];

nsegs = 3;
xpts = [linspace(0, 1, nsegs + 1)];

y = utas(xpts, pcoefs, x);
