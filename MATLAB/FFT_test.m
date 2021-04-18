clear;
N = 1000;
theta = linspace(0,2*pi, N);

x = cos(theta);
y = sin(theta);

M1 = (rand(1,numel(theta))-.5)*.005;
M2 = (rand(1,numel(theta))-.5)*.005;

%M1 = cos(100*theta) * .05;
%M2 = sin(100*theta) * .05;

z = ifft(M1);
n = ifft(M2);

syms p s a b c d mu nu NN ps(s) psp(s)

eq1 = (p-a+4*mu*sin(pi*s/NN)^2)*(p - d + 4*nu *sin(pi*s/NN)^2) == b * c;
p = solve(eq1, p);

ps(s) = simplify(subs(p(1), [a,b,c,d,mu,nu,NN],[1,-4,1,-2,1,25,N]));
psp(s) = simplify(subs(p(2), [a,b,c,d,mu,nu,NN],[1,-4,1,-2,1,25,N]));

ps = double(ps(1:N));
psp = double(psp(1:N));

zs = zeros(1,N);
ns = zeros(1,N);
b = -4;

v = VideoWriter("FFT_test.mp4","MPEG-4");
open(v);
h = figure;

ax = gca;
ax.NextPlot = "replaceChildren";
for t=0:.1:20
    for i=1:N

        As = double((n(i) * b - z(i) * psp(i))/(ps(i)-psp(i)));
        Bs = double(-(n(i) * b - z(i) * ps(i))/(ps(i)-psp(i)));
        Cs = double((n(i) * b *ps(i) - z(i) * psp(i) * ps(i))/(b*(ps(i)-psp(i))));
        Ds = double(-psp(i) * (n(i)*b - z(i) * ps(i))/(b*(ps(i)-psp(i))));

        zs(i) = double(As * exp(ps(i)*t) + Bs * exp(psp(i)*t));
        ns(i) = double(Cs * exp(ps(i)*t) + Ds * exp(psp(i)*t));

        

    end
    xr = real(fft(zs));
    yr = real(fft(ns));
    plot3([x,x(1)],[y,y(1)], [xr,xr(1)]);
    hold on;
    plot3([x,x(1)],[y,y(1)], [yr,yr(1)]);
    hold off;
    axis([-1,1,-1,1,-1,1]);
    title("t = " + t)
    writeVideo(v, getframe(h));
end

close(v);



