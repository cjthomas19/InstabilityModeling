%diffusive instabiltiy inequalities

clear


%decide n,m
m = .5;
n=2.5;

a= -10:.05:10;

d= -10:.05:10;
%fix b,c;
b=2*ones(1,length(a));

c=-2*ones(1,length(a));

[ax,dx]=meshgrid(d,a);
H=real(2*sqrt(n*m*(ax.*dx-c.*b)));
range = find(H==0);
H(range) = NaN;
%ax(range) = [];
%dx(range) = [];
G = real(ax*n+dx*m);
s1 = surf(ax,dx,H);
s1.EdgeColor = 'none';
hold on
s2=surf(ax,dx,G);
s2.EdgeColor='none';