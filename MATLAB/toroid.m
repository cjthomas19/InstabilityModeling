clear;

size = 200;
x = 1:size;
y = 1:size;

[my,mx] = meshgrid(y,x);

%M1 = (rand(size,size)-.5)*.2;
%M2 = (rand(size,size)-.5)*.2;

M1 = wgn(size, size, -45);
M2 = wgn(size, size, -45);

fig = figure;

ax = gca;
ax.NextPlot = "replaceChildren";

v = VideoWriter('Videos\2d_noise_3d_toroid.mp4','MPEG-4');
v.FrameRate = 40;
open(v);



tstep = .01;
numframes = 7000;
trange = 0:tstep:numframes*tstep;

a = .1;
b = -.4;
c = .1;
d = -.2;

mu = .28;
nu = 28.0;

theta = 0:pi/50:2*pi;
r = 1:1/50:3;
[R,T] = meshgrid(r,theta);
Z_top = sqrt(1-(R-2).^2);
Z_bottom = -sqrt(1-(R-2).^2);

for t=trange
    M1_d = zeros(size, size);
    M2_d = zeros(size, size);
    
    L1 = del2(M1);
    L2 = del2(M2);
    
    %L1(1,:) = 0;
    %L1(end,:) = 0;
    %L2(1,:) = 0;
    %L2(end,:) = 0;
    
    for ix=1:size
        
        downx = ix-1;
        upx = ix +1;
        
        if ix == 1
            downx = size;
        elseif ix == size
            upx = 1;
        end
        
        for iy=1:size
            downy = iy-1;
            upy = iy +1;
            if iy == 1
                downy = size;
            elseif iy == size
                upy = 1;
            end
            M1_d(ix,iy) = a*M1(ix,iy) + b*M2(ix,iy) + mu * ((M1(downx,iy)+M1(upx,iy)+M1(ix,downy)+M1(ix,upy))/4 - M1(ix,iy));
            M2_d(ix,iy) = c*M1(ix,iy) + d*M2(ix,iy) + nu * ((M2(downx,iy)+M2(upx,iy)+M2(ix,downy)+M2(ix,upy))/4 - M2(ix,iy));
            %M1_d(ix,iy) = M1(ix,iy) - M1(ix,iy)^3-0.05  -M2(ix,iy) + .00028 * L1(ix,iy);
            %M2_d(ix,iy) = 10*(M1(ix,iy) - M2(ix,iy) + .005 * L2(ix,iy));
        end
    end
    
    M1 = M1 + M1_d .* tstep;
    M2 = M2 + M2_d .* tstep;
    if mod(t, 1) == 0
        [X,Y,Z] = pol2cart(T,R,Z_top);
        [X2,Y2,Z2] = pol2cart(T,R,Z_bottom);
        
        for ir = 1:numel(r)
            for it = 1:numel(theta)
        
            ia = atan2(Z_top(it,ir),(R(it,ir)-2));
            ian = -atan2(Z_top(it,ir),(R(it,ir)-2));
            th = T(it,ir);
        
            x1 = min(max(floor(ia/pi * 100+100),1),200);
            x2 = min(max(floor(-ia/pi * 100+100),1),200);
        
            y = min(max(floor(th/(2*pi) * 200),1),200);
        
        
        
            diff1 = 2*M1(x1,y);
            diff2 = 2*M1(x2,y);
        
            X(it,ir) = X(it,ir)+diff1*cos(th)*cos(ia);
            Y(it,ir) = Y(it,ir)+diff1*sin(th)*cos(ia);
            Z(it,ir) = Z(it,ir)+diff1*sin(ia);
        
            X2(it,ir) = X2(it,ir)+diff2*cos(th)*cos(ia);
            Y2(it,ir) = Y2(it,ir)+diff2*sin(th)*cos(ia);
            Z2(it,ir) = Z2(it,ir)+diff2*sin(ia);
            end
        end

        surf(X,Y,Z);
        hold on;
        surf(X2,Y2,Z2);
        axis equal;
        shading interp;
        
        title("t = " + t);
        writeVideo(v,getframe(fig));
    end
    
    
end

close(v);
