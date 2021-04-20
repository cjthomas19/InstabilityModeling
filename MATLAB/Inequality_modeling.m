%diffusive instabiltiy inequalities

clear, close


%decide n,m
m = .5;
n=2.5;
b=1;
c=-3;
%alternatively, ask user:
% m=input('Please enter a value for mu: ');
% n=input('Please enter a value for nu: ');
% b=input('Please enter a value for b: ');
% c=input('Please enter a value for c: ');

a= -10:.05:10;
d= a; %we almost always want a square grid


bv=2*ones(1,length(a));
cv=-2*ones(1,length(a)); %make b and c vectors like a and d

[ax,dx]=meshgrid(d,a);
H=real(2*sqrt(n*m*(ax.*dx-cv.*bv)));
range = find(H==0); 
H(range) = NaN; %hides all values where H=0
G = real(ax*n+dx*m);
figure
J=G-H;
s1 = surf(ax,dx,J); %graphs upper boundary surface 
axis([min(a),max(a),min(d),max(d),0,1.25*max(max(H))]);
s1.EdgeColor = 'none'; %or else it displays black
colormap winter
%s2=surf(ax,dx,G);
%s2.EdgeColor='none'; %for graphing the plane separately