clear;

syms t th z(th, t)
theta = linspace(0, 2*pi, 100);

x = cos(theta);
y = sin(theta);

z(th, t) = cos(t*th)


h = figure;
axis([-1,1,-1,1,-1,1])


ax = gca;
ax.NextPlot = "replaceChildren";

v = VideoWriter('Videos\newfile2.avi','Uncompressed AVI');
open(v);


loops = 40;

for i = 0:loops
    plot3(x, y, z(theta, i/20))
    writeVideo(v,getframe(h));
end

close(v);


