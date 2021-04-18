clear;
theta = linspace(0,2*pi, 1000);

x = cos(theta);
y = sin(theta);

M1 = (rand(1,numel(theta))-.5)*.005;
M2 = (rand(1,numel(theta))-.5)*.005;

%M1 = .01 * cos(32*theta);
%M2 = .01 * cos(32*theta);

%M1 = zeros(1,numel(theta))
%M2 = zeros(1,numel(theta))

fig = figure;

ax = gca;
ax.NextPlot = "replaceChildren";

v = VideoWriter('Videos\activator_inhibitor.avi','Uncompressed AVI');
v.FrameRate = 40;
open(v);



tstep = .01;
numframes = 400;
trange = 0:tstep:numframes*tstep;

a = 1;
b = -4;
c = 1;
d = -2;

mu = .05;
nu = 2.5;

for t=trange
    M1_d = zeros(1, numel(theta));
    M2_d = zeros(1, numel(theta));
    
    for in=1:numel(theta)
        
        down = in-1;
        up = in+1;
        if in == 1
            down = numel(theta);
        elseif in == numel(theta)
            up = 1;
        end
        
        M1_d(in) = a * M1(in) + b * M2(in) + mu * (M1(down) - 2 * M1(in) + M1(up));
        M2_d(in) = c * M1(in) + d * M2(in) + nu * (M2(down) - 2 * M2(in) + M2(up));
    end
    
    M1 = M1 + M1_d * tstep;
    M2 = M2 + M2_d * tstep;
    
    plot3([x,x(1)], [y,y(1)], [M1,M1(1)]);
    hold on;
    plot3([x,x(1)],[y,y(1)],[M2,M2(1)]);
    hold off;
    axis([-1,1,-1,1,-0.1,0.1]);

    writeVideo(v,getframe(fig));
    
end

close(v);
