%diffusive instabiltiy inequalities

clear, close


%decide n,m
m = .5;
n=2.5;
b=2.5;
c=-1.25;
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
s3 = surf(ax,dx,J); %graphs surface 
axis([0,max(a),min(d),max(d),0,1.25*max(max(H))]);
s3.EdgeColor = 'none'; %or else it displays black
xlabel('a','FontWeight', 'bold', 'FontSize', 13)
ylabel('d','FontWeight', 'bold', 'FontSize', 13);
zlabel('J = a\nu + d\mu - 2(\mu\nu(ad-bc))^{1/2}','FontWeight', 'bold', 'FontSize', 13);
title('Allowed values of a,d Given \mu=.5, \nu=2.5, b=2.5, c=-1.25');
colormap winter
hold on
% s2=surf(ax,dx,G);
% s1=surf(ax,dx,H);
% s2.EdgeColor='none'; %for graphing the plane separately
% s1.EdgeColor='none';