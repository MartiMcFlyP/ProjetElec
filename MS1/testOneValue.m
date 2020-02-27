clear
clc
importfile('Data_Measured.mat')

global c;
c = 299792458;

testedValue = 150;

global x1;
x1 = [xReceivers(1,1), xReceivers(1,1), xReceivers(1,1), xReceivers(1,2), xReceivers(1,2),xReceivers(1,3)];
global y1;
y1 = [xReceivers(2,1), xReceivers(2,1), xReceivers(2,1), xReceivers(2,2), xReceivers(2,2),xReceivers(2,3)];
global x2;
x2 = [xReceivers(1,2), xReceivers(1,3), xReceivers(1,4), xReceivers(1,3), xReceivers(1,4),xReceivers(1,4)];
global y2;
y2 = [xReceivers(2,2), xReceivers(2,3), xReceivers(2,4), xReceivers(2,3), xReceivers(2,4),xReceivers(2,4)];


global tau;
tau = TDOA(:,testedValue);
x0 = [5,5];
xlsqn = lsqnonlin(@func,x0);
xEst = xlsqn(1);
yEst = xlsqn(2);


% ---- PLOT ----
scatter(xReceivers(1,:),xReceivers(2,:),'filled')
str = [" R1"," R2"," R3"," R4"];
text(xReceivers(1,:),xReceivers(2,:), str)
hold on;

scatter(xEst,yEst,'*')
hold on;

text(-8, 12, "MSE = ")
hold on;

scatter(xTag(1,testedValue),xTag(2,testedValue),'o')
%legend('Récepteurs','Estimation','True pos')

syms xSym ySym
x = [xSym, ySym];
f1 = isolate(sqrt((x(1)-x2(1))^2+(x(1)-y2(2))^2)-sqrt((x(1)-x1(1))^2+(x(2)-y1(1))^2) == c*tau(1), x(2));
f2 = isolate(sqrt((x(1)-x2(2))^2+(x(2)-y2(2))^2)-sqrt((x(1)-x1(2))^2+(x(2)-y1(2))^2) == c*tau(2), x(2));
f3 = isolate(sqrt((x(1)-x2(3))^2+(x(2)-y2(3))^2)-sqrt((x(1)-x1(3))^2+(x(2)-y1(3))^2) == c*tau(3), x(2));
f4 = isolate(sqrt((x(1)-x2(4))^2+(x(2)-y2(4))^2)-sqrt((x(1)-x1(4))^2+(x(2)-y1(4))^2) == c*tau(4), x(2));
f5 = isolate(sqrt((x(1)-x2(5))^2+(x(2)-y2(5))^2)-sqrt((x(1)-x1(5))^2+(x(2)-y1(5))^2) == c*tau(5), x(2));
f6 = isolate(sqrt((x(1)-x2(6))^2+(x(2)-y2(6))^2)-sqrt((x(1)-x1(6))^2+(x(2)-y1(6))^2) == c*tau(6), x(2));
% ezplot(f,[xmin,xmax,ymin,ymax])
ezplot(f1, [-15,15,-15,15]);
%ezplot(f2, [-15,15,-15,15]);
%ezplot(f3, [-15,15,-15,15]);
%ezplot(f4, [-15,15,-15,15]);
%ezplot(f5, [-15,15,-15,15]);
%ezplot(f6, [-15,15,-15,15]);







function F = func(x)
    global x1;
    global x2;
    global y1;
    global y2;
    global c;
    global tau;
    F = [sqrt((x(1)-x2(2))^2+(x(2)-y2(2))^2)-sqrt((x(1)-x1(1))^2+(x(2)-y1(1))^2)-c*tau(1), sqrt((x(1)-x2(2))^2+(x(2)-y2(2))^2)-sqrt((x(1)-x1(2))^2+(x(2)-y1(2))^2)-c*tau(2), sqrt((x(1)-x2(3))^2+(x(2)-y2(3))^2)-sqrt((x(1)-x1(3))^2+(x(2)-y1(3))^2)-c*tau(3), sqrt((x(1)-x2(4))^2+(x(2)-y2(4))^2)-sqrt((x(1)-x1(4))^2+(x(2)-y1(4))^2)-c*tau(4), sqrt((x(1)-x2(5))^2+(x(2)-y2(5))^2)-sqrt((x(1)-x1(5))^2+(x(2)-y1(5))^2)-c*tau(5), sqrt((x(1)-x2(6))^2+(x(2)-y2(6))^2)-sqrt((x(1)-x1(6))^2+(x(2)-y1(6))^2)-c*tau(6)];
end



function importfile(fileToRead1)
    newData1 = load('-mat', fileToRead1);
    %Create new variables in the base workspace from those fields.
    vars = fieldnames(newData1);
    for i = 1:length(vars)
        assignin('base', vars{i}, newData1.(vars{i}));
    end
end